import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/StrConfig.dart';
import '../detail_page.dart';
import 'TrendItem.dart';
import 'gemini_service.dart';


void main() {
  runApp(const AiFoodApp());
}


class AiFoodApp extends StatelessWidget {
  const AiFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Text',
        scaffoldBackgroundColor: const Color(0xFFF8F5FF),
      ),
      home: const AiFoodChatScreen(),
    );
  }
}

// ───────────────────────────── Data Models ─────────────────────────────

class ChatMessage {
  final String role; // 'user' | 'assistant'
  final String text;
  final List<FoodCard>? foodCards;

  const ChatMessage({
    required this.role,
    required this.text,
    this.foodCards,
  });
}

class FoodCard {
  final String emoji;
  final String name;
  final String desc;
  final String tag;

  const FoodCard({
    required this.emoji,
    required this.name,
    required this.desc,
    required this.tag,
  });

  factory FoodCard.fromJson(Map<String, dynamic> j) =>
      FoodCard(
        emoji: j['emoji'] ?? '🍽️',
        name: j['name'] ?? '',
        desc: j['desc'] ?? '',
        tag: j['tag'] ?? '',
      );
}

// ───────────────────────────── Gemini Service ─────────────────────────────

class GeminiTalk {

// 定义一个方法来获取系统提示词
  String _getSystemPrompt(String language) {
    return '''
你是一个专业的美食推荐助手。
请全程使用 $language 进行回复。

任务：
1. 通过对话了解用户的：口味偏好、饮食限制、场景、预算。
2. 当信息足够时，在回复末尾附带 JSON 推荐：
FOOD_CARDS:[{"emoji":"🍜","name":"菜名","desc":"描述","tag":"标签"}]

限制：
- 每次回复不超过 80 字。
- 必须使用 $language。
- 保持亲切自然的语气。
''';
  }

  final List<Map<String, dynamic>> _history = [];

  Future<ChatMessage> sendMessage(String userText, String systemPrompt) async {
    _history.add({
      'role': 'user',
      'parts': [{'text': userText}]
    });

    final body = jsonEncode({
      'system_instruction': {
        'parts': [
          {'text': systemPrompt} // 这里使用传入的动态提示词
        ]
      },
      'contents': _history,
      'generationConfig': {
        'temperature': 0.8,
        'maxOutputTokens': 512,
      },
    });
    final geminiService = GeminiService();
    final res = await http.post(
      Uri.parse(geminiService.geminiUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (res.statusCode != 200) {
      throw Exception('API Error: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body);
    final rawText =
    data['candidates'][0]['content']['parts'][0]['text'] as String;

    _history.add({
      'role': 'model',
      'parts': [
        {'text': rawText}
      ]
    });

    return _parseResponse(rawText);
  }

  ChatMessage _parseResponse(String raw) {
    final reg = RegExp(r'FOOD_CARDS:(\[.*?\])', dotAll: true);
    final match = reg.firstMatch(raw);

    if (match != null) {
      final jsonStr = match.group(1)!;
      final text = raw.replaceAll(reg, '').trim();
      try {
        final list = jsonDecode(jsonStr) as List;
        final cards = list.map((e) => FoodCard.fromJson(e)).toList();
        return ChatMessage(role: 'assistant', text: text, foodCards: cards);
      } catch (_) {}
    }
    return ChatMessage(role: 'assistant', text: raw.trim());
  }


}

// ───────────────────────────── Screen ─────────────────────────────

class AiFoodChatScreen extends StatefulWidget {
  final void Function(FoodCard food)? onOrder; // 添加这个

  const AiFoodChatScreen({super.key, this.onOrder});

  @override
  State<AiFoodChatScreen> createState() => _AiFoodChatScreenState();
}

class _AiFoodChatScreenState extends State<AiFoodChatScreen> {
  final GeminiTalk _gemini = GeminiTalk();
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  // --- 检查并确保以下变量都在这里 ---
  final List<ChatMessage> _messages = [];
  bool _loading = false; // 修复你现在的报错

  // ------------------------------

  static const Color _purple = Color(0xFFC4A8F0);


  // 添加这一行：初始化一个空的趋势列表
  late List<TrendItem> _trends = [];

  static const Color _purpleDark = Color(0xFF7C5CBF);
  static const Color _yellow = Color(0xFFFFD700);
  static const Color _bg = Color(0xFFF8F5FF);
  bool _isTrendLoading = false;

  @override
  void initState() {
    super.initState();
    // 1. 启动趋势抓取（内部已有延迟处理）
    _fetchDynamicTrends();

    // 2. 延迟显示欢迎语
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addAssistantMessage(ChatMessage(
        role: 'assistant',
        text: StrConfig
            .of(context)
            .aiGreeting,
      ));
    });
  }

// 2. 编写抓取逻辑
  Future<void> _fetchDynamicTrends() async {
    // 关键修复：确保 context 已经挂载到树上
    await Future.delayed(Duration.zero);
    if (!mounted) return;

    setState(() => _isTrendLoading = true);

    // 现在可以安全使用 context 了
    final bool isKorean = Localizations
        .localeOf(context)
        .languageCode == 'ko';
    final String languageName = isKorean ? "韩语(Korean)" : "中文(Chinese)";
    try {
      final geminiService = GeminiService();
      final url = Uri.parse(geminiService.getGeminiUrl());

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{
              // 2. 在提示词中明确要求语言
              "text": "请以精简JSON数组格式返回5个当前韩国最火外卖。请使用 $languageName 回复内容。格式：[{\"rank\":1,\"name\":\"名字\",\"reason\":\"一句话原因\",\"search\":\"关键词\"}]"
            }
            ]
          }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String aiText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        // 去除 Markdown 格式（如果有）
// 这里的替换是为了去掉 Gemini 返回的 Markdown 代码块标签
        aiText = aiText.replaceAll('```json', '').replaceAll('```', '').trim();

        final List<dynamic> data = jsonDecode(aiText);
        setState(() {
          _trends = data.map((item) => TrendItem.fromJson(item)).toList();
          _isTrendLoading = false;
        });
      }
    } catch (e) {
      print("动态榜单加载失败: $e");
      setState(() => _isTrendLoading = false);
    }
  }


  void _addAssistantMessage(ChatMessage msg) {
    setState(() => _messages.add(msg));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    if (text
        .trim()
        .isEmpty || _loading) return;

    // 1. 从 StrConfig 获取当前语言的显示名称 (例如 "中文" 或 "한국어")
    // 确保你的 StrConfig 里有这个字段，或者直接根据逻辑判断
    final String currentLangName = StrConfig
        .of(context)
        .currentLanguageName;

    // 2. 构造动态的 System Prompt
    final String dynamicSystemPrompt = '''
你是一个专业的美食推荐助手，帮助用户找到他们想吃的食物。
请全程使用 $currentLangName 回复用户。

通过对话了解用户的：口味偏好、饮食限制、当前心情、预算范围。
当收集到足够信息时（通常2-3轮后），在回复末尾用以下格式输出推荐：
FOOD_CARDS:[{"emoji":"🍜","name":"菜名","desc":"描述","tag":"标签"}]

注意：
- 每次回复必须使用 $currentLangName。
- 语气要亲切简短，回复不超过80字。
''';

    _ctrl.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', text: text.trim()));
      _loading = true;
    });
    _scrollToBottom();

    try {
      // 3. 将 dynamicSystemPrompt 传给 sendMessage
      // 注意：确保你的 GeminiTalk.sendMessage(text, prompt) 参数对应
      final reply = await _gemini.sendMessage(text.trim(), dynamicSystemPrompt);

      setState(() {
        _messages.add(reply);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        // 错误提示也可以通过 StrConfig 获取，实现完全多语言
        _messages.add(ChatMessage(
            role: 'assistant',
            text: StrConfig
                .of(context)
                .errorMessage // '抱歉，连接出错了'
        ));
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  // ─── Build ───

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildChatArea()),
          _buildInputRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _purple,
      padding: EdgeInsets.only(
        top: MediaQuery
            .of(context)
            .padding
            .top + 8,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                  Icons.chevron_left, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StrConfig
                    .of(context)
                    .aiHelperTitle, // 'AI 食物助手' / 'AI 푸드 헬퍼'
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                StrConfig
                    .of(context)
                    .aiHelperSubtitle, // '告诉我你想吃什么 ✨' / '먹고 싶은 메뉴를 알려주세요 ✨'
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length + (_loading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _messages.length) return _buildTypingIndicator();
        final msg = _messages[i];
        final isUser = msg.role == 'user';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: isUser ? _buildUserBubble(msg) : _buildAiBubble(msg, i),
        );
      },
    );
  }

  Widget _buildUserBubble(ChatMessage msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: _purple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(msg.text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.5)),
          ),
        ),
        const SizedBox(width: 8),
        _avatar(isAi: false),
      ],
    );
  }

  Widget _buildAiBubble(ChatMessage msg, int index) {
    final isFirst = index == 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _avatar(isAi: true),
        const SizedBox(width: 8),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 榜单
              if (isFirst) ...[
                if (_isTrendLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  if (_trends.isNotEmpty)
                    AiTrendListView(
                      trends: _trends,
                      onTrendTap: (name) =>
                          _send("我想了解更多关于 $name 的信息"),
                    ),

                const SizedBox(height: 12),
              ],

              // AI 文本
              if (msg.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),

              // ⭐⭐⭐ FOOD CARDS ⭐⭐⭐
              if (msg.foodCards != null &&
                  msg.foodCards!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildFoodCards(msg.foodCards!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCards(List<FoodCard> cards) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, i) => _buildFoodCardItem(cards[i]),
    );
  }

  Widget _buildFoodCardItem(FoodCard card) {
    return GestureDetector(
      onTap: () {
        //这里 监听用户下单
        // widget.onOrder?.call(card); // 通知外部
        //_send('我想要 ${card.name}');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(productId: card.name,)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0D0F8), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(card.name,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(card.desc,
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(card.tag,
                  style: const TextStyle(fontSize: 10, color: _purpleDark)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips(List<String> chips) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map((c) =>
          GestureDetector(
            onTap: () => _send(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: _purple, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(c,
                  style: const TextStyle(fontSize: 13, color: _purpleDark)),
            ),
          ))
          .toList(),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _avatar(isAi: true),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE0D0F8), width: 0.5),
          ),
          child: const _TypingDots(),
        ),
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery
            .of(context)
            .padding
            .bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEE8FA), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              onSubmitted: _send,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                // 关键修复：将写死的文字换成 StrConfig，并确保外层没有 const
                hintText: StrConfig
                    .of(context)
                    .talkHint,
                hintStyle: const TextStyle(
                    color: Color(0xFFBBBBBB), fontSize: 14),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                // 注意：下方的 OutlineInputBorder 也要确保没有 const，
                // 但由于 BorderSide 的颜色是常量，通常保留 const 没问题。
                // 关键是装饰器本身不能是 const。
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: _purple, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: _purple, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: _purpleDark, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _loading ? null : () => _send(_ctrl.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _loading ? const Color(0xFFDDDDDD) : _yellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                  Icons.send_rounded, size: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar({required bool isAi}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isAi ? _purple : _yellow,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          isAi ? '🤖' : '我',
          style: TextStyle(
            fontSize: isAi ? 14 : 11,
            color: isAi ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── Typing Dots ─────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final offset = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
            final dy = offset < 0.5
                ? -6.0 * (offset / 0.5)
                : -6.0 * (1 - (offset - 0.5) / 0.5);
            return Transform.translate(
              offset: Offset(0, dy),
              child: Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFC4A8F0),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}


class AiTrendListView extends StatelessWidget {
  final List<TrendItem> trends;
  final Function(String) onTrendTap;

  const AiTrendListView(
      {super.key, required this.trends, required this.onTrendTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部：小老虎 + 标题
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                // 这里放入你那个可爱的小老虎图标
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EBFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // 使用 ClipRRect 确保图片超出圆角的部分被裁掉
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/tiger.png",
                      fit: BoxFit.cover, // 确保图片填满 35x35 的区域
                      // 如果图片加载失败（路径错或文件丢了），显示一个回退图标
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(
                        child: Text("🐯", style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StrConfig
                          .of(context)
                          .trendingTitle, // '今日美食趋势' / '오늘의 맛집 트렌드'
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF7C5CBF)),
                    ),
                    Text(
                      StrConfig
                          .of(context)
                          .trendingUpdate,
                      // '实时更新 · 韩国最火外卖' / '실시간 업데이트 · 한국 인기 배달 메뉴'
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 榜单列表
          ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trends.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (ctx, index) {
              final item = trends[index];
              bool isTop3 = index < 3;

              return InkWell(
                onTap: () => onTrendTap(item.name),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // 名次
                      Container(
                        width: 24,
                        alignment: Alignment.center,
                        child: Text("${index + 1}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isTop3 ? Colors.orange : Colors.grey[400],
                              fontStyle: FontStyle.italic, // 正确写法
                            )),
                      ),
                      const SizedBox(width: 12),
                      // 内容
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            Text(item.reason,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      const Icon(
                          Icons.chevron_right, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),

          // 底部提示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F5FF),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                StrConfig
                    .of(context)
                    .clickToAsk,
                // '点击条目直接咨询 AI 推荐 👇' / '항목을 클릭하여 AI 추천을 받아보세요 👇'
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7C5CBF),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
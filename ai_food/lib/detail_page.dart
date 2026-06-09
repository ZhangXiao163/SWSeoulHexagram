// ── 详情页 ─────────────────────────────────────────────────
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'AiCartPage.dart';
import 'ai/gemini_service.dart';
import 'service/api_service.dart';
import 'bean/DishDetailModel.dart';
import 'config/StrConfig.dart';

class DetailPage extends StatefulWidget {
  final DishDetailModel? dish;
  final String productId;

  const DetailPage({
    super.key,
    this.dish,
    required this.productId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DishDetailModel _dish;
  int _qty = 1;
  bool _loading = true;
  List<ReviewModel> _reviews = [];
  bool _reviewLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  static const _fallbackDish = DishDetailModel(
    id: '1', name: '불고기 덮밥', nameZh: '牛肉盖饭',
    imageUrl: 'assets/images/banner1.jpg', price: 8000, currency: '₩',
    description: '精选牛肉以传统酱汁腌制，搭配米饭，层次丰富，口感细腻。',
    tags: ['月售 1000+', '招牌', '不辣'], reviews: [],
  );

  Future<void> _loadDetail() async {
    _dish = widget.dish ?? _fallbackDish;
    try {
      final foodData = await ApiService().getFoodById(int.tryParse(widget.productId) ?? 1);
      if (foodData.isNotEmpty && mounted) {
        setState(() {
          _dish = DishDetailModel(
            id: (foodData['foodId'] ?? '1').toString(),
            name: foodData['foodName'] as String? ?? _fallbackDish.name,
            nameZh: '',
            imageUrl: 'assets/images/banner1.jpg',
            price: (foodData['price'] as num?)?.toDouble() ?? _fallbackDish.price,
            currency: '₩',
            description: foodData['foodDesc'] as String? ?? _fallbackDish.description,
            tags: ['月售500+', '招牌'],
            reviews: [],
          );
        });
      }
    } catch (_) {}
    setState(() => _loading = false);

    _generateReviews(_dish).then((reviews) {
      if (mounted) setState(() {_reviews = reviews; _reviewLoading = false;});
    });
  }

  double get _totalPrice => _dish.price * _qty;

  Future<List<ReviewModel>> _generateReviews(DishDetailModel dish) async {
    // 关键修复：确保 context 已经挂载到树上
    await Future.delayed(Duration.zero);
    if (!mounted) return[];
    // 现在可以安全使用 context 了
    final bool isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final String languageName = isKorean ? "韩语(Korean)" : "中文(Chinese)";
    final prompt = '''
根据以下菜品信息，生成5条真实感强的用户评价。

菜品名称：${dish.name}（${dish.nameZh}）
菜品描述：${dish.description}
标签：${dish.tags.join('、')}

要求：
- 每条评价包含：用户名、评分（4或5）、评价内容
- 评价内容20字以内，口语化，真实自然
- 请使用 $languageName 回复内容。
- 严格按以下 JSON 格式返回，不要有任何其他文字：
[ 
  {"name": "小王", "rating": 5, "content": "评价内容"},
  {"name": "小张", "rating": 4, "content": "评价内容"},
  {"name": "小李", "rating": 5, "content": "评价内容"}
]
''';

    try {
      final geminiService = GeminiService();
      final res = await http.post(
        Uri.parse(geminiService.geminiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'system_instruction': {
            'parts': [
              {'text': '你是一个外卖平台的用户评价生成器，只返回 JSON，不要有任何其他文字。'}
            ]
          },
          'contents': [
            {
              'role': 'user',
              'parts': [{'text': prompt}]
            }
          ],
          'generationConfig': {
            'temperature': 0.9,
            'maxOutputTokens': 512,
          },
        }),
      );

      if (res.statusCode != 200) throw Exception('API Error: ${res.statusCode}');

      final data = jsonDecode(res.body);
      final rawText =
      data['candidates'][0]['content']['parts'][0]['text'] as String;

      // 提取 JSON 部分，防止模型多返回了文字
      final jsonStr = rawText.substring(
        rawText.indexOf('['),
        rawText.lastIndexOf(']') + 1,
      );

      final List list = jsonDecode(jsonStr);
      return list
          .map((e) => ReviewModel(
        name: e['name'] as String,
        content: e['content'] as String,
        rating: (e['rating'] as num).toDouble(),
      ))
          .toList();
    } catch (e) {
      debugPrint('评价生成失败: $e');
      return [
        ReviewModel(name: '用户', content: '很好吃，推荐！', rating: 5),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 0,
              bottom: 70 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── 图片全宽 + 返回按钮 ──────────────────
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                      child: SizedBox(
                        height: 280,
                        width: double.infinity,
                        child: Image.network(
                          'https://ai-food-images-seoul.s3.ap-northeast-2.amazonaws.com/food/${_dish.id}.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFFAC775),
                            child: const Center(
                              child: Text('🍲',
                                  style: TextStyle(fontSize: 72)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 返回按钮
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 14,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── 菜品信息卡片 ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _dish.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _dish.nameZh,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${_dish.currency} ${_dish.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD85A30),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _dish.tags
                              .map((tag) => _TagChip(label: tag))
                              .toList(),
                        ),

                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 14),

                        Text(
                          _dish.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF9F27),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        StrConfig.of(context).userReview,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${_reviews.length})',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 评价卡片 ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        if (_reviewLoading)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Column(
                                children: [
                                  const CircularProgressIndicator(
                                    color: Color(0xFFEF9F27),
                                    strokeWidth: 2,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    StrConfig.of(context).aiWorking,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ..._reviews.asMap().entries.map(
                                (e) => _ReviewItem(review: e.value, avatarIndex: e.key),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── 底部操作栏 ────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(
              qty: _qty,
              totalPrice: _totalPrice,
              currency: _dish.currency,
              onMinus: () {
                if (_qty > 1) setState(() => _qty--);
              },
              onPlus: () => setState(() => _qty++),
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${StrConfig.of(context).addCart}, x$_qty，${StrConfig.of(context).count} ${_dish.currency}${_totalPrice.toStringAsFixed(0)}'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: const Color(0xFFEF9F27),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
                //  跳转购物车
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── 标签组件 ───────────────────────────────────────────────
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAEEDA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF854F0B),
        ),
      ),
    );
  }
}

// ── 评价条目组件 ───────────────────────────────────────────
class _ReviewItem extends StatelessWidget {
  final ReviewModel review;
  final int avatarIndex;

  const _ReviewItem({required this.review, required this.avatarIndex});

  static const _avatarColors = [
    [Color(0xFFFAEEDA), Color(0xFF854F0B)],
    [Color(0xFFE1F5EE), Color(0xFF0F6E56)],
    [Color(0xFFEEEDFE), Color(0xFF534AB7)],
    [Color(0xFFE6F1FB), Color(0xFF185FA5)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _avatarColors[avatarIndex % _avatarColors.length];
    final stars = List.generate(
      5,
          (i) => Icon(
        i < review.rating ? Icons.star : Icons.star_border,
        size: 12,
        color: const Color(0xFFEF9F27),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors[0],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              review.name[0],
              style: TextStyle(
                color: colors[1],
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 名字 + 星级
                Row(
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(children: stars),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  review.content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ── 底部操作栏 ─────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final int qty;
  final double totalPrice;
  final String currency;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.qty,
    required this.totalPrice,
    required this.currency,
    required this.onMinus,
    required this.onPlus,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          // 加入购物车按钮在左
          Expanded(
            child: GestureDetector(
              onTap: onAddToCart,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF9F27),
                  borderRadius: BorderRadius.circular(23),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${StrConfig.of(context).addCart}  · $currency${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),
          // 数量控制器
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                _QtyButton(icon: Icons.remove, onTap: onMinus),
                const SizedBox(width: 10),
                SizedBox(
                  width: 20,
                  child: Text(
                    '$qty',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _QtyButton(icon: Icons.add, onTap: onPlus),
              ],
            ),
          ),

          const SizedBox(width: 12),

        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFEF9F27),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}
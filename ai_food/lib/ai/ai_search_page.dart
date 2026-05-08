import 'dart:convert'; // 用于解析 JSON
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'TrendItem.dart';
import 'secrets.dart'; // 导入你之前创建的 secrets.dart
import 'package:http/http.dart' as http;

class AiTrendPage extends StatefulWidget {
  const AiTrendPage({super.key});

  @override
  State<AiTrendPage> createState() => _AiTrendPageState();
}

class _AiTrendPageState extends State<AiTrendPage> {
  List<TrendItem> _trends = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //_fetchAiTrends(); // 页面打开时自动请求 AI
  }

  Future<void> _fetchAiTrends() async {
    setState(() => _isLoading = true);

    // 1. 写死 URL，保证路径 100% 正确
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${Secrets.geminiApiKey}'
    );

    try {
      // 2. 发起请求，不使用插件类
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": "请以 JSON 数组格式返回 5 个当前韩国最火的外卖美食趋势。格式：[{\"rank\":1,\"name\":\"名字\",\"trend\":\"趋势\",\"reason\":\"原因\" \"search\":\"Korean fried chicken\",}]"}]}]
        }),
      );
      print("1. 发起请求: ${response.body}");
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String aiText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        aiText = aiText.replaceAll('```json', '').replaceAll('```', '').trim();
        print("2. 提取出的文字: $aiText");
        final List<dynamic> data = jsonDecode(aiText);
        setState(() {
          // 这一步请确保变量名和你原来定义的一致
          _trends = data.map((item) => TrendItem.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        print("2. else:setState ");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("2. :catch ");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TrendHeaderDelegate(onSearch: _fetchAiTrends), // 搜索时也可以刷新
          ),
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
              child: Text("趋势播报", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),

          // 如果正在加载，显示进度条
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Colors.amber)),
            )
          else
          // 渲染 AI 返回的列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildAiTrendItem(_trends[index], index),
                childCount: _trends.length,
              ),
            ),

          // ... 底部装饰保持不变
        ],
      ),
    );
  }

  // 修改后的 Item 构建函数，接收 TrendItem 对象
  Widget _buildAiTrendItem(TrendItem item, int index) {
    bool isTop3 = index < 3;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              child: Text("${index + 1}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isTop3 ? Colors.red : Colors.grey[400],
                ),
              ),
            ),
            // 图片占位（AI 暂时无法直接返回图片 URL，可以用默认图或 Placeholder）
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: Image.network(
            //     'https://source.unsplash.com/featured/?${Uri.encodeComponent(item.name)}',
            //     width: 75,
            //     height: 75,
            //     fit: BoxFit.cover,
            //     errorBuilder: (_, __, ___) {
            //       return Container(
            //         width: 75,
            //         height: 75,
            //         color: Colors.grey[100],
            //         child: const Icon(Icons.fastfood),
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(item.reason, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("趋势值 ${item.rank}", style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
// 吸顶头部 Delegate
class _TrendHeaderDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback? onSearch; // 增加搜索回调
  _TrendHeaderDelegate({this.onSearch});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(padding: const EdgeInsets.all(8.0), child: const Icon(Icons.arrow_back_ios, size: 20)),
              ),
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.only(left: 15, right: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(color: const Color(0xFFFFD000), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Expanded(child: Text("问问GeminiAi?", style: TextStyle(color: Colors.black87, fontSize: 14))),
                      GestureDetector(
                        onTap: onSearch, // 点击搜索触发 AI 请求
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xFFFFD000), borderRadius: BorderRadius.circular(18)),
                          child: const Text("搜索", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ... 问问 Gemini 气泡部分保持不变
        ],
      ),
    );
  }

  // 2. 关键修复：定义吸顶区域的最大高度
  @override
  double get maxExtent => 115.0;

  // 3. 关键修复：定义吸顶区域的最小高度
  @override
  double get minExtent => 115.0;

  // 4. 关键修复：决定是否需要重新构建
  @override
  bool shouldRebuild(covariant _TrendHeaderDelegate oldDelegate) {
    // 如果你的 onSearch 或其他参数会发生变化，可以返回 true
    // 通常在简单场景下返回 false 即可
    return oldDelegate.onSearch != onSearch;
  }
// ... 其余高度定义保持不变
}


// [
// {
// "rank": 1,
// "name": "韩式炸鸡 (Korean Fried Chicken)",
// "trend": "持续火爆，口味多样化",
// "reason": "韩式炸鸡的酥脆口感、多种酱料选择（如酱油蒜香、甜辣、蜂蜜黄油等）以及与啤酒的绝佳搭配（炸鸡配啤酒，치맥）使其成为韩国人永恒的挚爱。近年来，炸鸡店在口味上不断推陈出新，以满足消费者日益挑剔的味蕾。",
// "search": "Korean fried chicken"
// },
// {
// "rank": 2,
// "name": "辣炒年糕 (Tteokbokki)",
// "trend": "健康化与创意化并存",
// "reason": "辣炒年糕是韩国国民小吃，其甜辣的口感深入人心。近年来，为了迎合健康饮食的趋势，市场上出现了使用更少油、更少糖的健康版辣炒年糕。同时，各种创意口味（如奶油、芝士、海鲜等）的辣炒年糕也层出不穷，吸引了年轻消费者。",
// "search": "Tteokbokki"
// },
// {
// "rank": 3,
// "name": "部队锅 (Budae Jjigae)",
// "trend": "家庭分享与便利性",
// "reason": "部队锅因其丰富的食材（香肠、午餐肉、泡菜、年糕、方便面等）和浓郁的味道，非常适合多人分享。外卖趋势使得家庭或朋友聚会时，可以直接订购方便快捷。市面上也出现了各种预制包装，方便在家简单烹饪。",
// "search": "Budae Jjigae"
// },
// {
// "rank": 4,
// "name": "烤肉 (Korean BBQ)",
// "trend": "一人食与高品质肉类",
// "reason": "虽然烤肉传统上是多人聚餐的选择，但为了适应单身经济和便利性，一人份的烤肉外卖套餐越来越受欢迎。同时，消费者对外卖烤肉的肉质要求也越来越高，追求优质牛肉和猪肉。",
// "search": "Korean BBQ"
// },
// {
// "rank": 5,
// "name": "便当/套餐 (Dosirak/Meal Kits)",
// "trend": "健康、营养均衡与定制化",
// "reason": "随着人们对健康饮食的重视，营养均衡、搭配合理的便当和套餐外卖受到追捧。许多商家提供定制化选项，让消费者可以根据自己的喜好和营养需求来选择食材和配菜。这满足了忙碌的上班族和学生对健康午餐的需求。",
// "search": "Korean meal kit"
// }
// ]

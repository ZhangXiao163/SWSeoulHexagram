import 'package:flutter/material.dart';

// 移除之前重复定义的 StatefulWidget 部分，直接使用 StatelessWidget
class AiTrendPage extends StatelessWidget {
  const AiTrendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. 顶部状态栏占位
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.top),
          ),

          // 2. 吸顶区域：包含搜索框和 AI 问小团入口
          SliverPersistentHeader(

            pinned: true,
            delegate: _TrendHeaderDelegate(),
          ),

          // 3. 趋势播报标题
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
              child: Text(
                "趋势播报",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // 4. 趋势列表
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildTrendItem(index),
              childCount: 10,
            ),
          ),

          // 5. 底部装饰
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("查看全部趋势热搜", style: TextStyle(color: Colors.grey[600])),
                    Icon(Icons.chevron_right, color: Colors.grey[600], size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建单条趋势数据
  Widget _buildTrendItem(int index) {
    final titles = ["全网爆火牛胸口拌薯片🔥", "瓦尔登蓝芒果酸奶昔", "韩式炒年糕", "霸王茶姬「夏梦玫瑰」", "外卖冤种人格测试", "喜羊羊与灰太狼联名款", "网红战斗机拌面", "贵州蘸水", "水果我只吃不出轨的", "肯德基原味鸡汉堡"];
    final subs = ["谁说零食不能当菜？这盘我连渣都不剩！", "蓝色魔法师碰撞明黄色太阳", "糯叭叭！韩剧同款甜辣芝士炒年糕", "蜜瓜乌龙，这四字就是夏天！", "来测测干饭人的WMTI人格", "青苹果+青提清爽加倍", "挑战辣度极限，等你来战！", "酸辣咸香，掌管水煮菜的神", "爆火AI短剧，狗血反转太上头", "超绝搭配，夯爆了！"];
    final values = ["99.0万", "98.2万", "87.1万", "69.7万", "66.5万", "66.5万", "53.8万", "48.2万", "36.3万", "30.0万"];

    bool isTop3 = index < 3;

    return InkWell(
      onTap: () {}, // 点击热搜项的交互
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 排名
            SizedBox(
              width: 30,
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isTop3 ? Colors.red : Colors.grey[400],
                  fontStyle: isTop3 ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            // 2. 图片
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://via.placeholder.com/150",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood, color: Colors.grey[300]),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 3. 文本内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index < titles.length ? titles[index] : "美食热搜条目",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    index < subs.length ? subs[index] : "描述内容...",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 4. 指数值
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "趋势值${index < values.length ? values[index] : "10万"}",
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 吸顶头部 Delegate
class _TrendHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Column(
        children: [
          Row(
            children: [
              // ==============================
              // 关键修改：为返回图标添加点击事件
              // ==============================
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 关闭当前页面，返回首页
                },
                child: Container(
                  // 增加 padding 可以让手指更容易点中这个区域
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.transparent, // 设置透明背景确保点击感应
                  child: const Icon(Icons.arrow_back_ios, size: 20),
                ),
              ),
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(right: 10), // 因为左侧有了 padding，这里微调间距
                  padding: const EdgeInsets.only(left: 15, right: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(color: const Color(0xFFFFD000), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text("必胜六一全城追踪", style: TextStyle(color: Colors.black87, fontSize: 14)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD000),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text("搜索", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // AI 问小团气泡
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 30),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, spreadRadius: 1)
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 模拟渐变 AI 图标
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ).createShader(bounds),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 6),
                  const Text("问小团", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 115.0; // 稍微增加一点高度以防文字拥挤
  @override
  double get minExtent => 115.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
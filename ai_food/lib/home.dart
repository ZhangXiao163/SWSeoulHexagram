import 'dart:async';
import 'package:flutter/material.dart';

import 'AiInputPage.dart';
import 'ai/ai_search_page.dart';

void main() => runApp(MaterialApp(home: TakeoutHomePage(), debugShowCheckedModeBanner: false));
//Google Gemini API
class TakeoutHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          // 1. 顶部占位
          SliverToBoxAdapter(
            child: Container(
              height: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          // 2. 吸顶搜索框
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchBarDelegate(),
          ),

          // ==============================
          // 关键修改：插入轮播图控件
          // ==============================
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ImageBannerCarousel(),
            ),
          ),

          // 3. 金刚区内容
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildCategoryGrid(),
            ),
          ),

          // 5. 附近商家标题栏
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  const Text("附近商家", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),

          // 6. 商家列表
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildMerchantCard(),
              childCount: 10,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- 原有组件封装 ---

  Widget _buildCategoryGrid() {
    final items = ["中餐", "西餐", "韩餐", "泰国菜", "越南菜"];
    final icons = [
      "assets/images/chinese_food.png",
      "assets/images/western_food.png",
      "assets/images/korean_food.png",
      "assets/images/thai_food.png",
      "assets/images/pho_food.png"
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 0,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                icons[i],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.fastfood, size: 20, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(items[i], style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMerchantCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("奈雪的茶 (北京新地佰...)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                const Text("月售1000+  起送￥20  免配送费", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: '外卖'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: '订单'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
      ],
    );
  }
}

// ==============================
// 新增：自动轮播图组件
// ==============================
class ImageBannerCarousel extends StatefulWidget {
  @override
  _ImageBannerCarouselState createState() => _ImageBannerCarouselState();
}

class _ImageBannerCarouselState extends State<ImageBannerCarousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  final List<String> _bannerImages = [
    "assets/images/banner1.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner4.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200, // 轮播图高度
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // 建议稍微加大圆角，视觉效果更好
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    // 关键修改：由 NetworkImage 改为 AssetImage
                    image: AssetImage(_bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // 指示器
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerImages.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentPage == index ? Colors.orange : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}

// --- 搜索框 Delegate 保持不变 ---
class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              // ==============================
              // 搜索框点击事件
              // ==============================
              onTap: () {
                onTouchSearch(context);
                // 这里通常跳转到搜索详情页，或者展示 AI 联想词
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    const Text("想吃点什么？问问GeminiAi?", style: TextStyle(color: Colors.grey)),
                    const Spacer(),
                    // 清除图标点击事件
                    GestureDetector(
                      onTap: () {
                        onTouchSearch(context);
                        // 这里通常跳转到搜索详情页，或者展示 AI 联想词
                      },
                      child: const Icon(Icons.close, color: Colors.grey, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // ==============================
          // 搜索按钮点击事件 (使用 InkWell 增加水波纹效果)
          // ==============================
          InkWell(
            onTap: () {
              onTouchSearch(context);
              // 这里通常跳转到搜索详情页，或者展示 AI 联想词
            },
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "搜索",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
   void onTouchSearch(BuildContext context){
     Navigator.push(
       context,
       PageRouteBuilder(
         pageBuilder: (context, animation, secondaryAnimation) => const AiTrendPage(),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: ScaleTransition(
               scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
               child: child,
             ),
           );
         },
       ),
     );
   }

  @override
  double get maxExtent => 60.0;
  @override
  double get minExtent => 60.0;
  @override
  bool shouldRebuild(_StickySearchBarDelegate oldDelegate) => false;
}
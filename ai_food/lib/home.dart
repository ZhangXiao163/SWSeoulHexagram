import 'dart:async';
import 'package:flutter/material.dart';

import 'AiInputPage.dart';
import 'ai/ai_search_page.dart';
import 'ai/ai_talk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/StrConfig.dart';

// 1. 定义全局变量
ValueNotifier<Locale> appLocale = ValueNotifier(const Locale('zh'));

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. 监听语言变化
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          locale: locale,
          debugShowCheckedModeBanner: false,
          // supportedLocales 可以保留 const，因为 Locale 构造函数是 const 的
          supportedLocales: const [Locale('zh'), Locale('ko')],

          // 删掉这里的 const
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: TakeoutHomePage(),
        );
      },
    );
  }
}


class TakeoutHomePage extends StatelessWidget {
  const TakeoutHomePage({super.key});

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

          // 3. 轮播图
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ImageBannerCarousel(),
            ),
          ),

          // 4. 分类动画区
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const CategorySection(),
            ),
          ),

          // 5. 附近商家标题
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children:  [
                  Text(StrConfig.of(context).nearby,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 15),
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
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildMerchantCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("奈雪的茶 (北京新地佰...)",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 5),
                Text("月售1000+  起送￥20  免配送费",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) { // 加上 context 参数
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      // 移除这里的 const，因为翻译是动态获取的
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.fastfood),
          label: StrConfig.of(context).takeout, // 使用动态翻译
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.receipt_long),
          label: StrConfig.of(context).order,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: StrConfig.of(context).mine,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// 分类动画组件
// ─────────────────────────────────────────
class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

// class CategorySection extends StatefulWidget {
//   const CategorySection({super.key});
//
//   @override
//   State<CategorySection> createState() => _CategorySectionState();
// }

class _CategorySectionState extends State<CategorySection>
    with TickerProviderStateMixin {

  // 图片路径是固定的，可以放在这里
  final List<String> _icons = [
    "assets/images/chinese_food.png",
    "assets/images/western_food.png",
    "assets/images/korean_food.png",
    "assets/images/thai_food.png",
    "assets/images/pho_food.png",
  ];

  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _slideAnims;
  late List<Animation<double>> _fadeAnims;

  @override
  void initState() {
    super.initState();

    // 初始化 5 个动画控制器（对应 5 个分类）
    _controllers = List.generate(
      5,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
      ),
    );

    _slideAnims = _controllers
        .map((c) => Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    _fadeAnims = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    // 逐个延迟启动动画
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 80 * i), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 【关键修改】：在 build 内部获取多语言文字
    // 这样每次语言切换触发 build 时，文字都会更新，且不会报 context 错误
    final List<String> items = [
      StrConfig.of(context).chineseFood,
      StrConfig.of(context).westernFood,
      StrConfig.of(context).krFood,
      StrConfig.of(context).thaiFood,
      StrConfig.of(context).vitFood,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (i) {
        return SlideTransition(
          position: _slideAnims[i],
          child: FadeTransition(
            opacity: _fadeAnims[i],
            child: Column(
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
                      _icons[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.fastfood,
                          size: 20,
                          color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // 使用局部变量 items
                Text(items[i], style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
// 轮播图组件
// ─────────────────────────────────────────
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
      _currentPage = (_currentPage + 1) % _bannerImages.length;
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
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() => _currentPage = page);
            },
            itemCount: _bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(_bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerImages.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color:
                _currentPage == index ? Colors.orange : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// 吸顶搜索框
// ─────────────────────────────────────────
class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {

  // // 搜索点击处理
  // void _onTouchSearch(BuildContext context) {
  //   // 你的跳转逻辑
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("正在打开搜索..."))
  //   );
  // }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFCDB7F6),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          const SizedBox(width: 5),

          // 1. 搜索框
          Expanded(
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFFFD233),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  const Icon(Icons.search, color: Colors.grey, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      StrConfig.of(context).searchHint, // 使用之前在 S 类中定义的 getter
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onTouchSearch(context),
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD400),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child:  Text(
                        StrConfig.of(context).searchBtn,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 2. Gemini AI按钮
          GestureDetector(
            // 关键 1: 确保点击区域覆盖整个 Container，即使是空白处
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print("点击了 AI 按钮"); // 调试用
              _onTouchSearch(context);
            },
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // 确保 Row 只占用必要的宽度
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/tiger.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.face, size: 18, color: Colors.purple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // 关键 2: 移除 RichText 外层可能的 const，确保 StrConfig 动态生效
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StrConfig.of(context).askGemini,
                          style: const TextStyle(
                            color: Color(0xFF6D5AE6),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumGothic', // 如果你配置了韩文字体，可以在这里指定
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 3. 新增：语言切换按钮
          // 在 Row 的最后添加这个按钮
          GestureDetector(
            onTap: () {
              // 切换语言逻辑
              // 切换逻辑：如果是 zh 就切到 ko，反之切回 zh
              appLocale.value = appLocale.value.languageCode == 'zh'
                  ? const Locale('ko')
                  : const Locale('zh');
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                appLocale.value.languageCode == 'zh' ? "中" : "한",
                style: const TextStyle(
                  color: Color(0xFF6D5AE6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
    );
  }

  // ... 保持原有的 _onTouchSearch, maxExtent, minExtent, shouldRebuild 不变
  void _onTouchSearch(BuildContext context) {
    // 原有逻辑
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AiFoodChatScreen(),
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
  double get maxExtent => 58;
  @override
  double get minExtent => 58;
  @override
  bool shouldRebuild(_StickySearchBarDelegate oldDelegate) => false;
}
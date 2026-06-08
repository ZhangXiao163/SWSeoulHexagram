import 'dart:async';
import 'package:ai_food/AiCartPage.dart';
import 'package:ai_food/config/login_manager.dart';
import 'package:ai_food/login.dart';
import 'package:ai_food/service/merchant_repository.dart';
import 'package:flutter/material.dart';

import 'FoodOrderListScreen.dart';
import 'MerchantSearchDelegate.dart';
import 'ai/ai_talk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bean/MerchantModel.dart';
import 'config/StrConfig.dart';
import 'menu_page.dart';


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

class TakeoutHomePage extends StatefulWidget {
  const TakeoutHomePage({super.key});

  @override
  State<TakeoutHomePage> createState() => _TakeoutHomePageState();
}

class _TakeoutHomePageState extends State<TakeoutHomePage> {
  final MerchantRepository _repository = MerchantRepository();

  // 新增三个状态变量
  List<MerchantModel> _merchants = [];
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadMerchants();
    appLocale.addListener(_onLocaleChanged); // 监听语言切换
  }

  void _onLocaleChanged() => _loadMerchants(); // 切语言 → 重新拉取

  @override
  void dispose() {
    appLocale.removeListener(_onLocaleChanged); // 记得移除
    super.dispose();
  }

  Future<void> _loadMerchants() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      // 把当前语言传入
      final list = await _repository.fetchNearbyMerchants(appLocale.value);
      setState(() => _merchants = list);
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeBody(),   // ← 原来 body 的内容
          const FoodOrderListScreen(),
          const CartPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }


  // 把原来 body 里的内容提取成一个方法
  Widget _buildHomeBody() {
    return CustomScrollView(
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
          delegate: _StickySearchBarDelegate(
            onRefresh: () => setState(() {}),
          ),
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
            child: Text(
              StrConfig.of(context).nearby,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // 6. 商家列表（条件判断内联进来）
        if (_isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorMsg != null)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(_errorMsg!, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMerchants,
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          )
        else if (_merchants.isEmpty)
            const SliverFillRemaining(child: Center(child: Text('附近暂无商家')))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMerchantCard(_merchants[index]),
                childCount: _merchants.length,
              ),
            ),
      ],
    );
  }


  Widget _buildMerchantCard(MerchantModel merchant) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        //  跳转商家详情页
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const DetailPage(productId:'牛肉饭',)),
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                merchant.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.store, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        merchant.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        merchant.deliveryTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // tags 直接遍历，接口返回什么渲染什么
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: merchant.tags
                        .map((tag) => _buildTag(tag))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        tag,
        style: TextStyle(color: Colors.orange.shade700, fontSize: 10),
      ),
    );
  }

// ③ _buildBottomNav 里的 onTap 补上
  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,       // 选中色改成橙色更明显
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,            // ← 关键：绑定当前 index
      onTap: (index) {
        setState(() => _currentIndex = index); // ← 关键：切换
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.fastfood),
          label: StrConfig.of(context).takeout,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.receipt_long),
          label: StrConfig.of(context).order,
        ),
        BottomNavigationBarItem( // ← 新增
          icon: const Icon(Icons.shopping_cart),
          label: StrConfig.of(context).buyCar,
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
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.8),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList();

    _fadeAnims = _controllers
        .map(
          (c) => Tween<double>(
            begin: 0,
            end: 1,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
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
      // StrConfig.of(context).vitFood,
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
                        color: Colors.grey,
                      ),
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
                color: _currentPage == index ? Colors.orange : Colors.grey[300],
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
  final VoidCallback onRefresh; // 新增

  _StickySearchBarDelegate({required this.onRefresh}); // 新增构造

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFFCDB7F6),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          const SizedBox(width: 2),

          // 登录按钮
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (LoginManager.instance.isLogin) {
                return;
              }
              _onTouchLogin(context);
              print("点击了登录按钮");
            },
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/tiger.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.face,
                              size: 18,
                              color: Color(0xFF6D5AE6),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 48),
                    child: Text(
                      LoginManager.instance.isLogin
                          ? LoginManager.instance.getLoginName()
                          : StrConfig.of(context).login,
                      style: const TextStyle(
                        color: Color(0xFF6D5AE6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // 超出显示...
                      // 或者用 TextOverflow.fade
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 5),

          // 搜索框
          Expanded(
            child: GestureDetector(
              onTap: () => _onTouchSearch(context),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFFFD233), width: 2),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 6),
                    const Icon(Icons.search, color: Colors.grey, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        StrConfig.of(context).searchHint,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD400),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        StrConfig.of(context).searchBtn,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Gemini AI按钮
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print("点击了 AI 按钮");
              _onTouchAi(context);
            },
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                            const Icon(
                              Icons.face,
                              size: 18,
                              color: Colors.purple,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StrConfig.of(context).askGemini,
                          style: const TextStyle(
                            color: Color(0xFF6D5AE6),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NanumGothic',
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

          // 语言切换按钮
          GestureDetector(
            onTap: () {
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
                appLocale.value.languageCode == 'zh' ? "한" : "中",
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

  void _onTouchSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: MerchantSearchDelegate(locale: appLocale.value),
    );
  }

  void _onTouchAi(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AiFoodChatScreen(),
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

  void _onTouchLogin(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
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
    ).then((_) => onRefresh()); // 登录页返回后刷新
  }

  @override
  double get maxExtent => 58;

  @override
  double get minExtent => 58;

  @override
  bool shouldRebuild(_StickySearchBarDelegate oldDelegate) => true; // 改为true
}

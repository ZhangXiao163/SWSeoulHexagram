import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MeituanApp());
}

class MeituanApp extends StatelessWidget {
  const MeituanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '美团',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PingFang SC',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD100),
          primary: const Color(0xFFFFD100),
        ),
      ),
      home: const MeituanHomePage(),
    );
  }
}

class MeituanHomePage extends StatefulWidget {
  const MeituanHomePage({super.key});

  @override
  State<MeituanHomePage> createState() => _MeituanHomePageState();
}

class _MeituanHomePageState extends State<MeituanHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _bannerIndex = 0;
  final PageController _bannerController = PageController();

  final List<Map<String, dynamic>> _categories = [
    {'icon': '🛵', 'label': '外卖', 'color': Color(0xFFFF6B35)},
    {'icon': '🍜', 'label': '美食', 'color': Color(0xFFFF4757)},
    {'icon': '🏨', 'label': '酒店', 'color': Color(0xFF2ED573)},
    {'icon': '🎬', 'label': '电影', 'color': Color(0xFF1E90FF)},
    {'icon': '💊', 'label': '医疗', 'color': Color(0xFF5352ED)},
    {'icon': '✈️', 'label': '旅游', 'color': Color(0xFF00CEC9)},
    {'icon': '🎮', 'label': '娱乐', 'color': Color(0xFFFF6348)},
    {'icon': '🛒', 'label': '购物', 'color': Color(0xFFFFA502)},
    {'icon': '🏋️', 'label': '运动', 'color': Color(0xFF26de81)},
    {'icon': '📦', 'label': '快递', 'color': Color(0xFF4b7bec)},
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      'gradient': [Color(0xFFFF6B35), Color(0xFFFF4757)],
      'title': '午餐特惠',
      'sub': '满30减8元',
      'emoji': '🍱',
    },
    {
      'gradient': [Color(0xFF1E90FF), Color(0xFF5352ED)],
      'title': '酒店低价',
      'sub': '今晚特价房',
      'emoji': '🏨',
    },
    {
      'gradient': [Color(0xFFFFD100), Color(0xFFFFA502)],
      'title': '电影大片',
      'sub': '在线选座享折扣',
      'emoji': '🎬',
    },
  ];

  final List<Map<String, dynamic>> _nearbyShops = [
    {
      'name': '麦当劳(中关村店)',
      'tag': '汉堡',
      'rating': 4.8,
      'time': '28',
      'price': '¥35',
      'discount': '满30减5',
      'emoji': '🍔',
      'color': Color(0xFFFFD100),
    },
    {
      'name': '海底捞火锅',
      'tag': '火锅',
      'rating': 4.9,
      'time': '45',
      'price': '¥120',
      'discount': '新客立减20',
      'emoji': '🍲',
      'color': Color(0xFFFF4757),
    },
    {
      'name': '喜茶(望京店)',
      'tag': '茶饮',
      'rating': 4.7,
      'time': '22',
      'price': '¥28',
      'discount': '买2送1',
      'emoji': '🧋',
      'color': Color(0xFF2ED573),
    },
    {
      'name': '星巴克',
      'tag': '咖啡',
      'rating': 4.6,
      'time': '20',
      'price': '¥42',
      'discount': '第二杯半价',
      'emoji': '☕',
      'color': Color(0xFF00876C),
    },
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildPlaceholderTab('附近', Icons.location_on_outlined),
          _buildPlaceholderTab('订单', Icons.receipt_long_outlined),
          _buildPlaceholderTab('我的', Icons.person_outline),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        _buildSliverHeader(),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildBanner(),
              _buildCategoryGrid(),
              _buildActivityCards(),
              _buildSectionTitle('附近推荐', '查看更多'),
              _buildNearbyList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: const Color(0xFFFFD100),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE44D), Color(0xFFFFD100)],
          ),
        ),
      ),
      title: _buildSearchBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.headset_mic_outlined, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Text(
                    '北京',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            const Icon(Icons.search, size: 18, color: Color(0xFFFFD100)),
            const SizedBox(width: 6),
            const Text(
              '搜索美食、景点、服务...',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      color: const Color(0xFFFFD100),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _bannerController,
                onPageChanged: (i) => setState(() => _bannerIndex = i),
                itemCount: _banners.length,
                itemBuilder: (context, index) {
                  final b = _banners[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: List<Color>.from(b['gradient']),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Text(
                            b['emoji'],
                            style: const TextStyle(fontSize: 90),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                b['title'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  b['sub'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _bannerIndex == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _bannerIndex == i
                        ? const Color(0xFFFFD100)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildCategoryRow(_categories.sublist(0, 5)),
          const SizedBox(height: 16),
          _buildCategoryRow(_categories.sublist(5, 10)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map((item) => _buildCategoryItem(item)).toList(),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(item['icon'], style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item['label'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCards() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '今日活动',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActivityCard(
                gradient: const [Color(0xFFFF6B35), Color(0xFFFF4757)],
                title: '神券节',
                sub: '超级满减',
                emoji: '🎟️',
              ),
              const SizedBox(width: 10),
              _buildActivityCard(
                gradient: const [Color(0xFF1E90FF), Color(0xFF00CEC9)],
                title: '拼手气',
                sub: '免单大礼包',
                emoji: '🎁',
              ),
              const SizedBox(width: 10),
              _buildActivityCard(
                gradient: const [Color(0xFF2ED573), Color(0xFF26de81)],
                title: '每日领券',
                sub: '签到得红包',
                emoji: '📅',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required List<Color> gradient,
    required String title,
    required String sub,
    required String emoji,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Positioned(
                right: -4,
                bottom: -4,
                child: Text(emoji, style: const TextStyle(fontSize: 36)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  action,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyList() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _nearbyShops.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 80,
          endIndent: 16,
          color: Color(0xFFF0F0F0),
        ),
        itemBuilder: (context, index) {
          final shop = _nearbyShops[index];
          return _buildShopItem(shop);
        },
      ),
    );
  }

  Widget _buildShopItem(Map<String, dynamic> shop) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: (shop['color'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(shop['emoji'], style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        shop['name'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          shop['tag'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: Color(0xFFFFD100)),
                      const SizedBox(width: 2),
                      Text(
                        '${shop['rating']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        '${shop['time']}分钟',
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '人均${shop['price']}',
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      shop['discount'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFFF6B35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': '首页'},
      {'icon': Icons.location_on_rounded, 'label': '附近'},
      {'icon': Icons.receipt_long_rounded, 'label': '订单'},
      {'icon': Icons.person_rounded, 'label': '我的'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = _currentIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFD100).withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected
                              ? const Color(0xFFFFD100)
                              : Colors.grey[400],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? const Color(0xFFFFD100)
                              : Colors.grey[400],
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String label, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
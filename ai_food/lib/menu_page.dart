import 'package:flutter/material.dart';
import 'service/menu_repository.dart';
import 'detail_page.dart'; // 1. ✨ 引入你的菜品详情页文件

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuRepository _repository = MenuRepository();

  Locale _currentLocale = const Locale('zh'); // 默认中文
  final List<String> _categories = ['主食', '饮品', '小吃', '甜品', '加料'];

  int _selectedCategoryIndex = 0;
  final ScrollController _rightScrollController = ScrollController();

  // 核心数据源
  MerchantDetailModel? _merchantDetail;
  Map<String, List<MenuItemModel>> _groupedMenu = {};
  final List<double> _sectionPositions = [];
  bool _isLoaded = false;
  bool _isLeftClickScrolling = false;

  @override
  void initState() {
    super.initState();
    _loadAllPageData();
    _rightScrollController.addListener(_onRightScroll);
  }

  /// 统一捞取头部商家信息与菜品列表
  void _loadAllPageData() async {
    setState(() => _isLoaded = false);

    // 异步请求
    final detail = await _repository.fetchMerchantDetail(_currentLocale);
    final allItems = await _repository.fetchMenuItems(_currentLocale);

    // 初始化分组
    Map<String, List<MenuItemModel>> tempGroup = { for (var cat in _categories) cat : [] };
    for (var item in allItems) {
      if (tempGroup.containsKey(item.category)) {
        tempGroup[item.category]!.add(item);
      }
    }

    // 预计算右侧每个分类区块的高度
    _sectionPositions.clear();
    double currentHeight = 0.0;
    _sectionPositions.add(currentHeight);

    for (var cat in _categories) {
      int itemCount = tempGroup[cat]?.length ?? 0;
      currentHeight += 40.0 + (itemCount * 110.0); // 标题40px + 菜品每行110px
      _sectionPositions.add(currentHeight);
    }

    setState(() {
      _merchantDetail = detail;
      _groupedMenu = tempGroup;
      _isLoaded = true;
    });
  }

  void _onRightScroll() {
    if (_isLeftClickScrolling) return;
    double offset = _rightScrollController.offset;
    for (int i = 0; i < _categories.length; i++) {
      if (offset >= _sectionPositions[i] && offset < _sectionPositions[i + 1]) {
        if (_selectedCategoryIndex != i) {
          setState(() {
            _selectedCategoryIndex = i;
          });
        }
        break;
      }
    }
  }

  void _scrollToSection(int index) async {
    _isLeftClickScrolling = true;
    setState(() {
      _selectedCategoryIndex = index;
    });
    await _rightScrollController.animateTo(
      _sectionPositions[index],
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
    _isLeftClickScrolling = false;
  }

  @override
  void dispose() {
    _rightScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKo = _currentLocale.languageCode == 'ko';

    String getCategoryDisplay(String cat) {
      if (!isKo) return cat;
      switch(cat) {
        case '主食': return '주식';
        case '饮品': return '음료';
        case '小吃': return '스낵';
        case '甜品': return '디저트';
        case '加料': return '토핑';
        default: return cat;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. 深紫色背景的经典顶部导航栏
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              icon: const Icon(Icons.language, color: Colors.white, size: 18),
              label: Text(
                isKo ? '한글' : '中文',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  _currentLocale = isKo ? const Locale('zh') : const Locale('ko');
                  _loadAllPageData();
                });
              },
            ),
          )
        ],
      ),
      body: !_isLoaded || _merchantDetail == null
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple)))
          : Column(
        children: [
          // 2. 店铺名片区域
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _merchantDetail!.logo,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _merchantDetail!.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${isKo ? '별점' : '评分'} ${_merchantDetail!.rating}',
                            style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                          ),
                          _buildDivider(),
                          Text(
                            '${isKo ? '월판매' : '月售'} ${_merchantDetail!.monthlySales}+',
                            style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                          ),
                          _buildDivider(),
                          Text(
                            isKo ? '약 ${_merchantDetail!.deliveryTime}분' : '约 ${_merchantDetail!.deliveryTime}分钟',
                            style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 分割线
          Container(height: 1, color: Colors.grey.shade100),

          // 3. 点菜主区域
          Expanded(
            child: Row(
              children: [
                // 左侧：多分类侧边栏
                Container(
                  width: 90,
                  color: Colors.grey.shade50,
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == _selectedCategoryIndex;
                      return GestureDetector(
                        onTap: () => _scrollToSection(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            border: isSelected
                                ? const Border(left: BorderSide(color: Colors.deepPurple, width: 4))
                                : null,
                          ),
                          child: Text(
                            getCategoryDisplay(_categories[index]),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.deepPurple : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 右侧：联动菜品详情列表
                Expanded(
                  child: ListView.builder(
                    controller: _rightScrollController,
                    itemCount: _categories.length,
                    itemBuilder: (context, catIndex) {
                      String category = _categories[catIndex];
                      List<MenuItemModel> items = _groupedMenu[category] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            color: Colors.grey.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getCategoryDisplay(category),
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                            ),
                          ),
                          ...items.map((item) {
                            // 2. ✨ 将整个菜品卡片用 GestureDetector 包裹，实现点击跳转
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque, // 让空白区域点击也有效
                              onTap: () {
                                // 跳转到详情页并传递当前点击商品的 id
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      productId: item.id, // 对应传入详情页必需的 productId
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 110,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
                                ),
                                child: Row(
                                  children: [
                                    // 菜品图片
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        item.image,
                                        width: 86,
                                        height: 86,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          width: 86, height: 86, color: Colors.grey.shade100,
                                          child: const Icon(Icons.fastfood, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // 菜品信息
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₩${item.price.toStringAsFixed(0)}',
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                              ),
                                              // 加购按钮 (用 GestureDetector 独立拦截点击事件，防止触发外层的页面跳转)
                                              GestureDetector(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor: Colors.deepPurple,
                                                      behavior: SnackBarBehavior.floating,
                                                      content: Text('${item.name} ${isKo ? '장바구니에 담겼습니다' : '已加入购物车'}'),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.deepPurple,
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: Text(
                                                    isKo ? '담기' : '加购',
                                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 10,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}
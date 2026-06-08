import 'package:ai_food/detail_page.dart';
import 'package:ai_food/service/api_service.dart';
import 'package:flutter/material.dart';

// 菜单页面 — 从后端API加载商家菜单
class MenuPage extends StatefulWidget {
  final int? merchantId;
  final String? merchantName;

  const MenuPage({super.key, this.merchantId, this.merchantName});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> menuList = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      final rawList = await ApiService().getFoodByMerchantId(widget.merchantId ?? 1);
      final list = rawList.map((item) {
        final map = item as Map<String, dynamic>;
        return {
          'foodId': map['foodId'] ?? 0,
          'name': map['foodName'] ?? '未知菜品',
          'price': (map['price'] as num?)?.toDouble() ?? 0.0,
          'desc': map['foodDesc'] ?? '',
          'stock': map['stock'] ?? 0,
        };
      }).toList();
      if (mounted) setState(() {menuList = list; _loading = false;});
    } catch (e) {
      if (mounted) setState(() {_error = e.toString(); _loading = false;});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f2fa),
      appBar: AppBar(
        backgroundColor: const Color(0xffd7c1ff),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.merchantName ?? '菜单',
          style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.deepPurple), onPressed: () {}),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('加载失败: $_error'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: '搜索菜单',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.amber, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListView.builder(
                          itemCount: menuList.length,
                          itemBuilder: (context, index) {
                            final item = menuList[index];
                            final foodId = item['foodId'] ?? 0;
                            final itemName = item['name'] as String? ?? '未知';
                            final itemPrice = item['price'] as num? ?? 0;
                            final itemDesc = item['desc'] as String? ?? '';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      width: 85, height: 85,
                                      child: Image.network(
                                        'https://ai-food-images.s3.ap-northeast-2.amazonaws.com/food/$foodId.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xfff5f5f5),
                                          child: const Icon(Icons.restaurant, size: 42, color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(itemName, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87)),
                                        if (itemDesc.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Text(itemDesc, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ),
                                        Text('₩ ${itemPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Row(children: [
                                          _tagWidget("人气"),
                                          const SizedBox(width: 8),
                                          _tagWidget("推荐"),
                                        ]),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 45, height: 45,
                                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15),
                                      boxShadow: [BoxShadow(color: Colors.orange.shade100, blurRadius: 8)],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(productId: "$foodId")));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _tagWidget(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade200)),
      child: Text(text, style: TextStyle(color: Colors.orange.shade700, fontSize: 12)),
    );
  }
}

import 'package:ai_food/service/merchant_repository.dart';
import 'package:flutter/material.dart';

import 'bean/MerchantModel.dart';
import 'config/StrConfig.dart';
import 'menu_page.dart';


class MerchantSearchDelegate extends SearchDelegate {
  final Locale locale;
  final MerchantRepository _repository = MerchantRepository();

  // 缓存全量数据，避免每次输入都重新请求
  List<MerchantModel>? _cachedList;

  MerchantSearchDelegate({required this.locale});

  // 搜索框右侧清空按钮
  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
  ];

  // 搜索框左侧返回按钮
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  // 用户输入中 → 显示联想下拉
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text( StrConfig.of(context).inputName));
    }
    return _buildList(context);
  }

  // 用户点击键盘搜索键 → 显示结果（复用同一个列表即可）
  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<MerchantModel>>(
      future: _getFiltered(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return Center(
            child: Text("${StrConfig.of(context).proNotFound} $query"),
          );
        }
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final merchant = list[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  merchant.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.store, size: 48),
                ),
              ),
              title: _highlight(merchant.name, query), // 高亮匹配文字
              subtitle: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 12),
                  Text(' ${merchant.rating}  ·  ${merchant.deliveryTime}',
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
              onTap: () {
                close(context, merchant); // 关闭搜索，把选中商家回传
                //  跳转商家详情页
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              },
            );
          },
        );
      },
    );
  }

  // 拉全量数据后本地过滤（Mock 阶段够用；真实接口可改成带 keyword 参数的请求）
  Future<List<MerchantModel>> _getFiltered() async {
    _cachedList ??= await _repository.fetchMerchantsByClass(0, locale); // 搜索默认查全部
    return _cachedList!
        .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 高亮匹配部分
  Widget _highlight(String text, String keyword) {
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();
    final index = lowerText.indexOf(lowerKeyword);
    if (index < 0) return Text(text);

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 15),
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + keyword.length),
            style: const TextStyle(
                color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(index + keyword.length)),
        ],
      ),
    );
  }
}
import 'package:ai_food/config/StrConfig.dart';
import 'package:ai_food/service/api_service.dart';
import 'package:flutter/material.dart';

import 'bean/cart_item.dart';
import 'order_confirm_page.dart';

// --- Main Cart Page ---

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  /// 外部调用，刷新购物车数据
  void refreshCart() {
    _fetchCartData();
  }
  List<ShopGroup> _cartGroups = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchCartData(); // 界面初始化时请求数据
  }

  // --- 网络请求方法 ---
  Future<void> _fetchCartData() async {
    // 1. 开始请求前，设置为加载状态
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMsg = null;
      });
    }

    try {
      final foodData = await ApiService().getCartList();
      debugPrint('_fetchCartData: $foodData');

      if (foodData.isNotEmpty && mounted) {
        debugPrint('isNotEmpty:');

        // 2. 将接口返回的 JSON/List 数据映射为你界面的 CartItem 模型
        // 注意：请确保 foodData 的类型与你的 ApiService 返回类型一致
        List<CartItem> items = foodData.map<CartItem>((json) {
          return CartItem.fromJson(json); // 使用我们之前定义的 fromJson 工厂方法
        }).toList();

        // 3. 将扁平的购物车列表按 merchantId 分组为 ShopGroup
        // 因为接口没有返回店铺名称，这里我们按 merchantId 分组，名称暂用 "店铺(ID)"
        Map<int, List<CartItem>> groupedItems = {};
        for (var item in items) {
          // 假设你的 CartItem 模型里有 merchantId 字段 (之前没加的话需要加上)
          groupedItems.putIfAbsent(item.merchantId, () => []).add(item);
        }

        // 4. 将 Map 转换为 List<ShopGroup>
        List<ShopGroup> groups = groupedItems.entries.map((entry) {
          return ShopGroup(
            shopName: '${StrConfig.of(context).shopPrefix} (${entry.key})',
            isSelfOperated: entry.key == 1, // 假设 merchantId == 1 是自营店
            items: entry.value,
          );
        }).toList();

        // 5. 更新状态，触发界面渲染
        debugPrint('setState:');
        setState(() {
          _cartGroups = groups;
          _isLoading = false;
        });

      } else if (mounted) {
        // 请求成功但数据为空
        debugPrint('isEmpty:');
        setState(() {
          _cartGroups = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('加载详情失败: $e');
      // 6. 请求失败，更新错误状态
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMsg = StrConfig.of(context).loadFailedMsg;
        });
      }
    }
  }


  bool get isAllSelected => _cartGroups.isNotEmpty && _cartGroups.every((group) => group.isShopSelected);

  double get totalPrice {
    double total = 0.0;
    for (var group in _cartGroups) {
      for (var item in group.items) {
        if (item.isSelected) {
          total += item.price * item.quantity;
        }
      }
    }
    return total;
  }

  int get selectedCount {
    int count = 0;
    for (var group in _cartGroups) {
      for (var item in group.items) {
        if (item.isSelected) {
          count += item.quantity;
        }
      }
    }
    return count;
  }

  void _toggleAll(bool value) {
    setState(() {
      for (var group in _cartGroups) {
        for (var item in group.items) {
          item.isSelected = value;
        }
      }
    });
  }

  void _toggleShop(ShopGroup group, bool value) {
    setState(() {
      for (var item in group.items) {
        item.isSelected = value;
      }
    });
  }

  void _toggleItem(CartItem item, bool value) {
    setState(() {
      item.isSelected = value;
    });
  }

  void _updateQuantity(CartItem item, int delta) {
    final newQty = item.quantity + delta;
    if (newQty >= 1) {
      setState(() {
        item.quantity = newQty;
      });
    } else if (newQty == 0) {
      // 数量为 0 时，弹窗确认后调用接口删除
      _showDeleteConfirmDialog(item);
    }
  }

  void _showDeleteConfirmDialog(CartItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(StrConfig.of(context).tips),
        content: Text(StrConfig.of(context).confirmDelete.replaceFirst('{0}', item.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(StrConfig.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteItem(item);
            },
            child: Text(StrConfig.of(context).confirm, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(CartItem item) async {
    try {
      await ApiService().deleteCart(item.cartId);
    } catch (e) {
      debugPrint('删除购物车商品失败: $e');
    }

    if (!mounted) return;

    setState(() {
      final groupIndex = _cartGroups.indexWhere((g) => g.items.any((i) => i.cartId == item.cartId));
      if (groupIndex != -1) {
        final group = _cartGroups[groupIndex];
        group.items.removeWhere((i) => i.cartId == item.cartId);
        if (group.items.isEmpty) {
          _cartGroups.removeAt(groupIndex);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('${StrConfig.of(context).cartTitle} (${_cartGroups.fold(0, (sum, g) => sum + g.items.length)})',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(),
      bottomNavigationBar: _cartGroups.isEmpty ? null : _buildBottomBar(),
    );
  }

  // 构建主体内容（处理加载、错误、空和正常状态）
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMsg != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMsg!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchCartData, child: Text(StrConfig.of(context).retry)),
          ],
        ),
      );
    }

    if (_cartGroups.isEmpty || _cartGroups.every((g) => g.items.isEmpty)) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(StrConfig.of(context).cartEmpty, style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // 回到首页（tab 0）
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              icon: const Icon(Icons.explore),
              label: Text(StrConfig.of(context).takeout),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _cartGroups.length,
      itemBuilder: (context, index) {
        return _buildCartGroup(_cartGroups[index]);
      },
    );
  }

  // 底部导航栏
  Widget _buildBottomBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Checkbox(
            value: isAllSelected,
            activeColor: const Color(0xFF6D5AE6),
            shape: const CircleBorder(),
            onChanged: (val) => _toggleAll(val ?? false),
          ),
          Text(StrConfig.of(context).selectAll, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(StrConfig.of(context).totalLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Text('₩${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: selectedCount > 0 ? () {
              final selectedItems = _cartGroups
                  .expand((group) => group.items)
                  .where((item) => item.isSelected)
                  .toList();
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmPage(
                selectedItems: selectedItems,
              )));
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              disabledBackgroundColor: Colors.grey[400],
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: Text('${StrConfig.of(context).checkout}($selectedCount)',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartGroup(ShopGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 4),
            child: Row(
              children: [
                Checkbox(
                    value: group.isShopSelected,
                    onChanged: (v) => _toggleShop(group, v ?? false),
                    activeColor: const Color(0xFF6D5AE6),
                    shape: const CircleBorder()),
                if (group.isSelfOperated)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                    child: Text(StrConfig.of(context).selfOperated, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                Expanded(child: Text(group.shopName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              ],
            ),
          ),
          ...group.items.map((item) => _buildCartItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
              value: item.isSelected,
              onChanged: (v) => _toggleItem(item, v ?? false),
              activeColor: const Color(0xFF6D5AE6),
              shape: const CircleBorder()),
          // 使用网络图片，并处理空图占位
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageUrl.isNotEmpty
                ? Image.network(item.imageUrl, width: 85, height: 85, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage())
                : _buildPlaceholderImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 20), // 原来规格的位置，由于接口没有规格字段，这里用间距替代
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₩${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          _qtyButton(Icons.remove, () => _updateQuantity(item, -1)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('${item.quantity}', style: const TextStyle(fontSize: 12)),
                          ),
                          _qtyButton(Icons.add, () => _updateQuantity(item, 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 占位图组件
  Widget _buildPlaceholderImage() {
    return Container(
      width: 85,
      height: 85,
      color: Colors.grey[200],
      child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}

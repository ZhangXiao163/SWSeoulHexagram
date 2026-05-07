import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/common_card.dart'; // 假设你之前的 CommonCard 在这个文件

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 模拟购物车数据源
  final List<CartItem> _cartList = [
    CartItem(
        title: "烤肉",
        price: 199.0,
        // 👇 替换这里
        imageUrl: "https://share.google/Z3f29Gm55DEzChjjP"
    ),
    CartItem(
        title: "人体工学办公椅",
        price: 899.0,
        // 👇 替换这里
        imageUrl: "https://dummyimage.com/150x150/f0f0f0/333.png&text=办公椅"
    ),
    CartItem(
        title: "机械键盘",
        price: 459.0,
        // 👇 替换这里
        imageUrl: "https://dummyimage.com/150x150/f0f0f0/333.png&text=键盘"
    ),
  ];

  // 计算总价
  double get _totalPrice {
    return _cartList.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // 修改数量的逻辑
  void _updateQuantity(int index, int delta) {
    setState(() {
      _cartList[index].quantity += delta;
      // 数量最少为 1
      if (_cartList[index].quantity < 1) {
        _cartList[index].quantity = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('购物车', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _cartList.length,
              itemBuilder: (context, index) {
                final item = _cartList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CartItemCard(
                    item: item,
                    // 将加减逻辑传递给子组件
                    onAdd: () => _updateQuantity(index, 1),
                    onRemove: () => _updateQuantity(index, -1),
                  ),
                );
              },
            ),
          ),
          _buildCheckoutBar(),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('合计', style: TextStyle(color: Colors.grey)),
                Text(
                  '¥ ${_totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // 这里可以写结算逻辑
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
              ),
              child: const Text('去结算', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// 优化后的子组件
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover,
              // 👇 添加错误处理逻辑
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: AppTheme.background, // 或者 Colors.grey.shade200
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                Text("¥ ${item.price}", style: TextStyle(color: AppTheme.primary)),
              ],
            ),
          ),
          // 数量控制组
          Row(
            children: [
              _qtyButton(Icons.remove, onRemove),
              Container(
                alignment: Alignment.center,
                width: 40,
                child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              _qtyButton(Icons.add, onAdd),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

class CartItem {
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}
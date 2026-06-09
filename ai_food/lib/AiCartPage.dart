import 'package:flutter/material.dart';
import 'order_confirm_page.dart';

// --- Data Models to Manage State ---

class CartItem {
  final String title;
  final String spec;
  final double price;
  final String imageUrl;
  bool isSelected;
  int quantity;

  CartItem({
    required this.title,
    required this.spec,
    required this.price,
    required this.imageUrl,
    this.isSelected = false,
    this.quantity = 1,
  });
}

class ShopGroup {
  final String shopName;
  final bool isSelfOperated;
  final List<CartItem> items;

  ShopGroup({
    required this.shopName,
    required this.isSelfOperated,
    required this.items,
  });

  // Helper to check if all items in this shop are checked
  bool get isShopSelected => items.every((item) => item.isSelected);
}

// --- Main Cart Page ---

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Mock Data Initialization
  final List<ShopGroup> _cartGroups = [
    ShopGroup(
      shopName: '绿联 (UGREEN) 京东自营旗舰店',
      isSelfOperated: true,
      items: [
        CartItem(
          title: '绿联Type-C转千兆扩展坞带网',
          spec: '4合1【千兆网口】USB3.0*3',
          price: 69.00,
          imageUrl: 'assets/images/tiger.png',
        ),
        CartItem(
          title: '绿联安卓快充数据线MicroUSB',
          spec: '【热销80W+】1米安卓快充...',
          price: 13.90,
          imageUrl: 'assets/images/tiger.png',
        ),
      ],
    ),
    ShopGroup(
      shopName: '蟹状元生鲜官方旗舰店',
      isSelfOperated: false,
      items: [
        CartItem(
          title: '【礼券】蟹状元 国货海鲜礼券',
          spec: '1088型内含10件食材 3800g',
          price: 82.90,
          imageUrl: 'assets/images/tiger.png',
        ),
      ],
    ),
  ];

  // Global "Select All" status computed from modern data state
  bool get isAllSelected => _cartGroups.every((group) => group.isShopSelected);

  // Total checkout cost calculated dynamically
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

  // Total selected items quantity count
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

  // --- Logic Methods for Interactive State ---

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
    setState(() {
      final newQty = item.quantity + delta;
      if (newQty >= 1) {
        item.quantity = newQty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('购物车 (${_cartGroups.fold(0, (sum, g) => sum + g.items.length)})',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _cartGroups.length,
              itemBuilder: (context, index) {
                return _buildCartGroup(_cartGroups[index]);
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Toolbar
      bottomNavigationBar: Container(
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
            const Text('全选', style: TextStyle(fontSize: 14)),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text('合计:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text('￥${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('优惠￥2.00', style: TextStyle(fontSize: 10, color: Colors.red)),
              ],
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: selectedCount > 0 ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderConfirmPage()),
                );
              } : null, // Disables button if nothing is selected
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                disabledBackgroundColor: Colors.grey[400],
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              child: Text('去结算($selectedCount)',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  // Shop Group Card Component
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
                    shape: const CircleBorder()
                ),
                if (group.isSelfOperated)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                    child: const Text('自营', style: TextStyle(color: Colors.white, fontSize: 10)),
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

  // Cart Item Row Component
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
              shape: const CircleBorder()
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(item.imageUrl, width: 85, height: 85, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(4)),
                  child: Text(item.spec, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('￥${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold)),
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

  // Refactored helper method to handle ink splashes and tap callbacks cleanly
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
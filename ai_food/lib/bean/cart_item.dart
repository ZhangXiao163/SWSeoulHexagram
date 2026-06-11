/// 购物车商品数据模型，在 CartPage 与 OrderConfirmPage 之间共享。
class CartItem {
  final int cartId;
  final String title; // foodName
  final double price; // foodPrice
  final String imageUrl; // foodImg
  bool isSelected; // selected (1=选中, 0=未选中)
  int quantity; // foodNum
  final int merchantId;

  CartItem({
    required this.cartId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.merchantId,
    this.isSelected = false,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      merchantId: json['merchantId'] ?? 0,
      cartId: json['cartId'] ?? 0,
      title: json['foodName'] ?? '未知商品',
      price: (json['foodPrice'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['foodImg'] ?? '',
      isSelected: json['selected'] == 1,
      quantity: json['foodNum'] ?? 1,
    );
  }
}

/// 按店铺分组的购物车展示模型。
class ShopGroup {
  final String shopName;
  final bool isSelfOperated;
  final List<CartItem> items;

  ShopGroup({
    required this.shopName,
    required this.isSelfOperated,
    required this.items,
  });

  bool get isShopSelected => items.every((item) => item.isSelected);
}

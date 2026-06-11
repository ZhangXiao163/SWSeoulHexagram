class OrderModel {
  final int? orderId;
  final String orderNo;
  final int? userId;
  final int? merchantId;
  final String shopName;
  final String status;
  final String foodName;
  final String description;
  final String price;
  final String imageUrl;
  final String? aiSummary;
  final String? createTime;
  final double? totalPriceRaw;

  OrderModel({
    this.orderId,
    this.orderNo = '',
    this.userId,
    this.merchantId,
    required this.shopName,
    required this.status,
    required this.foodName,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.aiSummary,
    this.createTime,
    this.totalPriceRaw,
  });

  /// 同时兼容后端 /swOrder/findByUserId 真实数据 和 旧 mock 数据
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // 后端真实数据格式（包含 orderNo / totalPrice 等字段）
    if (json.containsKey('orderNo')) {
      const statusMap = {0: '已完成', 1: '配送中', 2: '待付款', 3: '已取消'};
      final rawTotal = (json['totalPrice'] as num?)?.toDouble() ?? 0;
      final totalStr = rawTotal.toStringAsFixed(0);
      final merchantId = json['merchantId'] as int? ?? 0;

      return OrderModel(
        orderId: json['orderId'] as int?,
        orderNo: json['orderNo'] as String? ?? '',
        userId: json['userId'] as int?,
        merchantId: merchantId,
        shopName: '商家 ($merchantId)',
        status: statusMap[json['orderStatus'] as int?] ?? '已完成',
        foodName: '订单 #${json['orderNo'] ?? ''}',
        description: '${json['createTime'] ?? ''}',
        price: totalStr,
        imageUrl: '',
        aiSummary: null,
        createTime: json['createTime'] as String?,
        totalPriceRaw: rawTotal,
      );
    }

    // 旧 mock 数据格式
    return OrderModel(
      shopName: json['shopName'] ?? '',
      status: json['status'] ?? '',
      foodName: json['foodName'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      aiSummary: json['aiSummary'],
    );
  }
}

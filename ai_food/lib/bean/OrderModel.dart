class OrderModel {
  final String shopName;
  final String status;
  final String foodName;
  final String description;
  final String price;
  final String imageUrl;
  final String? aiSummary;

  OrderModel({
    required this.shopName,
    required this.status,
    required this.foodName,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.aiSummary,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      shopName: json['shopName'],
      status: json['status'],
      foodName: json['foodName'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      aiSummary: json['aiSummary'],
    );
  }
}
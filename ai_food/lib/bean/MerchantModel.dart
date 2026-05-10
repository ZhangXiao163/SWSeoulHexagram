class MerchantModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final List<String> tags; // 原来的月售/起送/免配送费，全由接口返回

  const MerchantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.tags,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      deliveryTime: json['deliveryTime'] as String,
      tags: List<String>.from(json['tags']),
    );
  }
}
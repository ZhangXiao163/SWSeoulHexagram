// ── 数据模型 ───────────────────────────────────────────────
class ReviewModel {
  final String name;
  final String content;
  final double rating;

  const ReviewModel({
    required this.name,
    required this.content,
    required this.rating,
  });
}

class DishDetailModel {
  final String id;
  final int merchantId;
  final String name;
  final String nameZh;       // 副标题（中文）
  final String imageUrl;     // 本地 asset 或网络图
  final double price;
  final String currency;
  final String description;
  final List<String> tags;
  final List<ReviewModel> reviews;

  const DishDetailModel({
    required this.id,
    this.merchantId = 1,
    required this.name,
    required this.nameZh,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.description,
    required this.tags,
    required this.reviews,
  });
  DishDetailModel copyWith({String? description}) {
    return DishDetailModel(
      id: id,
      merchantId: merchantId,
      name: name,
      nameZh: nameZh,
      imageUrl: imageUrl,
      price: price,
      currency: currency,
      description: description ?? this.description,
      tags: tags,
      reviews: reviews,
    );
  }
}

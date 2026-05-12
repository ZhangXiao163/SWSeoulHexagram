import 'dart:ui';
import 'package:ai_food/bean/OrderModel.dart';

class OrderRepository {
  Future<List<OrderModel>> fetchOrders(Locale locale) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final bool isKorean = locale.languageCode == 'ko';

    final List<Map<String, dynamic>> mockData = isKorean
        ? [
      {
        'shopName': '고기집 (박교수 삼겹살)',
        'status': '완료',
        'foodName': 'AI 추천: 특선 삼겹살 세트',
        'description': '삼겹살 2인분 + 김치찌개 + 치즈콘 포함',
        'price': '34,500',
        'imageUrl': 'assets/images/tiger.png',
        'aiSummary': 'AI 요약: 리뷰에서 "고기가 신선하다"는 언급이 가장 많습니다.',
      },
      {
        'shopName': '멘토 마라탕',
        'status': '완료',
        'foodName': '마라탕 (중간 맵기)',
        'description': '1.2kg / 10가지 엄선 재료 포함',
        'price': '18,900',
        'imageUrl': 'assets/images/tiger.png',
        'aiSummary': 'AI 요약: 최근 이 가게의 매운맛이 안정적으로 유지되고 있습니다.',
      },
      {
        'shopName': '스시로',
        'status': '리뷰 대기',
        'foodName': '프리미엄 사시미 모둠',
        'description': '연어, 참치, 북극조개 각 2점',
        'price': '52,000',
        'imageUrl': 'assets/images/tiger.png',
        'aiSummary': null,
      },
    ]
        : [
      {
        'shopName': '고기집 (朴教授烤肉店)',
        'status': '已完成',
        'foodName': 'AI 推荐：特级五花肉套餐',
        'description': '包含：五花肉2份 + 泡菜汤 + 芝士玉米',
        'price': '34,500',
        'imageUrl': 'assets/images/tiger.png',
        'aiSummary': 'AI 综述：该店评论中"肉质鲜嫩"提及率最高。',
      },
      {
        'shopName': '멘토 마라탕 (金导师麻辣烫)',
        'status': '已完成',
        'foodName': '自选麻辣烫 (中辣)',
        'description': '1.2kg 份量 / 包含 10 种精选食材',
        'price': '18,900',
        'imageUrl': 'assets/images/tiger.png',
        'aiSummary': 'AI 综述：近期该店辣度稳定，适合喜欢挑战的用户。',
      },
      {
        'shopName': '스시로 (寿司郎)',
        'status': '待评价',
        'foodName': '豪华刺身拼盘',
        'description': '三文鱼、金枪鱼、北极贝各2片',
        'price': '52,000',
        'imageUrl': 'assets/images/tiger.png',
        'aiSummary': null,
      },
    ];

    return mockData.map((e) => OrderModel.fromJson(e)).toList();
  }
}
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import '../bean/MerchantModel.dart';
import 'api_service.dart';

class MerchantRepository {
  /// 根据分类获取商家列表
  Future<List<MerchantModel>> fetchMerchantsByClass(int merchantClass, Locale locale) async {
    try {
      final svc = ApiService();
      developer.log('fetchMerchantsByClass: class=$merchantClass, isLoggedIn=${svc.isLoggedIn}');
      final rawList = await svc.getMerchantList(merchantClass);
      developer.log('rawList length: ${rawList.length}');
      return rawList.map((item) {
        final map = item as Map<String, dynamic>;
        final merchantId = map['merchantId'] ?? map['id'] ?? '';
        final merchantName = map['merchantName'] ?? map['merchant_name'] ?? '未知商家';
        final merchantDesc = map['merchantDesc'] ?? map['merchant_desc'] ?? '';
        return MerchantModel(
          id: merchantId.toString(),
          name: merchantName.toString(),
          imageUrl: 'https://ai-food-images.s3.ap-northeast-2.amazonaws.com/merchant/\${merchantId}.jpg',
          rating: (map['merchantRating'] as num?)?.toDouble() ?? 4.0,
          deliveryTime: '30分钟',
          tags: [merchantDesc.toString().isNotEmpty ? merchantDesc.toString() : '月售500+'],
        );
      }).toList();
    } catch (e) {
      developer.log('fetch merchants by class $merchantClass error: $e');
      rethrow;
    }
  }
}

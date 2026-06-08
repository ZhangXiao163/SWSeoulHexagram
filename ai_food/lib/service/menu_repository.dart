import 'package:flutter/material.dart';

/// 菜品数据模型
class MenuItemModel {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category; // 主食、饮品、小吃、甜品、加料

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });
}

/// 商家基础信息模型
class MerchantDetailModel {
  final String name;
  final String logo;
  final double rating;
  final int monthlySales;
  final int deliveryTime;

  const MerchantDetailModel({
    required this.name,
    required this.logo,
    required this.rating,
    required this.monthlySales,
    required this.deliveryTime,
  });
}

class MenuRepository {
  /// 获取商户的头部基础信息
  Future<MerchantDetailModel> fetchMerchantDetail(Locale locale) async {
    final isKo = locale.languageCode == 'ko';
    return MerchantDetailModel(
      name: isKo ? '맛있는 식당 (강남점)' : '美味餐厅 (江南店)',
      logo: 'assets/images/pho_food.png', // 商家大图 Logo
      rating: 4.8,
      monthlySales: 900,
      deliveryTime: 15,
    );
  }

  /// 获取某种语言下的所有菜品列表（模拟数据库捞取）
  Future<List<MenuItemModel>> fetchMenuItems(Locale locale) async {
    final isKo = locale.languageCode == 'ko';
    return [
      // ====== 主食 ======
      MenuItemModel(id: '101', name: isKo ? '한국식 소고기 덮밥' : '韩式牛肉饭', price: 8000, image: 'assets/images/pho_food.jpg', category: '主食'),
      MenuItemModel(id: '102', name: isKo ? '돈까스' : '炸猪排', price: 7000, image: 'assets/images/pho_food.jpg', category: '主食'),
      MenuItemModel(id: '103', name: isKo ? '냉면' : '冷面', price: 6500, image: 'assets/images/pho_food.jpg', category: '主食'),

      // ====== 饮品 ======
      MenuItemModel(id: '201', name: isKo ? '콜라' : '可乐', price: 2000, image: 'assets/images/pho_food.jpg', category: '饮品'),
      MenuItemModel(id: '202', name: isKo ? '사이다' : '七喜', price: 2000, image: 'assets/images/pho_food.jpg', category: '饮品'),

      // ====== 小吃 ======
      MenuItemModel(id: '301', name: isKo ? '떡볶이' : '辣炒年糕', price: 5000, image: 'assets/images/pho_food.jpg', category: '小吃'),
      MenuItemModel(id: '302', name: isKo ? '튀김 만두' : '炸饺子', price: 4500, image: 'assets/images/pho_food.jpg', category: '小吃'),

      // ====== 甜品 ======
      MenuItemModel(id: '401', name: isKo ? '초코 아이스크림' : '巧克力冰淇淋', price: 3500, image: 'assets/images/pho_food.jpg', category: '甜品'),

      // ====== 加料 ======
      MenuItemModel(id: '501', name: isKo ? '계란 후라이 추가' : '加煎蛋', price: 1000, image: 'assets/images/pho_food.jpg', category: '加料'),
      MenuItemModel(id: '502', name: isKo ? '치즈 추가' : '加芝士', price: 1500, image: 'assets/images/pho_food.jpg', category: '加料'),
    ];
  }
}
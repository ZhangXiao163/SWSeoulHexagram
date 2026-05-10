import 'dart:async';
import 'package:flutter/material.dart';

import '../bean/MerchantModel.dart';

class MerchantRepository {
  Future<List<MerchantModel>> fetchNearbyMerchants(Locale locale) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return locale.languageCode == 'ko' ? _mockDataKo : _mockDataZh;
  }
  static const List<MerchantModel> _mockDataZh = [
    MerchantModel(
      id: '1',
      name: '奈雪的茶 (北京新地佰店)',
      imageUrl: 'assets/images/banner1.jpg',
      rating: 4.8,
      deliveryTime: '25分钟',
      tags: ['月售1000+', '起送¥20', '免配送费'],
    ),
    MerchantModel(
      id: '2',
      name: '麦当劳 (望京 SOHO 店)',
      imageUrl: 'assets/images/banner2.jpg',
      rating: 4.6,
      deliveryTime: '20分钟',
      tags: ['月售5000+', '起送¥15', '免配送费'],
    ),
    MerchantModel(
      id: '3',
      name: '喜茶 (三里屯店)',
      imageUrl: 'assets/images/banner3.jpg',
      rating: 4.9,
      deliveryTime: '30分钟',
      tags: ['月售800+', '起送¥30'],
    ),
    MerchantModel(
      id: '4',
      name: '海底捞火锅 (外卖专线)',
      imageUrl: 'assets/images/banner4.jpg',
      rating: 4.7,
      deliveryTime: '40分钟',
      tags: ['月售2000+', '起送¥50', '免配送费'],
    ),
    MerchantModel(
      id: '5',
      name: '肯德基 (朝阳门店)',
      imageUrl: 'assets/images/banner1.jpg',
      rating: 4.5,
      deliveryTime: '18分钟',
      tags: ['月售3000+', '起送¥15', '免配送费'],
    ),
    MerchantModel(
      id: '6',
      name: '必胜客 (东直门店)',
      imageUrl: 'assets/images/banner2.jpg',
      rating: 4.4,
      deliveryTime: '35分钟',
      tags: ['月售600+', '起送¥40'],
    ),
    MerchantModel(
      id: '7',
      name: '瑞幸咖啡 (国贸店)',
      imageUrl: 'assets/images/banner3.jpg',
      rating: 4.3,
      deliveryTime: '15分钟',
      tags: ['月售4000+', '免起送费', '免配送费'],
    ),
    MerchantModel(
      id: '8',
      name: '星巴克 (建国门外大街)',
      imageUrl: 'assets/images/banner4.jpg',
      rating: 4.6,
      deliveryTime: '22分钟',
      tags: ['月售1200+', '起送¥30'],
    ),
    MerchantModel(
      id: '9',
      name: '杨国福麻辣烫 (团结湖店)',
      imageUrl: 'assets/images/banner1.jpg',
      rating: 4.2,
      deliveryTime: '28分钟',
      tags: ['月售900+', '起送¥15', '免配送费'],
    ),
    MerchantModel(
      id: '10',
      name: '沙县小吃 (劲松店)',
      imageUrl: 'assets/images/banner2.jpg',
      rating: 4.1,
      deliveryTime: '20分钟',
      tags: ['月售500+', '起送¥10', '免配送费'],
    ),
  ];

  static const List<MerchantModel> _mockDataKo = [
    MerchantModel(
      id: '1',
      name: '나쉐더차 (베이징 신디바이점)',
      imageUrl: 'assets/images/banner1.jpg',
      rating: 4.8,
      deliveryTime: '25분',
      tags: ['월판매 1000+', '최소주문 ¥20', '배달비 무료'],
    ),
    MerchantModel(
      id: '2',
      name: '맥도날드 (왕징 SOHO점)',
      imageUrl: 'assets/images/banner2.jpg',
      rating: 4.6,
      deliveryTime: '20분',
      tags: ['월판매 5000+', '최소주문 ¥15', '배달비 무료'],
    ),
    MerchantModel(
      id: '3',
      name: '헤이티 (싼리툰점)',
      imageUrl: 'assets/images/banner3.jpg',
      rating: 4.9,
      deliveryTime: '30분',
      tags: ['월판매 800+', '최소주문 ¥30'],
    ),
    MerchantModel(
      id: '4',
      name: '하이디라오 훠궈 (배달 전용)',
      imageUrl: 'assets/images/banner4.jpg',
      rating: 4.7,
      deliveryTime: '40분',
      tags: ['월판매 2000+', '최소주문 ¥50', '배달비 무료'],
    ),
    MerchantModel(
      id: '5',
      name: 'KFC (차오양먼점)',
      imageUrl: 'assets/images/banner1.jpg',
      rating: 4.5,
      deliveryTime: '18분',
      tags: ['월판매 3000+', '최소주문 ¥15', '배달비 무료'],
    ),
    MerchantModel(
      id: '6',
      name: '피자헛 (둥즈먼점)',
      imageUrl: 'assets/images/banner2.jpg',
      rating: 4.4,
      deliveryTime: '35분',
      tags: ['월판매 600+', '최소주문 ¥40'],
    ),
    MerchantModel(
      id: '7',
      name: '루이싱커피 (궈마오점)',
      imageUrl: 'assets/images/banner3.jpg',
      rating: 4.3,
      deliveryTime: '15분',
      tags: ['월판매 4000+', '최소주문 없음', '배달비 무료'],
    ),
    MerchantModel(
      id: '8',
      name: '스타벅스 (젠궈먼외대가점)',
      imageUrl: 'assets/images/banner4.jpg',
      rating: 4.6,
      deliveryTime: '22분',
      tags: ['월판매 1200+', '최소주문 ¥30'],
    ),
    MerchantModel(
      id: '9',
      name: '양궈푸 마라탕 (퇀제후점)',
      imageUrl: 'assets/images/banner1.jpg',
      rating: 4.2,
      deliveryTime: '28분',
      tags: ['월판매 900+', '최소주문 ¥15', '배달비 무료'],
    ),
    MerchantModel(
      id: '10',
      name: '샤현 샤오츠 (징쑹점)',
      imageUrl: 'assets/images/banner2.jpg',
      rating: 4.1,
      deliveryTime: '20분',
      tags: ['월판매 500+', '최소주문 ¥10', '배달비 무료'],
    ),
  ];
}
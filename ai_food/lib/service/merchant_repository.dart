import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart'; // 引入新版依赖库

import '../bean/MerchantModel.dart'; // 引入你的商户模型

class MerchantRepository {

  Future<List<MerchantModel>> fetchNearbyMerchants(Locale locale) async {
    List<MerchantModel> merchants = [];

    // 1. 创建数据库连接
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "123456",
      databaseName: "ai_food", // 数据库名
    );

    try {
      // 2. 建立连接
      await conn.connect();

      // 3. 执行 SQL 查询（使用你的真实表名 ai_food_store）
      var results = await conn.execute("SELECT * FROM ai_food_store;");

      // 4. 遍历查询到的每一行数据
      for (var row in results.rows) {

        // 🛠️ 核心修正：assoc 后面必须加上 () 才能作为方法调用！
        final data = row.assoc();

        // ✨ 安全提取基础 String 字段
        final String merchantId = data['merchant_id'] ?? '0';
        final String merchantName = data['merchant_name'] ?? '未知商家';
        final String category = data['category'] ?? '';

        // ✨ 类型安全转换（从 Map 提取 String? 后进行数值转型）
        final double rating = double.tryParse(data['rating'] ?? '') ?? 0.0;
        final double avgConsumption = double.tryParse(data['avg_consumption'] ?? '') ?? 0.0;
        final double minDeliveryPrice = double.tryParse(data['min_delivery_price'] ?? '') ?? 0.0;
        final double deliveryFee = double.tryParse(data['delivery_fee'] ?? '') ?? 0.0;
        final int monthlySales = int.tryParse(data['monthly_sales'] ?? '') ?? 0;

        // 5. 动态生成多语言原先 UI 需用的 tags 列表
        final isKo = locale.languageCode == 'ko';
        final minPriceText = isKo ? '최소주문 ¥$minDeliveryPrice' : '起送¥${minDeliveryPrice.toStringAsFixed(0)}';
        final salesText = isKo ? '월판매 $monthlySales+' : '月售$monthlySales+';

        final feeText = deliveryFee == 0
            ? (isKo ? '배달비 무료' : '免配送费')
            : (isKo ? '배달비 ¥$deliveryFee' : '配送费¥$deliveryFee');

        // 6. 装配进你配置完美的 MerchantModel 实体中
        merchants.add(MerchantModel(
          id: merchantId,
          name: merchantName,
          imageUrl: 'assets/images/banner1.jpg', // 默认资产图片
          rating: rating,
          deliveryTime: isKo ? '25분' : '25分钟',  // 默认配送时间
          tags: [salesText, minPriceText, feeText], // 标签组合
          category: category,
          avgConsumption: avgConsumption,
          minDeliveryPrice: minDeliveryPrice,
          deliveryFee: deliveryFee,
          monthlySales: monthlySales,
        ));
      }
    } catch (e) {
      print('❌ 数据库读取或解析失败: $e');
    } finally {
      // 7. 关闭连接释放资源
      await conn.close();
    }

    return merchants;
  }
}
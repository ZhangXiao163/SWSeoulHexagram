import 'package:ai_food/config/StrConfig.dart';
import 'package:flutter/material.dart';

import 'order_complete.dart';
void main() {
  runApp(const MyApp());
}
const Color mainPurple = Color(0xFFF3ECFF);
const Color mainYellow = Color(0xFFFFC107);
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderConfirmPage(),
    );
  }
}
class OrderConfirmPage extends StatelessWidget {
  const OrderConfirmPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurple,
      appBar: AppBar(
        backgroundColor: mainPurple,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Text(
          StrConfig.of(context).confirmOrder,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StrConfig.of(context).discountSaved.replaceFirst('{0}', '2'),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    StrConfig.of(context).totalPriceSummary.replaceFirst('{0}', '15.88'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderCompletePage()),
                  );
                },
                child: Text(
                  StrConfig.of(context).submitOrder,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 提示栏
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.volume_up,
                      color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      StrConfig.of(context).warmTipsText,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 地址卡片
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  rowItem(
                    Icons.location_on,
                    StrConfig.of(context).deliveryAddress,
                    "서울특별시 홍대 101호",
                  ),
                  const Divider(height: 28),
                  rowItem(
                    Icons.access_time,
                    StrConfig.of(context).deliveryTime,
                    StrConfig.of(context).estimatedDelivery.replaceFirst('{0}', '10:16'),
                  ),
                  const Divider(height: 28),
                  rowItem(
                    Icons.payments,
                    StrConfig.of(context).paymentMethod,
                    "Alipay",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // 商品卡片
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(16),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "招牌经典韩式拌饭",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "辣味 / 热销",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "x1",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "¥15",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  priceRow(StrConfig.of(context).packagingFee, "¥1.88"),
                  priceRow(StrConfig.of(context).deliveryFeeLabel, "¥0"),
                  priceRow(StrConfig.of(context).couponDiscount, "-¥1"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  static Widget rowItem(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
  static Widget priceRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            left,
            style: const TextStyle(fontSize: 15),
          ),
          const Spacer(),
          Text(
            right,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
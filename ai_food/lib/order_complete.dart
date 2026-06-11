import 'package:ai_food/config/StrConfig.dart';
import 'package:flutter/material.dart';

const Color mainPurple = Color(0xFFF3ECFF);
const Color mainYellow = Color(0xFFFFC107);

class OrderCompletePage extends StatelessWidget {
  final double totalAmount;
  final String orderNumber;

  const OrderCompletePage({
    super.key,
    this.totalAmount = 0,
    this.orderNumber = '',
  });

  String get _displayOrderNumber =>
      orderNumber.isNotEmpty ? orderNumber : '#${DateTime.now().millisecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurple,
      appBar: AppBar(
        backgroundColor: mainPurple,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Text(
          StrConfig.of(context).orderCompleteTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 完成图标
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainYellow,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 75,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 35),
                  // 标题
                  Text(
                    StrConfig.of(context).orderCompleted,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 副标题
                  Text(
                    StrConfig.of(context).orderThanks,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 35),
                  // 订单信息卡片
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: mainPurple,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Text(
                          StrConfig.of(context).orderNumberLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _displayOrderNumber,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              StrConfig.of(context).paymentAmountLabel,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '₩${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  // 返回主页按钮
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // 返回主页，清除导航栈
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        StrConfig.of(context).backToHome,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 再来一单
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.orange.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      child: Text(
                        StrConfig.of(context).orderAgain,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

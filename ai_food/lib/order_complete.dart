import 'package:flutter/material.dart';

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
      home: OrderCompletePage(),
    );
  }
}

class OrderCompletePage extends StatelessWidget {
  const OrderCompletePage({super.key});

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

        title: const Text(
          "订单完成",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      // 改这里
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
                  const Text(
                    "订单已完成",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 副标题
                  const Text(
                    "感谢您的购买\n祝您用餐愉快 ㅎㅎ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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

                      borderRadius:
                      BorderRadius.circular(24),
                    ),

                    child: const Column(

                      children: [

                        Text(
                          "订单编号",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          "#20260516001",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),

                        SizedBox(height: 18),

                        Divider(),

                        SizedBox(height: 18),

                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: [

                            Text(
                              "支付金额",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),

                            Text(
                              "¥15.88",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
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
                          borderRadius:
                          BorderRadius.circular(18),
                        ),

                        elevation: 0,
                      ),

                      onPressed: () {},

                      child: const Text(
                        "返回主页",
                        style: TextStyle(
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
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () {},

                      child: const Text(
                        "再来一单",
                        style: TextStyle(
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
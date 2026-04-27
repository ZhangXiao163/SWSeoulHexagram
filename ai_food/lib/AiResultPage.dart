import 'package:flutter/material.dart';

class AiResultPage extends StatelessWidget {
  final String result;

  const AiResultPage({required this.result});

  Map<String, String> parseResult(String text) {
    List<String> parts = text.split("\n");

    String food = "추천 음식";
    String reason = text;

    if (parts.length >= 2) {
      food = parts[0].replaceAll("추천:", "").trim();
      reason = parts[1].replaceAll("이유:", "").trim();
    }

    return {
      "food": food,
      "reason": reason,
    };
  }

  String getImage(String food) {
    if (food.contains("떡볶이")) return "assets/images/tteokbokki.png";
    if (food.contains("치킨")) return "assets/images/chicken.png";
    if (food.contains("라면")) return "assets/images/ramen.png";
    return "assets/images/bibimbap.png";
  }

  @override
  Widget build(BuildContext context) {
    final parsed = parseResult(result);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("AI 추천 결과"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          // ⭐ 关键：整体居中 + 控制宽度
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,

              child: Column(
                children: [

                  // ⭐ 主卡片（图片+内容一体）
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 图片
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Image.asset(
                            getImage(parsed["food"]!),
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // 标签
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "AI 추천",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),

                              SizedBox(height: 10),

                              // 菜名
                              Text(
                                parsed["food"]!,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 10),

                              // 推荐理由
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.lightbulb,
                                        color: Colors.orange),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        parsed["reason"]!,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 15),

                              // 评分 + 价格
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 18),
                                  Text(" 4.5"),
                                  SizedBox(width: 10),
                                  Text("₩ 9,000"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // ⭐ 按钮区
                  Row(
                    children: [

                      // 加入购物车
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("장바구니에 추가되었습니다")),
                            );
                          },
                          child: Text("장바구니 담기"),
                        ),
                      ),

                      SizedBox(width: 10),

                      // 重新推荐
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("다시 추천"),
                        ),
                      ),
                    ],
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
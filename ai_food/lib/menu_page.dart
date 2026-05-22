import 'package:ai_food/detail_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 主应用
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuPage(),
    );
  }
}

// 菜单页面
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  // 菜单数据
  final List<Map<String, dynamic>> menuList = [
    {
      "name": "韩式牛肉",
      "price": "¥ 8,000",
      "image": Icons.ramen_dining,
    },
    {
      "name": "炸猪排",
      "price": "¥ 7,000",
      "image": Icons.lunch_dining,
    },
    {
      "name": "冷面",
      "price": "¥ 6,500",
      "image": Icons.restaurant,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // 页面背景颜色
      backgroundColor: const Color(0xfff7f2fa),

      // 顶部导航栏
      appBar: AppBar(

        backgroundColor: const Color(0xffd7c1ff),

        elevation: 0,

        // 返回按钮
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        // 标题
        title: const Text(
          '菜单',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        centerTitle: true,

        // 收藏按钮
        actions: [

          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.deepPurple,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            // 搜索框
            TextField(

              decoration: InputDecoration(

                hintText: '搜索菜单',

                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),

                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),

                filled: true,

                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),

                enabledBorder: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(30),

                  borderSide: const BorderSide(
                    color: Colors.amber,
                    width: 2,
                  ),
                ),

                focusedBorder: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(30),

                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 菜单列表
            Expanded(

              child: ListView.builder(

                itemCount: menuList.length,

                itemBuilder: (context, index) {

                  final item = menuList[index];

                  return Container(

                    margin: const EdgeInsets.only(bottom: 18),

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),

                      boxShadow: const [

                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(

                      children: [

                        // 图片区域
                        Container(

                          width: 85,
                          height: 85,

                          decoration: BoxDecoration(

                            color: const Color(0xfff5f5f5),

                            borderRadius:
                            BorderRadius.circular(15),
                          ),

                          child: Icon(
                            item["image"],
                            size: 42,
                            color: Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 菜品信息
                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                item["name"],
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                item["price"],
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 标签
                              Row(

                                children: [

                                  tagWidget("人气"),

                                  const SizedBox(width: 8),

                                  tagWidget("推荐"),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 添加按钮
                        Container(

                          width: 45,
                          height: 45,

                          decoration: BoxDecoration(

                            color: Colors.orange,

                            borderRadius:
                            BorderRadius.circular(15),

                            boxShadow: [

                              BoxShadow(
                                color: Colors.orange.shade100,
                                blurRadius: 8,
                              ),
                            ],
                          ),

                          child: IconButton(

                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DetailPage(productId: "牛肉盖饭")),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                SnackBar(

                                  backgroundColor:
                                  Colors.deepPurple,

                                  behavior:
                                  SnackBarBehavior.floating,

                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),

                                  content: Text(
                                    '${item["name"]} 已加入购物车',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 标签组件
  Widget tagWidget(String text) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(

        color: Colors.orange.shade50,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(
          color: Colors.orange.shade200,
        ),
      ),

      child: Text(
        text,
        style: TextStyle(
          color: Colors.orange.shade700,
          fontSize: 12,
        ),
      ),
    );
  }
}
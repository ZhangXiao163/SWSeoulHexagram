import 'package:flutter/material.dart';

import 'detail_page.dart';

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

      backgroundColor: Colors.white,

      // 顶部导航栏
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // 返回按钮
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        // 标题
        title: const Text(
          '菜单',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        // 收藏按钮
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.black,
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

                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.grey.shade200,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 菜单列表
            Expanded(
              child: ListView.builder(
                itemCount: menuList.length,

                itemBuilder: (context, index) {

                  final item = menuList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),

                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    child: Row(
                      children: [

                        // 图片区域
                        Container(
                          width: 80,
                          height: 80,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Icon(
                            item["image"],
                            size: 40,
                            color: Colors.white,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                item["price"],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 添加按钮
                        Container(
                          width: 40,
                          height: 40,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),

                            onPressed: () {

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                SnackBar(
                                  content: Text(
                                    '${item["name"]} 已加入购物车',
                                  ),
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DetailPage(productId:'牛肉饭',)),
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
}
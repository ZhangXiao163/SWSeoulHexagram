import 'package:flutter/material.dart';

import 'order_confirm_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('购物车 (5)', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: const Text('管理', style: TextStyle(color: Colors.black)),
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.more_horiz, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // 精简后的地址栏：去掉了右侧所有筛选按钮
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          //   color: Colors.white,
          //   child: Row(
          //     children: const [
          //       Icon(Icons.location_on, size: 16, color: Colors.grey),
          //       SizedBox(width: 4),
          //       Text('景阳胡同1号四合院...', style: TextStyle(fontSize: 13, color: Colors.grey)),
          //     ],
          //   ),
          // ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // 店铺分组卡片
                _buildCartGroup(
                  shopName: '绿联 (UGREEN) 京东自营旗舰店',
                  isSelfOperated: true,
                  items: [
                    _buildCartItem(
                      title: '绿联Type-C转千兆扩展坞带网',
                      spec: '4合1【千兆网口】USB3.0*3',
                      price: '69.00',
                      imageUrl: 'assets/images/tiger.png',
                    ),
                    _buildCartItem(
                      title: '绿联安卓快充数据线MicroUSB',
                      spec: '【热销80W+】1米安卓快充...',
                      price: '13.90',
                      imageUrl: 'assets/images/tiger.png',
                    ),
                  ],
                ),

                _buildCartGroup(
                  shopName: '蟹状元生鲜官方旗舰店',
                  isSelfOperated: false,
                  items: [
                    _buildCartItem(
                      title: '【礼券】蟹状元 国货海鲜礼券',
                      spec: '1088型内含10件食材 3800g',
                      price: '82.90',
                      imageUrl: 'assets/images/tiger.png',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // 底部结算栏
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Checkbox(
              value: isAllSelected,
              activeColor: const Color(0xFF6D5AE6),
              shape: const CircleBorder(), // 圆形勾选框更符合现代 UI
              onChanged: (val) => setState(() => isAllSelected = val!),
            ),
            const Text('全选', style: TextStyle(fontSize: 14)),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    Text('合计:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Text('￥82.90', style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('优惠￥2.00', style: TextStyle(fontSize: 10, color: Colors.red)),
              ],
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderConfirmPage()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              child: const Text('去结算(2)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  // 店铺分组容器
  Widget _buildCartGroup({required String shopName, required bool isSelfOperated, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 4),
            child: Row(
              children: [
                Checkbox(value: false, onChanged: (v) {}, activeColor: const Color(0xFF6D5AE6), shape: const CircleBorder()),
                if (isSelfOperated)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                    child: const Text('自营', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                Expanded(child: Text(shopName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  // 商品列表项
  Widget _buildCartItem({required String title, required String spec, required String price, required String imageUrl}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: false, onChanged: (v) {}, activeColor: const Color(0xFF6D5AE6), shape: const CircleBorder()),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imageUrl, width: 85, height: 85, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(4)),
                  child: Text(spec, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('￥$price', style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          _qtyIcon(Icons.remove),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text('1', style: TextStyle(fontSize: 12)),
                          ),
                          _qtyIcon(Icons.add),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Icon(icon, size: 16, color: Colors.black87),
    );
  }
}
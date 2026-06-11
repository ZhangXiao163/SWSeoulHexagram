import 'package:flutter/material.dart';
import 'package:ai_food/bean/OrderModel.dart';
import 'package:ai_food/service/api_service.dart';
import 'config/StrConfig.dart';
import 'home.dart';

class FoodOrderListScreen extends StatefulWidget {
  const FoodOrderListScreen({super.key});

  @override
  State<FoodOrderListScreen> createState() => FoodOrderListScreenState();
}

class FoodOrderListScreenState extends State<FoodOrderListScreen> {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMsg;

  /// 外部调用，刷新订单列表
  void refreshOrders() {
    _loadOrders();
  }

  @override
  void initState() {
    super.initState();
    _loadOrders();
    appLocale.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => _loadOrders();

  @override
  void dispose() {
    appLocale.removeListener(_onLocaleChanged);
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final list = await ApiService().findOrdersByUserId(1);
      setState(() => _orders = list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          StrConfig.of(context).order,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMsg != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(_errorMsg!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadOrders, child: Text(StrConfig.of(context).retry)),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(StrConfig.of(context).noOrders, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders, // 下拉刷新
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _orders.length,
        itemBuilder: (context, index) => _buildOrderItem(_orders[index]),
      ),
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商店头部
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    order.shopName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                ],
              ),
              Text(
                order.status,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 内容部
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: order.imageUrl.isNotEmpty
                      ? (order.imageUrl.startsWith('assets/')
                          ? Image.asset(order.imageUrl, fit: BoxFit.cover)
                          : Image.network(order.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.receipt_long, size: 40, color: Colors.grey)))
                      : const Icon(Icons.receipt_long, size: 40, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.foodName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // const Text(
                    //   '支持7天无理由退货 (礼券适用)',
                    //   style: TextStyle(color: Colors.orange, fontSize: 11),
                    // ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₩${order.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    StrConfig.of(context).totalItems.replaceFirst('{0}', '1'),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          // AI 摘要
          if (order.aiSummary != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: Color(0xFF6D5AE6),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.aiSummary!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6D5AE6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 15),

          // 按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // _buildActionButton('更多', Colors.grey[600]!),
              // const SizedBox(width: 8),
              // _buildActionButton('查看发票', Colors.black),
              // const SizedBox(width: 8),
              // _buildActionButton('退款/售后', Colors.black),
              const SizedBox(width: 8),
              _buildActionButton(
                StrConfig.of(context).buyAgain,
                Colors.red,
                isHighlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isHighlight ? Colors.red : Colors.grey[300]!),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

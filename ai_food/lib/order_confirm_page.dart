import 'dart:math';

import 'package:ai_food/config/StrConfig.dart';
import 'package:ai_food/service/api_service.dart';
import 'package:flutter/material.dart';

import 'package:ai_food/bean/cart_item.dart';
import 'payment_page.dart';

const Color mainPurple = Color(0xFFF3ECFF);
const Color mainYellow = Color(0xFFFFC107);

class OrderConfirmPage extends StatefulWidget {
  final List<CartItem> selectedItems;

  const OrderConfirmPage({
    super.key,
    required this.selectedItems,
  });

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  bool _isSubmitting = false;

  List<CartItem> get _items => widget.selectedItems;

  /// 商品小计
  double get itemsTotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  /// 包装费（每件 ₩1.00）
  double get packagingFee => _items.isEmpty ? 0 : _items.length * 1.0;

  /// 配送费
  double get deliveryFee => 0;

  /// 红包优惠
  double get couponDiscount => 0;

  /// 最终合计
  double get finalTotal => itemsTotal + packagingFee + deliveryFee - couponDiscount;

  /// 预计送达时间（当前系统时间 + 30分钟）
  String get estimatedArrivalTime {
    final now = DateTime.now().add(const Duration(minutes: 30));
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  /// 生成订单号：时间戳 + 4位随机数
  String _generateOrderNo() {
    final now = DateTime.now();
    final ts = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final rand = Random().nextInt(9999).toString().padLeft(4, '0');
    return '$ts$rand';
  }

  Future<void> _submitOrder() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final orderNo = _generateOrderNo();
      // 取第一个商品的 merchantId，若无商品则用 0
      final merchantId = _items.isNotEmpty ? _items.first.merchantId : 0;

      final res = await ApiService().submitOrder(
        orderNo: orderNo,
        userId: 1, // 当前硬编码用户ID
        merchantId: merchantId,
        addressId: 0,
        totalPrice: finalTotal,
        orderStatus: 0,
      );

      if (!mounted) return;

      final sysCode = res['sysCode'] as String? ?? '';

      if (sysCode == '0000') {
        // 提交成功 → 删除购物车中已下单的商品
        for (var item in _items) {
          try {
            await ApiService().deleteCart(item.cartId);
          } catch (_) {
            // 单个删除失败不影响整体流程
          }
        }

        if (!mounted) return;

        // 跳转支付页
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              totalAmount: finalTotal,
              orderNumber: '#$orderNo',
            ),
          ),
        );
      } else {
        // 后端返回业务错误
        final msg = res['sysMessage'] as String? ?? '提交失败';
        _showError(msg);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('网络错误: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

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
                  if (couponDiscount > 0)
                    Text(
                      StrConfig.of(context).discountSaved.replaceFirst(
                          '{0}', couponDiscount.toStringAsFixed(0)),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    StrConfig.of(context)
                        .totalPriceSummary
                        .replaceFirst('{0}', finalTotal.toStringAsFixed(2)),
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
                onPressed: _isSubmitting ? null : _submitOrder,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
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
                  const Icon(Icons.volume_up, color: Colors.orange),
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
                    StrConfig.of(context)
                        .estimatedDelivery
                        .replaceFirst('{0}', estimatedArrivalTime),
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
                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isLast = index == _items.length - 1;
                    return Column(
                      children: [
                        _buildProductRow(item),
                        if (!isLast)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  priceRow(StrConfig.of(context).packagingFee,
                      '₩${packagingFee.toStringAsFixed(2)}'),
                  priceRow(StrConfig.of(context).deliveryFeeLabel, '₩0'),
                  if (couponDiscount > 0)
                    priceRow(StrConfig.of(context).couponDiscount,
                        '-₩${couponDiscount.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(CartItem item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: item.imageUrl.isNotEmpty
              ? Image.network(
                  item.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'x${item.quantity}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          '₩${(item.price * item.quantity).toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[200],
      child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
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

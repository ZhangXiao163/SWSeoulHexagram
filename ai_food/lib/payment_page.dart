import 'package:ai_food/config/StrConfig.dart';
import 'package:flutter/material.dart';

import 'order_complete.dart';

const Color mainPurple = Color(0xFFF3ECFF);
const Color mainYellow = Color(0xFFFFC107);

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String orderNumber;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.orderNumber,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? _selectedIndex;
  bool _isProcessing = false;

  static const _paymentMethods = [
    _PaymentMethod('KakaoPay', Icons.chat_bubble, Color(0xFFFFE812), '카카오페이'),
    _PaymentMethod('NaverPay', Icons.shopping_bag, Color(0xFF03C75A), '네이버페이'),
    _PaymentMethod('Toss', Icons.send, Color(0xFF3182F6), '토스'),
    _PaymentMethod('Credit Card', Icons.credit_card, Color(0xFF6D5AE6), '신용카드'),
    _PaymentMethod('Alipay', Icons.account_balance_wallet, Color(0xFF1677FF), 'Alipay'),
  ];

  void _confirmPayment() {
    if (_selectedIndex == null) return;

    setState(() => _isProcessing = true);

    // 模拟支付处理 1.5 秒
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      // 替换当前支付页和确认订单页，跳转到订单完成页
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OrderCompletePage(
            totalAmount: widget.totalAmount,
            orderNumber: widget.orderNumber,
          ),
        ),
        (route) => route.isFirst, // 保留首页
      );
    });
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
          onPressed: _isProcessing ? null : () => Navigator.maybePop(context),
        ),
        title: Text(
          StrConfig.of(context).selectPayment,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: _isProcessing ? null : _buildBottomBar(context),
      body: _isProcessing ? _buildProcessing() : _buildPaymentList(context),
    );
  }

  Widget _buildPaymentList(BuildContext context) {
    return Column(
      children: [
        // 金额展示
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Text(
                StrConfig.of(context).paymentAmountLabel,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                '₩${widget.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${StrConfig.of(context).orderNumberLabel} ${widget.orderNumber}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 支付方式列表
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StrConfig.of(context).selectPayment,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: _paymentMethods.length,
                    separatorBuilder: (context, i) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final method = _paymentMethods[index];
                      final isSelected = _selectedIndex == index;
                      return _buildPaymentTile(method, index, isSelected);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile(_PaymentMethod method, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? mainPurple : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6D5AE6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method.color.withAlpha(30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(method.icon, color: method.color, size: 26),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  method.subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF6D5AE6) : Colors.grey[300]!,
                  width: isSelected ? 7 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessing() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: mainYellow,
            ),
            child: const Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            StrConfig.of(context).paymentProcessing,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₩${widget.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    if (_isProcessing) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedIndex != null ? mainYellow : Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          onPressed: _selectedIndex != null ? _confirmPayment : null,
          child: Text(
            StrConfig.of(context).confirmPayment,
            style: TextStyle(
              color: _selectedIndex != null ? Colors.black : Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethod {
  final String label;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _PaymentMethod(this.label, this.icon, this.color, this.subtitle);
}

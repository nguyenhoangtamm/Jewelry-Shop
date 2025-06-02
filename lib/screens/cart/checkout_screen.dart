import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Đảm bảo đã import go_router

import '../../services/cart_service.dart';
import '../../utils/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool isProcessing = false;

  double get totalAmount {
    final cartService = context.read<CartService>();
    return cartService.total;
  }

  void handlePayment() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isProcessing = false);

    showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Thanh toán thành công'),
      content: Text(
        'Cảm ơn bạn, ${_nameController.text}, đã mua hàng!\n'
        'Đơn hàng sẽ được giao tới: ${_addressController.text}.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng dialog
            context.go('/home'); // Chuyển về home_screen.dart
          },
          child: const Text('Đóng'),
        ),
      ],
    ),
  );

  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cart'), // Quay lại giỏ hàng
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Icon(Icons.payment, size: 64, color: AppTheme.primaryGold),
              const SizedBox(height: 16),
              const Text(
                'Thông tin thanh toán',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên khách hàng',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.length < 9
                    ? 'Số điện thoại không hợp lệ'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập địa chỉ'
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Tổng tiền: ${totalAmount.toStringAsFixed(0)} VNĐ',
                style: const TextStyle(fontSize: 18, color: AppTheme.deepBlue),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isProcessing ? null : handlePayment,
                icon: const Icon(Icons.lock),
                label: isProcessing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Xác nhận thanh toán'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

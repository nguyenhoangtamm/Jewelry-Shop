import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('shipping_address');
    if (savedAddress != null && savedAddress.isNotEmpty) {
      _addressController.text = savedAddress;
    }
  }

  Future<void> handlePayment() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => isProcessing = true);

    final cartService = context.read<CartService>();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shipping_address', _addressController.text.trim());

    await Future.delayed(const Duration(seconds: 2));
    await cartService.clearCart();

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
              context.go('/home'); // Quay về home hoặc màn bạn muốn
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final totalAmount = cartService.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
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

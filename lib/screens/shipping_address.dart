import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('shipping_address');
    if (savedAddress != null) {
      _addressController.text = savedAddress;
    }
  }

  Future<void> _saveAddress() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shipping_address', address);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu địa chỉ thành công')),
    );

    Navigator.of(context).pop(); // Quay lại màn hình trước (Checkout)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Nhập địa chỉ giao hàng',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveAddress,
              child: const Text('Lưu địa chỉ'),
            ),
          ],
        ),
      ),
    );
  }
}

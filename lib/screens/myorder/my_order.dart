import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:jewelry_management_app/utils/app_theme.dart';
import '../../models/order.dart';

class MyOrdersPage extends StatelessWidget {
  final List<Order> orders;

  const MyOrdersPage({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
        title: const Text('Đơn hàng của tôi'),
        backgroundColor: AppTheme.primaryGold,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mã đơn hàng: ${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Ngày đặt: ${dateFormatter.format(order.createdAt)}'),
                  Text('Tổng tiền: ${currencyFormatter.format(order.total)}'),
                  const SizedBox(height: 8),
                  const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...order.items.map((item) => Text('• ${item.jewelry.name} x${item.quantity}')).toList(),
                  const SizedBox(height: 8),
                  Text('Địa chỉ: ${order.shippingAddress}'),
                  Text('Thanh toán: ${order.status == OrderStatus.pending ? "Chưa thanh toán" : "Đã thanh toán"}'),
                  if (order.trackingNumber != null)
                    Text('Mã vận đơn: ${order.trackingNumber}'),
                  Row(
                    children: [
                      const Text('Trạng thái: '),
                      Chip(
                        label: Text(order.statusText),
                        backgroundColor: _getStatusColor(order.status),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showOrderDetails(context, order);
                        },
                        child: const Text('Xem chi tiết'),
                      ),
                      if (order.canCancel)
                        TextButton(
                          onPressed: () {
                            _showCancelDialog(context, order);
                          },
                          child: const Text(
                            'Hủy đơn',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blueAccent;
      case OrderStatus.processing:
        return Colors.deepPurple;
      case OrderStatus.shipping:
        return Colors.teal;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.refunded:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void _showCancelDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _cancelOrder(order);
            },
            child: const Text('Hủy đơn', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _cancelOrder(Order order) {
    // TODO: Gọi hàm hủy đơn từ API hoặc service
    print('Đã gửi yêu cầu hủy đơn hàng: ${order.id}');
  }

  void _showOrderDetails(BuildContext context, Order order) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text('Chi tiết đơn hàng', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('Mã đơn hàng: ${order.id}'),
                Text('Ngày đặt: ${DateFormat('dd/MM/yyyy').format(order.createdAt)}'),
                Text('Trạng thái: ${order.statusText}'),
                if (order.trackingNumber != null)
                  Text('Mã vận đơn: ${order.trackingNumber}'),
                const SizedBox(height: 8),
                Text('Địa chỉ giao hàng: ${order.shippingAddress}'),
                const Divider(height: 24),
                Text('Sản phẩm:', style: const TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                          '- ${item.jewelry.name} x${item.quantity} (${currencyFormatter.format(item.jewelry.price)})'),
                    )),
                const Divider(height: 24),
                Text('Tạm tính: ${currencyFormatter.format(order.subtotal)}'),
                Text('Phí giao hàng: ${currencyFormatter.format(order.shippingFee)}'),
                Text('Giảm giá: ${currencyFormatter.format(order.discount)}'),
                Text('Tổng tiền: ${currencyFormatter.format(order.total)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

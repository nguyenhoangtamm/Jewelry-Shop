import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có đơn hàng nào',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mua sắm ngay để xem lịch sử đơn hàng',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return OrderCard(
                order: order,
                onStatusChanged: (newStatus) {
                  orderProvider.updateOrderStatus(order.id, newStatus);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(OrderStatus) onStatusChanged;

  const OrderCard({
    super.key,
    required this.order,
    required this.onStatusChanged,
  });

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.brown;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.processing:
        return Icons.settings;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.returned:
        return Icons.keyboard_return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng #${order.id.substring(order.id.length - 6)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(order.status),
                        size: 16,
                        color: _getStatusColor(order.status),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Order Time and Customer Info
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(order.orderTime),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              '${order.customerName} - ${order.customerPhone}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 12),

            // Order Items
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trang sức đã mua:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ...order.items.take(3).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.jewelry.name} x${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (item.jewelry.material.isNotEmpty)
                                  Text(
                                    'Chất liệu: ${item.jewelry.material}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                if (item.jewelry.size.isNotEmpty)
                                  Text(
                                    'Kích thước: ${item.jewelry.size}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                if (item.engraving != null &&
                                    item.engraving!.isNotEmpty)
                                  Text(
                                    'Khắc chữ: ${item.engraving}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                if (item.giftWrapOption != null)
                                  Text(
                                    'Gói quà: ${item.giftWrapOption}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.pink[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '${NumberFormat('#,###', 'vi_VN').format(item.totalPrice)}đ',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (order.items.length > 3)
                    Text(
                      '... và ${order.items.length - 3} sản phẩm khác',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Delivery Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.deliveryAddress,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

            // Gift Message
            if (order.giftMessage != null && order.giftMessage!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.card_giftcard, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Tin nhắn quà tặng: ${order.giftMessage}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Payment Method
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  order.paymentMethodText,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),

            // Tracking Number
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.qr_code, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Mã vận đơn: ${order.trackingNumber}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Total Amount
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (order.deliveryFee > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phí giao hàng:'),
                        Text(
                            '${NumberFormat('#,###', 'vi_VN').format(order.deliveryFee)}đ'),
                      ],
                    ),
                  if (order.insuranceFee > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phí bảo hiểm:'),
                        Text(
                            '${NumberFormat('#,###', 'vi_VN').format(order.insuranceFee)}đ'),
                      ],
                    ),
                  if (order.discount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Giảm giá:'),
                        Text(
                          '-${NumberFormat('#,###', 'vi_VN').format(order.discount)}đ',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${NumberFormat('#,###', 'vi_VN').format(order.finalAmount)}đ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                if (order.status == OrderStatus.pending) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showCancelDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text(
                        'Hủy đơn',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (order.status == OrderStatus.delivered) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showReturnDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.orange[700]!),
                      ),
                      child: Text(
                        'Trả hàng',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showOrderDetails(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Chi tiết',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hủy đơn hàng'),
          content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                onStatusChanged(OrderStatus.cancelled);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đơn hàng đã được hủy'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Hủy đơn'),
            ),
          ],
        );
      },
    );
  }

  void _showReturnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Trả hàng'),
          content: const Text('Bạn có muốn yêu cầu trả hàng cho đơn hàng này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                onStatusChanged(OrderStatus.returned);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Yêu cầu trả hàng đã được gửi'),
                    backgroundColor: Colors.orange[700],
                  ),
                );
              },
              child: const Text('Trả hàng'),
            ),
          ],
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => OrderDetailsBottomSheet(order: order),
    );
  }
}

class OrderDetailsBottomSheet extends StatelessWidget {
  final Order order;

  const OrderDetailsBottomSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Chi tiết đơn hàng #${order.id.substring(order.id.length - 6)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Order Info
                    _buildInfoSection('Thông tin đơn hàng', [
                      _buildInfoRow(
                        'Thời gian đặt',
                        DateFormat('dd/MM/yyyy HH:mm').format(order.orderTime),
                      ),
                      _buildInfoRow('Trạng thái', order.statusText),
                      _buildInfoRow('Khách hàng', order.customerName),
                      _buildInfoRow('Số điện thoại', order.customerPhone),
                      _buildInfoRow('Email', order.customerEmail),
                      _buildInfoRow('Địa chỉ giao hàng', order.deliveryAddress),
                      _buildInfoRow(
                          'Phương thức thanh toán', order.paymentMethodText),
                      if (order.trackingNumber != null)
                        _buildInfoRow('Mã vận đơn', order.trackingNumber!),
                      if (order.estimatedDeliveryDate != null)
                        _buildInfoRow(
                          'Ngày giao dự kiến',
                          DateFormat('dd/MM/yyyy')
                              .format(order.estimatedDeliveryDate!),
                        ),
                      if (order.giftMessage != null &&
                          order.giftMessage!.isNotEmpty)
                        _buildInfoRow('Tin nhắn quà tặng', order.giftMessage!),
                    ]),
                    const SizedBox(height: 24),

                    // Items
                    _buildInfoSection(
                      'Sản phẩm đã mua',
                      order.items.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.jewelry.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'x${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Thương hiệu: ${item.jewelry.brand}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              Text(
                                'Chất liệu: ${item.jewelry.material}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              if (item.jewelry.gemstone.isNotEmpty)
                                Text(
                                  'Đá quý: ${item.jewelry.gemstone}',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                              Text(
                                'Kích thước: ${item.jewelry.size}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              Text(
                                'Màu sắc: ${item.jewelry.color}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              if (item.engraving != null &&
                                  item.engraving!.isNotEmpty)
                                Text(
                                  'Khắc chữ: ${item.engraving}',
                                  style: TextStyle(
                                      color: Colors.blue[600], fontSize: 13),
                                ),
                              if (item.giftWrapOption != null)
                                Text(
                                  'Gói quà: ${item.giftWrapOption}',
                                  style: TextStyle(
                                      color: Colors.pink[600], fontSize: 13),
                                ),
                              if (item.personalizedMessage != null &&
                                  item.personalizedMessage!.isNotEmpty)
                                Text(
                                  'Tin nhắn cá nhân: ${item.personalizedMessage}',
                                  style: TextStyle(
                                      color: Colors.purple[600], fontSize: 13),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đơn giá: ${NumberFormat('#,###', 'vi_VN').format(item.jewelry.price)}đ',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    'Thành tiền: ${NumberFormat('#,###', 'vi_VN').format(item.totalPrice)}đ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Payment Summary
                    _buildInfoSection('Chi tiết thanh toán', [
                      _buildInfoRow(
                        'Tạm tính',
                        '${NumberFormat('#,###', 'vi_VN').format(order.subtotal)}đ',
                      ),
                      if (order.deliveryFee > 0)
                        _buildInfoRow(
                          'Phí giao hàng',
                          '${NumberFormat('#,###', 'vi_VN').format(order.deliveryFee)}đ',
                        ),
                      if (order.insuranceFee > 0)
                        _buildInfoRow(
                          'Phí bảo hiểm',
                          '${NumberFormat('#,###', 'vi_VN').format(order.insuranceFee)}đ',
                        ),
                      if (order.discount > 0)
                        _buildInfoRow(
                          'Giảm giá',
                          '-${NumberFormat('#,###', 'vi_VN').format(order.discount)}đ',
                        ),
                      const Divider(),
                      _buildInfoRow(
                        'Tổng cộng',
                        '${NumberFormat('#,###', 'vi_VN').format(order.finalAmount)}đ',
                        isTotal: true,
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

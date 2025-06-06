import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/jewelry_provider.dart';
import '../providers/order_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/admin_jewelry_card.dart';
import 'add_jewelry_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý cửa hàng'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Thống kê'),
            Tab(text: 'Trang sức'),
            Tab(text: 'Đơn hàng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StatisticsTab(),
          JewelryManagementTab(),
          OrderManagementTab(),
        ],
      ),
    );
  }
}

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<JewelryProvider, OrderProvider>(
      builder: (context, jewelryProvider, orderProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tổng quan kinh doanh',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Tổng sản phẩm',
                      jewelryProvider.jewelries.length.toString(),
                      Icons.diamond,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Tổng đơn hàng',
                      orderProvider.totalOrdersCount.toString(),
                      Icons.shopping_bag,
                      Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Đơn hoàn thành',
                      orderProvider.completedOrdersCount.toString(),
                      Icons.check_circle,
                      AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Doanh thu',
                      '${orderProvider.totalRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                      Icons.attach_money,
                      AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Orders
              const Text(
                'Đơn hàng gần đây',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: orderProvider.recentOrders.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có đơn hàng nào',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: orderProvider.recentOrders.length,
                        itemBuilder: (context, index) {
                          final order = orderProvider.recentOrders[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  '#${order.id.substring(order.id.length - 2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(order.customerName),
                              subtitle: Text(
                                '${order.items.length} sản phẩm - ${order.finalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.statusText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'OrderStatus.pending':
        return Colors.orange;
      case 'OrderStatus.confirmed':
        return Colors.blue;
      case 'OrderStatus.processing':
        return Colors.purple;
      case 'OrderStatus.shipped':
        return Colors.indigo;
      case 'OrderStatus.delivered':
        return AppTheme.successColor;
      case 'OrderStatus.cancelled':
        return AppTheme.errorColor;
      case 'OrderStatus.returned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class JewelryManagementTab extends StatelessWidget {
  const JewelryManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JewelryProvider>(
        builder: (context, jewelryProvider, child) {
          final jewelries = jewelryProvider.jewelries;

          if (jewelries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.diamond_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có sản phẩm trang sức nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Thêm trang sức đầu tiên của bạn',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jewelries.length,
            itemBuilder: (context, index) {
              final jewelry = jewelries[index];
              return AdminJewelryCard(jewelry: jewelry);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddJewelryScreen()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label:
            const Text('Thêm trang sức', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class OrderManagementTab extends StatelessWidget {
  const OrderManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Chưa có đơn hàng nào',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Các đơn đặt hàng sẽ xuất hiện ở đây',
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
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '#${order.id.substring(order.id.length - 2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  order.customerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.items.length} sản phẩm - ${order.finalAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Đặt lúc: ${_formatDateTime(order.orderTime)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thông tin khách hàng:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                      child: Text(
                                          'Địa chỉ: ${order.deliveryAddress}')),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('SĐT: ${order.customerPhone}'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.email,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('Email: ${order.customerEmail}'),
                                ],
                              ),
                              if (order.giftMessage != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.card_giftcard,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        child: Text(
                                            'Lời nhắn: ${order.giftMessage}')),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Order Items
                        const Text(
                          'Sản phẩm đã đặt:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...order.items
                            .map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.diamond,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.jewelry.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'SL: ${item.quantity} × ${item.jewelry.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${item.totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),

                        const SizedBox(height: 16),

                        // Status Update Buttons
                        const Text(
                          'Cập nhật trạng thái đơn hàng:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildStatusButton(
                              context,
                              'Xác nhận',
                              Icons.check,
                              () => orderProvider.updateOrderStatus(
                                order.id,
                                OrderStatus.confirmed,
                              ),
                              Colors.blue,
                            ),
                            _buildStatusButton(
                              context,
                              'Đang xử lý',
                              Icons.hourglass_empty,
                              () => orderProvider.updateOrderStatus(
                                order.id,
                                OrderStatus.processing,
                              ),
                              Colors.purple,
                            ),
                            _buildStatusButton(
                              context,
                              'Đã gửi hàng',
                              Icons.local_shipping,
                              () => orderProvider.updateOrderStatus(
                                order.id,
                                OrderStatus.shipped,
                              ),
                              Colors.indigo,
                            ),
                            _buildStatusButton(
                              context,
                              'Đã giao hàng',
                              Icons.done_all,
                              () => orderProvider.updateOrderStatus(
                                order.id,
                                OrderStatus.delivered,
                              ),
                              AppTheme.successColor,
                            ),
                            _buildStatusButton(
                              context,
                              'Hủy đơn',
                              Icons.cancel,
                              () => orderProvider.updateOrderStatus(
                                order.id,
                                OrderStatus.cancelled,
                              ),
                              AppTheme.errorColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'OrderStatus.pending':
        return Colors.orange;
      case 'OrderStatus.confirmed':
        return Colors.blue;
      case 'OrderStatus.processing':
        return Colors.purple;
      case 'OrderStatus.shipped':
        return Colors.indigo;
      case 'OrderStatus.delivered':
        return AppTheme.successColor;
      case 'OrderStatus.cancelled':
        return AppTheme.errorColor;
      case 'OrderStatus.returned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

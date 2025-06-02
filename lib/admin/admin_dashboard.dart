import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/jewelry_service.dart';
import '../utils/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị viên'),
        actions: [
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Đăng xuất'),
                      ],
                    ),
                  ),
                ],
            onSelected: (value) {
              if (value == 'logout') {
                Provider.of<AuthService>(context, listen: false).logout();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppTheme.primaryGold,
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Xin chào, ${authService.currentUser?.name ?? "Admin"}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Text(
                              'Chào mừng đến với trang quản trị',
                              style: TextStyle(color: AppTheme.silverGray),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Statistics cards
            Consumer<JewelryService>(
              builder: (context, jewelryService, child) {
                final totalProducts = jewelryService.allJewelry.length;
                final inStockProducts =
                    jewelryService.allJewelry.where((j) => j.inStock).length;
                final outOfStockProducts = totalProducts - inStockProducts;

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Tổng sản phẩm',
                        totalProducts.toString(),
                        Icons.inventory_2,
                        AppTheme.primaryGold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Còn hàng',
                        inStockProducts.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Hết hàng',
                        outOfStockProducts.toString(),
                        Icons.warning,
                        Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            Text('Quản lý', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 16),

            // Management options
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildManagementCard(
                  context,
                  'Quản lý sản phẩm',
                  'Thêm, sửa, xóa sản phẩm',
                  Icons.diamond,
                  AppTheme.primaryGold,
                  () => context.go('/admin/products'),
                ),
                _buildManagementCard(
                  context,
                  'Quản lý đơn hàng',
                  'Xem và xử lý đơn hàng',
                  Icons.shopping_cart,
                  Colors.blue,
                  () => context.go('/admin/orders'),
                ),
                _buildManagementCard(
                  context,
                  'Quản lý người dùng',
                  'Quản lý tài khoản người dùng',
                  Icons.people,
                  Colors.green,
                  () => context.go('/admin/users'),
                ),
                _buildManagementCard(
                  context,
                  'Xem trang chủ',
                  'Xem giao diện người dùng',
                  Icons.home,
                  Colors.orange,
                  () => context.go('/home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.silverGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.silverGray),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

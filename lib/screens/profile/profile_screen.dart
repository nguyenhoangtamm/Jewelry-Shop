import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng chỉnh sửa hồ sơ sẽ được cập nhật'),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          final user = authService.currentUser;

          if (user == null) {
            return const Center(
              child: Text('Không tìm thấy thông tin người dùng'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile avatar
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryGold,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),

                const SizedBox(height: 16),

                // User info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin cá nhân',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Họ tên', user.name),
                        _buildInfoRow('Email', user.email),
                        _buildInfoRow('Số điện thoại', user.phone),
                        _buildInfoRow(
                          'Vai trò',
                          user.isAdmin ? 'Quản trị viên' : 'Người dùng',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Menu options
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: const Text('Đơn hàng của tôi'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng sẽ được cập nhật'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.favorite_outline),
                        title: const Text('Sản phẩm yêu thích'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng sẽ được cập nhật'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: const Text('Địa chỉ giao hàng'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng sẽ được cập nhật'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text('Cài đặt'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng sẽ được cập nhật'),
                            ),
                          );
                        },
                      ),
                      if (authService.isAdmin) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings),
                          title: const Text('Quản trị viên'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => context.go('/admin'),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Logout button
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _showLogoutDialog(context, authService);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.silverGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc muốn đăng xuất?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  authService.logout();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
    );
  }
}

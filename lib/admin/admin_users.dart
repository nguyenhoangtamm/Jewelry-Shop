import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class AdminUsers extends StatelessWidget {
  const AdminUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'), // Quay lại trang admin
        ),
        title: const Text('Quản lý người dùng'),
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          final users = authService.getAllUsers();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        user.isAdmin ? AppTheme.primaryGold : AppTheme.deepBlue,
                    child: Icon(
                      user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      Text(
                        user.phone,
                        style: const TextStyle(color: AppTheme.silverGray),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  user.isAdmin
                                      ? AppTheme.primaryGold
                                      : AppTheme.deepBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.isAdmin ? 'Admin' : 'User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: user.isActive ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.isActive ? 'Hoạt động' : 'Bị khóa',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'toggle_status',
                            child: Row(
                              children: [
                                Icon(
                                  user.isActive
                                      ? Icons.block
                                      : Icons.check_circle,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user.isActive
                                      ? 'Khóa tài khoản'
                                      : 'Kích hoạt',
                                ),
                              ],
                            ),
                          ),
                        ],
                    onSelected: (value) async {
                      if (value == 'toggle_status') {
                        final success = await authService.updateUserStatus(
                          user.id,
                          !user.isActive,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Cập nhật trạng thái thành công'
                                    : 'Có lỗi xảy ra',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

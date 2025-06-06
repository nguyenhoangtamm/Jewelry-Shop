import 'package:flutter/material.dart';
import 'package:jewelry_management_app/screens/message_screen.dart';
import 'package:jewelry_management_app/screens/notification_screen.dart';
import 'package:jewelry_management_app/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/jewelry_provider.dart';
import '../widgets/category_chips.dart';
import '../widgets/jewelry_grid.dart';
import '../widgets/search_bar.dart';
import 'admin_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex;
  const HomeScreen({super.key, this.initialTabIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  List<Widget> _getScreens() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAdmin) {
      return [
        const HomeTab(), // index 0
        const CartScreen(), // index 1
        const OrdersScreen(), // index 2
        const AdminScreen(), // index 3
        const WishlistScreen(), // index 4
        const ProfileScreen(), // index 5
      ];
    } else {
      return [
        const HomeTab(), // index 0
        const CartScreen(), // index 1
        const OrdersScreen(), // index 2
        const WishlistScreen(), // index 3
        const ProfileScreen(), // index 4
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, AuthProvider>(
      builder: (context, cartProvider, authProvider, child) {
        final screens = _getScreens();
        final isAdmin = authProvider.isAdmin;

        return Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartProvider.itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Giỏ hàng',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Đơn hàng',
              ),
              if (isAdmin)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings),
                  label: 'Quản lý',
                ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Yêu thích',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Tài khoản',
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: const Text(
                'CỬA HÀNG TRANG SỨC TTVT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.diamond, size: 28, color: Colors.white),
            ),
          ],
        ),
        actions: [
          // Icon thông báo (chuông)
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Icon tin nhắn
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MessageScreen()),
                  );
                },
              ),
              // Chấm đỏ thông báo
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Consumer<JewelryProvider>(
                  builder: (context, jewelryProvider, child) {
                    return CustomSearchBar(
                      onSearchChanged: jewelryProvider.searchJewelries,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Consumer<JewelryProvider>(
                  builder: (context, jewelryProvider, child) {
                    return CategoryChips(
                      categories: jewelryProvider.categories,
                      selectedCategory: jewelryProvider.selectedCategory,
                      onCategorySelected: jewelryProvider.filterByCategory,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const JewelryGrid(),
            ),
          ),
        ],
      ),
    );
  }
}

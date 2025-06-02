import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/jewelry_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/jewelry_card.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        context.go('/cart');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.diamond, color: Colors.white),
            const SizedBox(width: 8),
            Text(AppConstants.appName),
          ],
        ),
        actions: [
          Consumer<CartService>(
            builder: (context, cartService, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => context.go('/cart'),
                  ),
                  if (cartService.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartService.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Consumer<AuthService>(
            builder: (context, authService, child) {
              return PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text('Hồ sơ'),
                          ],
                        ),
                      ),
                      if (authService.isAdmin)
                        const PopupMenuItem(
                          value: 'admin',
                          child: Row(
                            children: [
                              Icon(Icons.admin_panel_settings),
                              SizedBox(width: 8),
                              Text('Quản trị'),
                            ],
                          ),
                        ),
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
                  switch (value) {
                    case 'profile':
                      context.go('/profile');
                      break;
                    case 'admin':
                      context.go('/admin');
                      break;
                    case 'logout':
                      authService.logout();
                      break;
                  }
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<JewelryService>(
            context,
            listen: false,
          ).refreshJewelry();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarWidget(
                  onSearch: (query) {
                    Provider.of<JewelryService>(
                      context,
                      listen: false,
                    ).setSearchQuery(query);
                  },
                ),
              ),

              // Categories
              Consumer<JewelryService>(
                builder: (context, jewelryService, child) {
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: AppConstants.categories.length,
                      itemBuilder: (context, index) {
                        final category = AppConstants.categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChip(
                            label: category,
                            isSelected:
                                jewelryService.selectedCategory == category,
                            onTap: () => jewelryService.setCategory(category),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Featured products section
              Consumer<JewelryService>(
                builder: (context, jewelryService, child) {
                  if (jewelryService.selectedCategory == 'Tất cả' &&
                      jewelryService.searchQuery.isEmpty) {
                    final featuredProducts =
                        jewelryService.getFeaturedJewelry();

                    if (featuredProducts.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Sản phẩm nổi bật',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: featuredProducts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: SizedBox(
                                    width: 200,
                                    child: JewelryCard(
                                      jewelry: featuredProducts[index],
                                      onTap:
                                          () => context.go(
                                            '/product/${featuredProducts[index].id}',
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Tất cả sản phẩm',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Products grid
              Consumer<JewelryService>(
                builder: (context, jewelryService, child) {
                  if (jewelryService.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final products = jewelryService.jewelry;

                  if (products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppTheme.silverGray,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Không tìm thấy sản phẩm nào',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppTheme.silverGray),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Thử thay đổi từ khóa tìm kiếm hoặc danh mục',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.silverGray),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return JewelryCard(
                          jewelry: products[index],
                          onTap:
                              () =>
                                  context.go('/product/${products[index].id}'),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: _onBottomNavTap,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartService>(
              builder: (context, cartService, child) {
                return Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartService.itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${cartService.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}

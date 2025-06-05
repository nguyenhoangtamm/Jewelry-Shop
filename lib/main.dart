import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewelry_management_app/favorite/favorite_service.dart';
import 'package:jewelry_management_app/screens/favorite/favorite_screen.dart';
import 'package:jewelry_management_app/screens/profile/edit_profile_screen.dart';
import 'package:jewelry_management_app/screens/shipping_address.dart';
import 'package:provider/provider.dart';
import 'admin/admin_dashboard.dart';
import 'admin/admin_orders.dart';
import 'admin/admin_products.dart';
import 'admin/admin_users.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/cart/checkout_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/myorder/my_order.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'services/jewelry_service.dart';
import 'services/order_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const JewelryApp());
}

class JewelryApp extends StatelessWidget {
  const JewelryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => JewelryService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(
            create: (_) => FavoriteService()), // <--- Thêm dòng này
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          return MaterialApp.router(
            title: 'Jewelry Management',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: _createRouter(authService),
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthService authService) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final isLoggedIn = authService.isLoggedIn;
        final isAdmin = authService.isAdmin;
        final path = state.uri.path;

        // Splash screen logic
        if (path == '/splash') {
          return null;
        }

        // Auth required pages
        if (!isLoggedIn &&
            (path.startsWith('/home') ||
                path.startsWith('/cart') ||
                path.startsWith('/profile') ||
                path.startsWith('/admin'))) {
          return '/login';
        }

        // Admin only pages
        if (path.startsWith('/admin') && !isAdmin) {
          return '/home';
        }

        // Redirect logged in users from auth pages
        if (isLoggedIn && (path == '/login' || path == '/register')) {
          return isAdmin ? '/admin' : '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) => ProductDetailScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/screens/profile/edit',
          builder: (context, state) => const EditProfileScreen(),
        ),
        // Route cho MyOrderPage
        GoRoute(
          path: '/my_order',
          builder: (context, state) {
            final orderService = Provider.of<OrderService>(context);
            return MyOrdersPage(orders: orderService.orders);
          },
        ),
        // Admin routes
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboard(),
        ),
        GoRoute(
          path: '/admin/products',
          builder: (context, state) => const AdminProducts(),
        ),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoriteScreen(),
        ),
        GoRoute(
          path: '/shipping_address',
          builder: (context, state) => const ShippingAddressScreen(),
        ),
        GoRoute(
          path: '/admin/orders',
          builder: (context, state) => const AdminOrders(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => const AdminUsers(),
        ),
      ],
    );
  }
}

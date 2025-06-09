import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 5 giây, sau đó kiểm tra trạng thái đăng nhập
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Nền xanh navy
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png', // Logo nền trong suốt
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const SpinKitFadingCircle(
              color: Color.fromARGB(255, 255, 207, 64), // Màu vàng PNJ
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

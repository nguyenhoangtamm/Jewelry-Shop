import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  final Color navy = const Color(0xFF002147); // Xanh navy giống PNJ
  final Color gold = const Color(0xFFFFC107); // Vàng sang trọng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 3;
              });
            },
            children: [
              OnboardingPage(
                imagePath: 'assets/images/jewelry1.png',
                title: 'Chào mừng đến với cửa hàng trang sức TTVT',
                subtitle:
                    'Khám phá bộ sưu tập trang sức sang trọng, tinh tế và thời thượng nhất.',
                navy: navy,
              ),
              OnboardingPage(
                imagePath: 'assets/images/jewelry2.png',
                title: 'Chất lượng đỉnh cao',
                subtitle:
                    'Chúng tôi cam kết mang đến những sản phẩm chất lượng và dịch vụ tận tâm.',
                navy: navy,
              ),
              OnboardingPage(
                imagePath: 'assets/images/jewelry3.png',
                title: 'Trải nghiệm mua sắm dễ dàng',
                subtitle:
                    'Giao diện thân thiện, thanh toán tiện lợi và giao hàng nhanh chóng.',
                navy: navy,
              ),
              OnboardingPage(
                imagePath: 'assets/images/jewelry4.png',
                title: 'Bắt đầu hành trình toả sáng cùng TTVT ',
                subtitle: '',
                showButtons: true,
                navy: navy,
                gold: gold,
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Text(
                'Bỏ qua',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: gold,
                    dotColor: Colors.white38,
                  ),
                ),
                onLastPage
                    ? const SizedBox()
                    : ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Tiếp'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool showButtons;
  final Color navy;
  final Color? gold;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.navy,
    this.gold,
    this.showButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: navy,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 320), // Hình to hơn
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[300]),
          ),
          if (showButtons && gold != null) ...[
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Đăng nhập'),
            ),
          ]
        ],
      ),
    );
  }
}

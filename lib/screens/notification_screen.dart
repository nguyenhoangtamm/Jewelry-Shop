import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> notifications = [
    '🎉 Khuyến mãi 20% cho đơn hàng trên 10 triệu!',
    '💎 Chương trình tích điểm đổi quà bắt đầu từ 10/6.',
    '🎁 Miễn phí giao hàng toàn quốc trong tháng 6.',
    '🔒 Đảm bảo hoàn tiền 100% nếu sản phẩm lỗi.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.notifications_active, color: Colors.orange),
          title: Text(notifications[index]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> notifications = [
    '🎉 Khuyến mãi 20% cho đơn hàng trên 10 triệu!',
    '💎 Chương trình tích điểm đổi quà bắt đầu từ 10/6.',
    '🎁 Miễn phí giao hàng toàn quốc trong tháng 6.',
    '🔒 Đảm bảo hoàn tiền 100% nếu sản phẩm lỗi.',
    '🆕 Bộ sưu tập trang sức mới vừa ra mắt!',
    '📦 Theo dõi đơn hàng dễ dàng trong ứng dụng.',
    '⭐ Đánh giá sản phẩm để nhận mã giảm giá 15%.',
    '📣 Thông báo lịch bảo trì hệ thống ngày 15/6.',
    '🎊 Giảm giá 10% cho khách hàng lần đầu mua sắm.',
    '💬 Hỗ trợ trực tuyến 24/7 đã sẵn sàng phục vụ bạn.',
    '🎈 Sinh nhật Shopee – quà tặng hấp dẫn mỗi ngày!',
    '🏆 Tham gia minigame nhận ngay ưu đãi độc quyền!',
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

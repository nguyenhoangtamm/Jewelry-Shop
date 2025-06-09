import 'package:flutter/material.dart';
import 'package:jewelry_management_app/screens/chat_detail_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {
        'avatar':
            'https://tse3.mm.bing.net/th?id=OIP.IlrrnM9UiiG5HFqcixNYoAHaHa&pid=Api&P=0&h=220',
        'shopName': 'TLEE JEWELRY Official...',
        'lastMessage': 'Dạ việc tắm, có thể kẹt nước bên trong sản ph...',
        'date': '22/05',
        'isMall': true,
        'unread': false,
      },
      {
        'avatar':
            'https://tse1.mm.bing.net/th?id=OIP.pJsYg05apx2fO9no51omCAHaHW&pid=Api&P=0&h=220',
        'shopName': 'ZGO FASHION',
        'lastMessage': 'dạ rồi ạ c',
        'date': '02/05',
        'isMall': true,
        'unread': false,
      },
      {
        'avatar':
            'https://tse3.mm.bing.net/th?id=OIP.V3xE8XayVw4pdoRBHAoHEgHaHw&pid=Api&P=0&h=220',
        'shopName': 'Gà Lót Chuột',
        'lastMessage': 'Đơn hàng bạn đã giao tới r...',
        'date': '02/05',
        'isLive': true,
        'unread': false,
      },
      {
        'avatar':
            'https://tse2.mm.bing.net/th?id=OIP.RR8HM_MwUsXs2mczEJaZUwHaHa&pid=Api&P=0&h=220',
        'shopName': 'Thiên Di',

        'lastMessage': 'Bạn cho shop xin size tay...',
        'date': '29/04',
        'unread': true,
        'unreadCount': 2,
      },
    {
    'avatar':
    'https://tse2.mm.bing.net/th?id=OIP.zclkNfJMLe2IejNMYcG-WwHaHa&pid=Api&P=0&h=220',
    'shopName': 'Trang Sức Kim Hòa',
    'lastMessage': 'Chị ơi mình giao trong hôm nay được không ạ?',
    'date': '28/04',
    'unread': false,
    },
    {
    'avatar':
    'https://tse4.mm.bing.net/th?id=OIP.539_Ea8RUqOg9BfqH84WuAHaHa&pid=Api&P=0&h=220',
    'shopName': 'Bạc Uy Tín 1989',
    'lastMessage': 'Cảm ơn bạn đã đánh giá đơn hàng hôm qua nha',
    'date': '27/04',
    'isMall': true,
    'unread': false,
    },
    {
    'avatar':
    'https://tse1.mm.bing.net/th?id=OIP.sSnwYqridLyvENGSJEXZtAHaHa&pid=Api&P=0&h=220',
    'shopName': 'Trang Sức Thanh Tâm',
    'lastMessage': 'Shop còn mẫu nhẫn hôm trước không vậy ạ?',
    'date': '25/04',
    'unread': true,
    'unreadCount': 1,
    },
    {
    'avatar':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjvCNr8NEvjd0C7v3UaFaMvm1_5fWNk3g-Eg&s',
    'shopName': 'Du Hí',
    'lastMessage': 'Bạn cho shop xin size tay...',
    'date': '29/04',
    'unread': true,
    'unreadCount': 2,
    },
    {
    'avatar':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQluYfe4FdrCSsj-Y5lHvmMhCSWwRTleJZU8Q&s',
    'shopName': 'Ngọc Ánh Jewelry',
    'lastMessage': 'Mình mới cập nhật mẫu mới bạn xem nhé!',
    'date': '30/04',
    'unread': true,
    'unreadCount': 3,
    },
    {
    'avatar':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn3vx-r_O-TN6ZGz8dr9XhrjmzEHoLiaUIzg&s',
    'shopName': 'Kim Cương T&T',
    'lastMessage': 'Bạn cần đặt theo kích thước riêng không?',
    'date': '01/05',
    'unread': false,
    },
    {
    'avatar':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTejbZkSKzjSvrZW4i9fBNkbWWl7-FkpbtQ9A&s',
    'shopName': 'Vàng Bạc Lộc Phát',
    'lastMessage': 'Shop có ưu đãi hôm nay bạn tranh thủ nha!',
    'date': '02/05',
    'unread': true,
    'unreadCount': 1,
    },
    {
    'avatar':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTARkbs4649FbBgsVL78hCMC9Ax-6QnLYfNrg&s',
    'shopName': 'Jewelry Store 88',
    'lastMessage': 'Mình đã ship đơn rồi bạn nhé!',
    'date': '03/05',
    'unread': false,
    },
    {
    'avatar':
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSX55wAQz9GQJc4YNbycZ5EGUKnHRzOhR2Dg&s',
    'shopName': 'PNJ Mini',
    'lastMessage': 'Bạn có thể cho mình feedback không ạ?',
    'date': '04/05',
    'unread': true,
    'unreadCount': 1,
    }
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.separated(
        itemCount: messages.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final msg = messages[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(msg['avatar'] as String),
                ),
                if (msg['isMall'] == true)
                  Positioned(
                    bottom: -2,
                    child: Image.asset('assets/images/shopee_mall.png',
                        height: 16),
                  ),
                if (msg['isLive'] == true)
                  Positioned(
                    bottom: -2,
                    child: Image.asset('assets/images/shopee_mall.png',
                        height: 16),
                  ),
              ],
            ),
            title: Text(
              msg['shopName'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              msg['lastMessage'] as String,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(msg['date'] as String,
                    style: const TextStyle(fontSize: 12)),
                if (msg['unread'] == true)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${msg['unreadCount']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatDetailScreen(shopName: msg['shopName'] as String),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

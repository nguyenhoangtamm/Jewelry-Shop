import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String shopName;

  const ChatDetailScreen({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {'isMe': false, 'text': 'Chào bạn, shop có thể giúp gì ạ?'},
      {'isMe': true, 'text': 'Cho mình hỏi sản phẩm này còn không ạ?'},
      {'isMe': false, 'text': 'Dạ còn bạn nhé!'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(shopName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: (msg['isMe'] as bool)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: msg['isMe'] as bool
                          ? Colors.orange[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] as String),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: () {
                    // Xử lý gửi tin nhắn
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

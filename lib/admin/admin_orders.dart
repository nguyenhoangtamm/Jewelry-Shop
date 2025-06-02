import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/orders'));
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Lỗi lấy đơn hàng: $e');
    }
  }

  Future<void> updateStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/orders/$id/status?status=$status'),
      );
      if (response.statusCode == 200) {
        fetchOrders();
      }
    } catch (e) {
      print('Lỗi cập nhật trạng thái: $e');
    }
  }

  Widget buildOrderCard(Map order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: Colors.grey),
        title: Text('${order["customerName"]} - ${order["phone"]}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Địa chỉ: ${order["address"]}'),
            Text('Tổng tiền: ${order["totalAmount"]}đ'),
            Text('Trạng thái: ${order["status"]}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => updateStatus(order["id"], value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: "DA_DUYET", child: Text("Duyệt")),
            const PopupMenuItem(value: "DANG_GIAO", child: Text("Đang giao")),
            const PopupMenuItem(value: "DA_GIAO", child: Text("Đã giao")),
            const PopupMenuItem(value: "DA_HUY", child: Text("Hủy")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý đơn hàng')),
      body: RefreshIndicator(
        onRefresh: fetchOrders,
        child: ListView(
          children: orders.map<Widget>((o) => buildOrderCard(o)).toList(),
        ),
      ),
    );
  }
}

import 'package:jewelry_management_app/database/database_helper.dart';
import 'package:jewelry_management_app/models/order_details.dart';
import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/jewelry.dart';

class OrderService extends ChangeNotifier {
  List<Order> orders = [];
  OrderService() {
    getDemoOrders();
  }
  final orderDbHelper = GenericDbHelper<Order>('orders', Order.fromJson);
  final jewelryDbHelper = GenericDbHelper<Jewelry>('jewelries', Jewelry.fromJson);
  final orderDetailsDbHelper =
      GenericDbHelper<OrderDetail>('order_details', OrderDetail.fromJson);

  Future<void> getDemoOrders() async {
    final listOrder = await orderDbHelper.getAll();
    for (var order in listOrder) {
      final orderDetails =
          await orderDetailsDbHelper.getByForeignKey('orderId', order.id);
      order.items = await Future.wait(orderDetails.map((detail) async {
        final jewelry = await jewelryDbHelper.getById(detail.jewelryId);
        return CartItem(
          id: detail.id,
          jewelry: jewelry!,
          quantity: detail.quantity,
          addedAt: detail.addedAt ?? DateTime.now(),
        );
      }));
    }
    orders = listOrder;
    notifyListeners();
  }
}

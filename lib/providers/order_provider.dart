import 'package:flutter/material.dart';
import 'package:jewelry_management_app/database/database_helper.dart';
import 'package:jewelry_management_app/models/jewelry.dart';
import 'package:jewelry_management_app/models/order_details.dart';
import 'package:jewelry_management_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  String? userId = '';
  List<Order> get orders => _orders;
  final jewelryDbHelper =
      GenericDbHelper<Jewelry>('jewelries', Jewelry.fromJson);
  List<Order> get recentOrders => _orders.take(5).toList();
  final orderDbHelper = GenericDbHelper<Order>('orders', Order.fromJson);
  final orderDetailsDbHelper =
      GenericDbHelper<OrderDetail>('order_details', OrderDetail.fromJson);
  Future<void> initializeOrders(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userId = authProvider.currentUser?.id;

    if (userId == null) {
      _orders.clear();
      notifyListeners();
      return;
    }

    final ordersFromDb = await orderDbHelper.getAll();

    final filteredOrders =
        ordersFromDb.where((order) => order.userId == userId).toList();
    final orderDetails = await orderDetailsDbHelper.getAll();
    for (var order in filteredOrders) {
      final details =
          orderDetails.where((detail) => detail.orderId == order.id).toList();

      // Lấy jewelry bất đồng bộ
      order.items = await Future.wait(details.map((detail) async {
        final jewelry = await jewelryDbHelper.getById(detail.jewelryId);
        return CartItem(
          id: detail.id,
          jewelry: jewelry!,
          quantity: detail.quantity,
          giftWrapOption: detail.giftWrapOption,
          engraving: detail.engraving,
          personalizedMessage: detail.personalizedMessage,
        );
      }));
    }
    _orders.clear();
    _orders.addAll(filteredOrders);
    notifyListeners();
  }

  Future<void> placeOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String deliveryAddress,
    String? giftMessage,
    double deliveryFee = 30000,
    double discount = 0,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    bool isGift = false,
    double insuranceFee = 0,
  }) async {
    final totalValue = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final calculatedInsuranceFee =
        insuranceFee > 0 ? insuranceFee : (totalValue * 0.005);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId ?? '',
      items: List.from(items),
      totalAmount: totalValue,
      status: OrderStatus.pending,
      orderTime: DateTime.now(),
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      deliveryAddress: deliveryAddress,
      giftMessage: giftMessage,
      deliveryFee: deliveryFee,
      discount: discount,
      paymentMethod: paymentMethod,
      trackingNumber: null,
      estimatedDeliveryDate: _calculateEstimatedDeliveryDate(),
      isGift: isGift,
      insuranceFee: calculatedInsuranceFee,
    );

    _orders.insert(0, order);
    await orderDbHelper.insert(order);
    // Insert từng orderDetail vào orderDetailsDbHelper
    for (final item in items) {
      final detail = OrderDetail(
        id: DateTime.now().microsecondsSinceEpoch.toString() + item.jewelry.id,
        orderId: order.id,
        jewelryId: item.jewelry.id,
        quantity: item.quantity,
        giftWrapOption: item.giftWrapOption,
        engraving: item.engraving,
        personalizedMessage: item.personalizedMessage,
      );
      await orderDetailsDbHelper.insert(detail);
    }
    notifyListeners();
  }

  DateTime _calculateEstimatedDeliveryDate() {
    final now = DateTime.now();
    return now.add(const Duration(days: 5));
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final currentOrder = _orders[index];
      final updatedOrder = Order(
        id: currentOrder.id,
        userId: currentOrder.userId,
        items: currentOrder.items,
        totalAmount: currentOrder.totalAmount,
        status: newStatus,
        orderTime: currentOrder.orderTime,
        customerName: currentOrder.customerName,
        customerPhone: currentOrder.customerPhone,
        customerEmail: currentOrder.customerEmail,
        deliveryAddress: currentOrder.deliveryAddress,
        giftMessage: currentOrder.giftMessage,
        deliveryFee: currentOrder.deliveryFee,
        discount: currentOrder.discount,
        paymentMethod: currentOrder.paymentMethod,
        trackingNumber: currentOrder.trackingNumber,
        estimatedDeliveryDate: currentOrder.estimatedDeliveryDate,
        isGift: currentOrder.isGift,
        insuranceFee: currentOrder.insuranceFee,
      );
      _orders[index] = updatedOrder;
      await orderDbHelper.update(updatedOrder);
      notifyListeners();
    }
  }

  Future<void> updateTrackingNumber(
      String orderId, String trackingNumber) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final currentOrder = _orders[index];
      final updatedOrder = Order(
        id: currentOrder.id,
        userId: currentOrder.userId,
        items: currentOrder.items,
        totalAmount: currentOrder.totalAmount,
        status: currentOrder.status,
        orderTime: currentOrder.orderTime,
        customerName: currentOrder.customerName,
        customerPhone: currentOrder.customerPhone,
        customerEmail: currentOrder.customerEmail,
        deliveryAddress: currentOrder.deliveryAddress,
        giftMessage: currentOrder.giftMessage,
        deliveryFee: currentOrder.deliveryFee,
        discount: currentOrder.discount,
        paymentMethod: currentOrder.paymentMethod,
        trackingNumber: trackingNumber,
        estimatedDeliveryDate: currentOrder.estimatedDeliveryDate,
        isGift: currentOrder.isGift,
        insuranceFee: currentOrder.insuranceFee,
      );
      _orders[index] = updatedOrder;
      await orderDbHelper.update(updatedOrder);
      notifyListeners();
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  Future<void> returnOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.returned);
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  List<Order> getOrdersByPaymentMethod(PaymentMethod paymentMethod) {
    return _orders
        .where((order) => order.paymentMethod == paymentMethod)
        .toList();
  }

  List<Order> getGiftOrders() {
    return _orders.where((order) => order.isGift).toList();
  }

  List<Order> getOrdersWithCertifiedItems() {
    return _orders
        .where((order) => order.items.any((item) => item.jewelry.isCertified))
        .toList();
  }

  double get totalRevenue {
    return _orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.finalAmount);
  }

  double get monthlyRevenue {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return _orders
        .where((order) =>
            order.status == OrderStatus.delivered &&
            order.orderTime.isAfter(startOfMonth))
        .fold(0.0, (sum, order) => sum + order.finalAmount);
  }

  int get totalOrdersCount => _orders.length;

  int get completedOrdersCount =>
      _orders.where((order) => order.status == OrderStatus.delivered).length;

  int get pendingOrdersCount =>
      _orders.where((order) => order.status == OrderStatus.pending).length;

  int get shippedOrdersCount =>
      _orders.where((order) => order.status == OrderStatus.shipped).length;

  double get averageOrderValue {
    if (_orders.isEmpty) return 0.0;
    return totalRevenue / completedOrdersCount;
  }

  Map<PaymentMethod, int> get paymentMethodStats {
    final stats = <PaymentMethod, int>{};
    for (final method in PaymentMethod.values) {
      stats[method] =
          _orders.where((order) => order.paymentMethod == method).length;
    }
    return stats;
  }
}

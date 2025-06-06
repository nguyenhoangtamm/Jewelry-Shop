import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  List<Order> get recentOrders => _orders.take(5).toList();

  void placeOrder({
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
  }) {
    final totalValue = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final calculatedInsuranceFee =
        insuranceFee > 0 ? insuranceFee : (totalValue * 0.005);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(items),
      totalAmount: totalValue,
      orderTime: DateTime.now(),
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      deliveryAddress: deliveryAddress,
      giftMessage: giftMessage,
      deliveryFee: deliveryFee,
      discount: discount,
      paymentMethod: paymentMethod,
      isGift: isGift,
      insuranceFee: calculatedInsuranceFee,
      estimatedDeliveryDate: _calculateEstimatedDeliveryDate(),
    );

    _orders.insert(0, order);
    notifyListeners();
  }

  DateTime _calculateEstimatedDeliveryDate() {
    final now = DateTime.now();
    return now.add(const Duration(days: 5));
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final currentOrder = _orders[index];
      final updatedOrder = Order(
        id: currentOrder.id,
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
      notifyListeners();
    }
  }

  void updateTrackingNumber(String orderId, String trackingNumber) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final currentOrder = _orders[index];
      final updatedOrder = Order(
        id: currentOrder.id,
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
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  void returnOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.returned);
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

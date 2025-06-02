import 'cart_item.dart';
import 'user.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipping,
  delivered,
  cancelled,
  refunded,
}

class Order {
  final String id;
  final String userId;
  final User? user;
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final String shippingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    this.user,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.shippingAddress,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.trackingNumber,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.processing:
        return 'Đang xử lý';
      case OrderStatus.shipping:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Đã giao hàng';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      case OrderStatus.refunded:
        return 'Đã hoàn tiền';
    }
  }

  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;
  bool get isCompleted => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingAddress: json['shippingAddress'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user?.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'status': status.toString().split('.').last,
      'shippingAddress': shippingAddress,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'trackingNumber': trackingNumber,
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    User? user,
    List<CartItem>? items,
    double? subtotal,
    double? shippingFee,
    double? discount,
    double? total,
    OrderStatus? status,
    String? shippingAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? trackingNumber,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }
}

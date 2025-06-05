import 'package:jewelry_management_app/models/base_model.dart';
import 'package:jewelry_management_app/models/cart_item.dart';
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

class Order extends BaseModel {
  String userId;
  User? user;
  List<CartItem> items = [];
  double subtotal;
  double shippingFee;
  double discount;
  double total;
  OrderStatus status;
  String shippingAddress;
  String? notes;
  String? trackingNumber;

  Order({
    required super.id,
    required this.userId,
    this.user,
    this.items = const [],
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.shippingAddress,
    this.notes,
    super.createdAt,
    super.updatedAt,
    this.trackingNumber,
    super.isDeleted = false,
  });

  @override
  String get tableName => 'orders';

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
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
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
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      trackingNumber: json['trackingNumber'],
      isDeleted: (json['isDeleted'] == 1 || json['isDeleted'] == true),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user?.toJson(),
      // Không lưu items ở đây nữa
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'status': status.toString().split('.').last,
      'shippingAddress': shippingAddress,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'isDeleted': isDeleted,
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    User? user,
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
    bool? isDeleted,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
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
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
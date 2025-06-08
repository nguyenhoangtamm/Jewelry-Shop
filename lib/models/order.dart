import 'package:jewelry_management_app/models/base_model.dart';

import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

enum PaymentMethod {
  cash,
  creditCard,
  bankTransfer,
  eWallet,
  installment,
}

class Order extends BaseModel {
  String userId;
  List<CartItem> items = [];
  double totalAmount;
  OrderStatus status;
  DateTime orderTime;
  String customerName;
  String customerPhone;
  String customerEmail;
  String deliveryAddress;
  String? giftMessage;
  double deliveryFee;
  double discount;
  PaymentMethod paymentMethod;
  String? trackingNumber;
  DateTime? estimatedDeliveryDate;
  bool isGift;
  double insuranceFee;

  Order({
    required super.id,
    required this.userId,
    this.items = const [],
    required this.totalAmount,
    this.status = OrderStatus.pending,
    required this.orderTime,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.deliveryAddress,
    this.giftMessage,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    this.paymentMethod = PaymentMethod.cash,
    this.trackingNumber,
    this.estimatedDeliveryDate,
    this.isGift = false,
    this.insuranceFee = 0.0,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });
  @override
  String get tableName => 'orders';
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get finalAmount => subtotal + deliveryFee + insuranceFee - discount;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.processing:
        return 'Đang xử lý';
      case OrderStatus.shipped:
        return 'Đã giao vận';
      case OrderStatus.delivered:
        return 'Đã giao hàng';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      case OrderStatus.returned:
        return 'Đã trả hàng';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'Thanh toán khi nhận hàng';
      case PaymentMethod.creditCard:
        return 'Thẻ tín dụng';
      case PaymentMethod.bankTransfer:
        return 'Chuyển khoản ngân hàng';
      case PaymentMethod.eWallet:
        return 'Ví điện tử';
      case PaymentMethod.installment:
        return 'Trả góp';
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status.index,
      'orderTime': orderTime.toIso8601String(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'deliveryAddress': deliveryAddress,
      'giftMessage': giftMessage,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'paymentMethod': paymentMethod.index,
      'trackingNumber': trackingNumber,
      'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
      'isGift': isGift ? 1 : 0, // convert bool to int
      'insuranceFee': insuranceFee,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0, // convert bool to int
    };
  }

  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      totalAmount: json['totalAmount'].toDouble(),
      status: OrderStatus.values[json['status']],
      orderTime: DateTime.parse(json['orderTime']),
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      deliveryAddress: json['deliveryAddress'],
      giftMessage: json['giftMessage'],
      deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
      discount: json['discount']?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethod.values[json['paymentMethod'] ?? 0],
      trackingNumber: json['trackingNumber'],
      estimatedDeliveryDate: json['estimatedDeliveryDate'] != null
          ? DateTime.parse(json['estimatedDeliveryDate'])
          : null,
      isGift: json['isGift'] == 1,
      insuranceFee: json['insuranceFee']?.toDouble() ?? 0.0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] == 1,
    );
  }
  Order copyWith({
    String? id,
    String? userId,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderTime,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? deliveryAddress,
    String? giftMessage,
    double? deliveryFee,
    double? discount,
    PaymentMethod? paymentMethod,
    String? trackingNumber,
    DateTime? estimatedDeliveryDate,
    bool? isGift,
    double? insuranceFee,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderTime: orderTime ?? this.orderTime,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      giftMessage: giftMessage ?? this.giftMessage,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDeliveryDate:
          estimatedDeliveryDate ?? this.estimatedDeliveryDate,
      isGift: isGift ?? this.isGift,
      insuranceFee: insuranceFee ?? this.insuranceFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

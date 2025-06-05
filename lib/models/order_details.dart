import 'package:jewelry_management_app/models/base_model.dart';

class OrderDetail extends BaseModel {
  final String orderId;    // Khóa ngoại đến đơn hàng
  final String jewelryId;  // Khóa ngoại đến sản phẩm
  final int quantity;
  final double price;
  final DateTime? addedAt;

  OrderDetail({
    required super.id,
    required this.orderId,
    required this.jewelryId,
    required this.quantity,
    required this.price,
    this.addedAt,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  @override
  String get tableName => 'order_details';

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'].toString(),
      orderId: json['orderId'].toString(),
      jewelryId: json['jewelryId'].toString(),
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      addedAt: json['addedAt'] != null ? DateTime.parse(json['addedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: (json['isDeleted'] == 1 || json['isDeleted'] == true),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'jewelryId': jewelryId,
      'quantity': quantity,
      'price': price,
      'addedAt': addedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  OrderDetail copyWith({
    String? id,
    String? orderId,
    String? jewelryId,
    int? quantity,
    double? price,
    DateTime? addedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return OrderDetail(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      jewelryId: jewelryId ?? this.jewelryId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      addedAt: addedAt ?? this.addedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
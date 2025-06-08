import 'package:jewelry_management_app/models/base_model.dart';

class OrderDetail extends BaseModel {
  final String orderId;
  final String jewelryId;
  int quantity;
  final String? giftWrapOption;
  final String? engraving;
  final String? personalizedMessage;

  OrderDetail({
    required super.id,
    required this.orderId,
    required this.jewelryId,
    this.quantity = 1,
    this.giftWrapOption,
    this.engraving,
    this.personalizedMessage,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  @override
  String get tableName => 'order_details';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'jewelryId': jewelryId,
      'quantity': quantity,
      'giftWrapOption': giftWrapOption,
      'engraving': engraving,
      'personalizedMessage': personalizedMessage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted? 1 : 0,
    };
  }

  static OrderDetail fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['orderId'],
      jewelryId: json['jewelryId'],
      quantity: json['quantity'] ?? 1,
      giftWrapOption: json['giftWrapOption'],
      engraving: json['engraving'],
      personalizedMessage: json['personalizedMessage'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] == 1,
    );
  }

  OrderDetail copyWith({
    String? id,
    String? orderId,
    String? jewelryId,
    int? quantity,
    double? price,
    DateTime? addedAt,
    String? giftWrapOption,
    String? engraving,
    String? personalizedMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return OrderDetail(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      jewelryId: jewelryId ?? this.jewelryId,
      quantity: quantity ?? this.quantity,
      giftWrapOption: giftWrapOption ?? this.giftWrapOption,
      engraving: engraving ?? this.engraving,
      personalizedMessage: personalizedMessage ?? this.personalizedMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

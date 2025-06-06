import 'package:jewelry_management_app/models/base_model.dart';

import 'jewelry.dart';

class CartItem extends BaseModel {
  final Jewelry jewelry;
  int quantity;
  final String? giftWrapOption;
  final String? engraving;
  final String? personalizedMessage;

  CartItem({
    required super.id,
    required this.jewelry,
    this.quantity = 1,
    this.giftWrapOption,
    this.engraving,
    this.personalizedMessage,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });
  @override
  String get tableName => 'cart_items';
  double get totalPrice => jewelry.price * quantity;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jewelry': jewelry.toJson(),
      'quantity': quantity,
      'giftWrapOption': giftWrapOption,
      'engraving': engraving,
      'personalizedMessage': personalizedMessage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      jewelry: Jewelry.fromJson(json['jewelry']),
      quantity: json['quantity'],
      giftWrapOption: json['giftWrapOption'],
      engraving: json['engraving'],
      personalizedMessage: json['personalizedMessage'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  CartItem copyWith({
    String? id,
    Jewelry? jewelry,
    int? quantity,
    String? giftWrapOption,
    String? engraving,
    String? personalizedMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return CartItem(
      id: id ?? this.id,
      jewelry: jewelry ?? this.jewelry,
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

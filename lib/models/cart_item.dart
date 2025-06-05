import 'base_model.dart';
import 'jewelry.dart';

class CartItem extends BaseModel {
  final Jewelry jewelry;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required super.id,
    required this.jewelry,
    required this.quantity,
    required this.addedAt,
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
      'addedAt': addedAt.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      jewelry: Jewelry.fromJson(json['jewelry']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isDeleted: (json['isDeleted'] == 1 || json['isDeleted'] == true),
    );
  }

  CartItem copyWith({
    String? id,
    Jewelry? jewelry,
    int? quantity,
    DateTime? addedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return CartItem(
      id: id ?? this.id,
      jewelry: jewelry ?? this.jewelry,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

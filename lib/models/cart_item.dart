import 'jewelry.dart';

class CartItem {
  final String id;
  final Jewelry jewelry;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.jewelry,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => jewelry.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      jewelry: Jewelry.fromJson(json['jewelry']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jewelry': jewelry.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    String? id,
    Jewelry? jewelry,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      jewelry: jewelry ?? this.jewelry,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/jewelry.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalWeight => _items.fold(
      0.0, (sum, item) => sum + (item.jewelry.weight * item.quantity));

  void addToCart(
    Jewelry jewelry, {
    int quantity = 1,
    String? giftWrapOption,
    String? engraving,
    String? personalizedMessage,
  }) {
    final existingIndex =
        _items.indexWhere((item) => item.jewelry.id == jewelry.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          jewelry: jewelry,
          quantity: quantity,
          giftWrapOption: giftWrapOption,
          engraving: engraving,
          personalizedMessage: personalizedMessage,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void updateGiftOptions(
    String cartItemId, {
    String? giftWrapOption,
    String? engraving,
    String? personalizedMessage,
  }) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        giftWrapOption: giftWrapOption,
        engraving: engraving,
        personalizedMessage: personalizedMessage,
      );
      notifyListeners();
    }
  }

  void increaseQuantity(String cartItemId) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      // Kiểm tra tồn kho trước khi tăng
      if (_items[index].quantity < _items[index].jewelry.stockQuantity) {
        _items[index].quantity++;
        notifyListeners();
      }
    }
  }

  void decreaseQuantity(String cartItemId) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        removeFromCart(cartItemId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String jewelryId) {
    return _items.any((item) => item.jewelry.id == jewelryId);
  }

  int getQuantityInCart(String jewelryId) {
    try {
      final item = _items.firstWhere((item) => item.jewelry.id == jewelryId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  // Tính phí gói quà
  double get giftWrapFee {
    return _items.where((item) => item.giftWrapOption != null).length * 10000.0;
  }

  // Tính phí khắc chữ
  double get engravingFee {
    return _items
            .where(
                (item) => item.engraving != null && item.engraving!.isNotEmpty)
            .length *
        50000.0;
  }

  // Tổng tiền bao gồm phí dịch vụ
  double get totalWithServices => totalAmount + giftWrapFee + engravingFee;

  // Kiểm tra có sản phẩm nào cần chứng nhận không
  bool get hasCertifiedItems {
    return _items.any((item) => item.jewelry.isCertified);
  }

  // Danh sách các trang sức đã chứng nhận
  List<Jewelry> get certifiedJewelries {
    return _items
        .where((item) => item.jewelry.isCertified)
        .map((item) => item.jewelry)
        .toList();
  }

  // Kiểm tra tồn kho
  bool isStockAvailable(String jewelryId, int requestedQuantity) {
    try {
      final item = _items.firstWhere((item) => item.jewelry.id == jewelryId);
      return item.jewelry.stockQuantity >= requestedQuantity;
    } catch (e) {
      return false;
    }
  }
}

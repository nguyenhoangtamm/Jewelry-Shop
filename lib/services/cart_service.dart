import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/jewelry.dart';
import '../models/order.dart';

class CartService extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get shippingFee =>
      subtotal > 1000000 ? 0 : 50000; // Free shipping over 1M VND
  double get total => subtotal + shippingFee;

  CartService() {
    _loadCartFromStorage();
  }

  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart_items');
      if (cartData != null) {
        final List<dynamic> jsonList = json.decode(cartData);
        _items = jsonList.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart from storage: $e');
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('cart_items', cartData);
    } catch (e) {
      debugPrint('Error saving cart to storage: $e');
    }
  }

  Future<bool> addToCart(Jewelry jewelry, {int quantity = 1}) async {
    try {
      // Check if item already exists in cart
      final existingIndex = _items.indexWhere(
        (item) => item.jewelry.id == jewelry.id,
      );

      if (existingIndex != -1) {
        // Update quantity of existing item
        final existingItem = _items[existingIndex];
        final newQuantity = existingItem.quantity + quantity;

        // Check stock availability
        if (newQuantity > jewelry.stock) {
          return false; // Not enough stock
        }

        _items[existingIndex] = existingItem.copyWith(quantity: newQuantity);
      } else {
        // Add new item to cart
        if (quantity > jewelry.stock) {
          return false; // Not enough stock
        }

        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          jewelry: jewelry,
          quantity: quantity,
          addedAt: DateTime.now(),
        );

        _items.add(cartItem);
      }

      await _saveCartToStorage();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateQuantity(String itemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        return removeFromCart(itemId);
      }

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final item = _items[index];

        // Check stock availability
        if (newQuantity > item.jewelry.stock) {
          return false;
        }

        _items[index] = item.copyWith(quantity: newQuantity);
        await _saveCartToStorage();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromCart(String itemId) async {
    try {
      _items.removeWhere((item) => item.id == itemId);
      await _saveCartToStorage();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _saveCartToStorage();
    notifyListeners();
  }

  int getItemQuantity(String jewelryId) {
    try {
      final item = _items.firstWhere((item) => item.jewelry.id == jewelryId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  bool isInCart(String jewelryId) {
    return _items.any((item) => item.jewelry.id == jewelryId);
  }

  Future<Order?> createOrder({
    required String userId,
    required String shippingAddress,
    String? notes,
    double discount = 0,
  }) async {
    if (_items.isEmpty) return null;

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        subtotal: subtotal,
        shippingFee: shippingFee,
        discount: discount,
        total: total - discount,
        status: OrderStatus.pending,
        shippingAddress: shippingAddress,
        notes: notes,
        createdAt: DateTime.now(),
      );

      // Clear cart after successful order
      await clearCart();

      _isLoading = false;
      notifyListeners();

      return order;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Calculate shipping fee based on location and weight
  double calculateShippingFee(String address) {
    // Simple shipping calculation
    if (subtotal >= 1000000) return 0; // Free shipping

    // Based on address (mock calculation)
    if (address.toLowerCase().contains('hà nội') ||
        address.toLowerCase().contains('hồ chí minh')) {
      return 30000;
    } else {
      return 50000;
    }
  }

  // Apply discount/coupon
  double applyDiscount(String couponCode) {
    // Mock discount codes
    switch (couponCode.toUpperCase()) {
      case 'WELCOME10':
        return subtotal * 0.1; // 10% discount
      case 'NEWUSER':
        return 100000; // Fixed 100k discount
      case 'VIP20':
        return subtotal * 0.2; // 20% discount
      default:
        return 0;
    }
  }
}

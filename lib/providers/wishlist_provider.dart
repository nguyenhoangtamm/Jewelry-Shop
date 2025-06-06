import 'package:flutter/material.dart';

import '../models/jewelry.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Jewelry> _wishlist = [];

  List<Jewelry> get wishlist => _wishlist;

  bool isInWishlist(Jewelry item) {
    return _wishlist.any((j) => j.id == item.id);
  }

  void toggleWishlist(Jewelry item) {
    if (isInWishlist(item)) {
      _wishlist.removeWhere((j) => j.id == item.id);
    } else {
      _wishlist.add(item);
    }
    notifyListeners();
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}

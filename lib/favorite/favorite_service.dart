import 'package:flutter/foundation.dart';

import '../models/jewelry.dart';

class FavoriteService extends ChangeNotifier {
  final List<Jewelry> _favorites = [];

  List<Jewelry> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((item) => item.id == id);
  }

  void toggleFavorite(Jewelry jewelry) {
    if (isFavorite(jewelry.id)) {
      _favorites.removeWhere((item) => item.id == jewelry.id);
    } else {
      _favorites.add(jewelry);
    }
    notifyListeners();
  }
}

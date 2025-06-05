import 'package:flutter/foundation.dart';
import 'package:jewelry_management_app/database/database_helper.dart';

import '../models/jewelry.dart';

class JewelryService extends ChangeNotifier {
  List<Jewelry> _jewelry = [];
  bool _isLoading = false;
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';

  List<Jewelry> get jewelry => _getFilteredJewelry();
  List<Jewelry> get allJewelry => _jewelry;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  final jewelryDbHelper = GenericDbHelper<Jewelry>('jewelries', Jewelry.fromJson);


  JewelryService() {
    loadJewelryFromDb();

  }

  Future<void> loadJewelryFromDb() async {
    _jewelry = await jewelryDbHelper.getAll(); // Đợi dữ liệu được trả về
    print('Jewelry loaded from DB: ${_jewelry[0].images}');
    notifyListeners(); // Thông báo cho các widget đang lắng nghe cập nhật lại UI
  }

  List<Jewelry> _getFilteredJewelry() {
    List<Jewelry> filtered = _jewelry;

    // Filter by category
    if (_selectedCategory != 'Tất cả') {
      filtered =
          filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (item) =>
                    item.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    item.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    item.material.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Jewelry? getJewelryById(String id) {
    try {
      return _jewelry.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshJewelry() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  // Admin functions
  Future<bool> addJewelry(Jewelry jewelry) async {
    try {
      _jewelry.add(jewelry);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateJewelry(Jewelry jewelry) async {
    try {
      final index = _jewelry.indexWhere((item) => item.id == jewelry.id);
      if (index != -1) {
        _jewelry[index] = jewelry;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteJewelry(String id) async {
    try {
      _jewelry.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStock(String id, int newStock) async {
    try {
      final index = _jewelry.indexWhere((item) => item.id == id);
      if (index != -1) {
        _jewelry[index] = _jewelry[index].copyWith(stock: newStock);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  List<Jewelry> getFeaturedJewelry() {
    return _jewelry.where((item) => item.rating >= 4.5).take(4).toList();
  }

  List<Jewelry> getDiscountedJewelry() {
    return _jewelry.where((item) => item.hasDiscount).toList();
  }
}

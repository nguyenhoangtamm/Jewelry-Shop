import 'package:flutter/material.dart';
import 'package:jewelry_management_app/database/database_helper.dart';

import '../models/jewelry.dart';

class JewelryProvider extends ChangeNotifier {
  List<Jewelry> _jewelries = [];
  List<Jewelry> _filteredJewelries = [];
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  String _selectedMaterial = 'Tất cả';
  double _minPrice = 0;
  double _maxPrice = 50000000;
  bool _showOnlyAvailable = false;
  bool _showOnlyCertified = false;
  final jewelryDbHelper =
      GenericDbHelper<Jewelry>('jewelries', Jewelry.fromJson);

  List<Jewelry> get jewelries =>
      _filteredJewelries.isEmpty ? _jewelries : _filteredJewelries;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedMaterial => _selectedMaterial;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  bool get showOnlyAvailable => _showOnlyAvailable;
  bool get showOnlyCertified => _showOnlyCertified;

  List<String> get categories {
    final categories =
        _jewelries.map((jewelry) => jewelry.category).toSet().toList();
    categories.insert(0, 'Tất cả');
    return categories;
  }

  List<String> get materials {
    final materials =
        _jewelries.map((jewelry) => jewelry.material).toSet().toList();
    materials.insert(0, 'Tất cả');
    return materials;
  }

  List<String> get brands {
    final brands = _jewelries.map((jewelry) => jewelry.brand).toSet().toList();
    return brands;
  }

  JewelryProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _jewelries = (await jewelryDbHelper.getAll())
        .where((j) => j.isDeleted == false)
        .toList();
    _filteredJewelries = List.from(_jewelries);
    notifyListeners();
  }

  void searchJewelries(String query) {
    _searchQuery = query;
    _filterJewelries();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _filterJewelries();
  }

  void filterByMaterial(String material) {
    _selectedMaterial = material;
    _filterJewelries();
  }

  void filterByPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _filterJewelries();
  }

  void toggleAvailableOnly(bool value) {
    _showOnlyAvailable = value;
    _filterJewelries();
  }

  void toggleCertifiedOnly(bool value) {
    _showOnlyCertified = value;
    _filterJewelries();
  }

  void _filterJewelries() {
    _filteredJewelries =
        _jewelries.where((jewelry) => !jewelry.isDeleted).where((jewelry) {
      final matchesSearch = _searchQuery.isEmpty ||
          jewelry.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          jewelry.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          jewelry.brand.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'Tất cả' ||
          jewelry.category == _selectedCategory;
      final matchesMaterial = _selectedMaterial == 'Tất cả' ||
          jewelry.material == _selectedMaterial;
      final matchesPrice =
          jewelry.price >= _minPrice && jewelry.price <= _maxPrice;
      final matchesAvailable = !_showOnlyAvailable ||
          (jewelry.isAvailable && jewelry.stockQuantity > 0);
      final matchesCertified = !_showOnlyCertified || jewelry.isCertified;

      return matchesSearch &&
          matchesCategory &&
          matchesMaterial &&
          matchesPrice &&
          matchesAvailable &&
          matchesCertified;
    }).toList();
    notifyListeners();
  }

  void addJewelry(Jewelry jewelry) {
    _jewelries.add(jewelry);
    _filteredJewelries.add(jewelry);
    jewelryDbHelper.insert(jewelry);
    _filterJewelries();
  }

  void updateJewelry(Jewelry jewelry) {
    final index = _jewelries.indexWhere((j) => j.id == jewelry.id);
    if (index != -1) {
      _jewelries[index] = jewelry;
      jewelryDbHelper.update(jewelry); // Thêm dòng này
      _filterJewelries();
    }
  }

  void removeJewelry(String jewelryId) {
    final index = _jewelries.indexWhere((jewelry) => jewelry.id == jewelryId);
    if (index != -1) {
      final updatedJewelry = _jewelries[index].copyWith(isDeleted: true);
      _jewelries[index] = updatedJewelry;
      jewelryDbHelper.update(updatedJewelry);
      _filterJewelries();
    }
  }

  void updateStock(String jewelryId, int newStock) {
    final index = _jewelries.indexWhere((j) => j.id == jewelryId);
    if (index != -1) {
      final updatedJewelry =
          _jewelries[index].copyWith(stockQuantity: newStock);
      _jewelries[index] = updatedJewelry;
      jewelryDbHelper.update(updatedJewelry); // Thêm dòng này
      _filterJewelries();
    }
  }

  Jewelry? getJewelryById(String id) {
    try {
      return _jewelries.firstWhere((jewelry) => jewelry.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Jewelry> getJewelriesByCategory(String category) {
    return _jewelries.where((jewelry) => jewelry.category == category).toList();
  }

  List<Jewelry> getJewelriesByBrand(String brand) {
    return _jewelries.where((jewelry) => jewelry.brand == brand).toList();
  }

  List<Jewelry> getCertifiedJewelries() {
    return _jewelries.where((jewelry) => jewelry.isCertified).toList();
  }

  List<Jewelry> getRecommendedJewelries() {
    return _jewelries
        .where((jewelry) => jewelry.rating >= 4.5)
        .take(6)
        .toList();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'Tất cả';
    _selectedMaterial = 'Tất cả';
    _minPrice = 0;
    _maxPrice = 50000000;
    _showOnlyAvailable = false;
    _showOnlyCertified = false;
    _filterJewelries();
  }
}

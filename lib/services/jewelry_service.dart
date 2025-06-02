import 'package:flutter/foundation.dart';

import '../models/jewelry.dart';
import '../utils/app_theme.dart';

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

  JewelryService() {
    _loadMockData();
  }

  void _loadMockData() {
    _jewelry = [
      Jewelry(
        id: '1',
        name: 'Bộ trang sức Sapphire',
        description:
            'Bộ trang sức sang trọng với đá Sapphire xanh tự nhiên, thiết kế tinh tế và đẳng cấp.',
        price: 25000000,
        originalPrice: 30000000,
        category: 'Bộ trang sức',
        material: 'Vàng 18K',
        images: ['assets/images/jewelry/sapphire_set.jpg'],
        stock: 5,
        rating: 4.8,
        reviewCount: 24,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        specifications: {
          'Kích thước': 'Điều chỉnh được',
          'Trọng lượng': '15g',
          'Đá chính': 'Sapphire tự nhiên',
          'Đá phụ': 'Kim cương nhân tạo',
        },
      ),
      Jewelry(
        id: '2',
        name: 'Bộ trang sức Kim cương',
        description:
            'Bộ trang sức cao cấp với kim cương và đá CZ, ánh sáng lung linh.',
        price: 45000000,
        originalPrice: 50000000,
        category: 'Bộ trang sức',
        material: 'Bạch kim',
        images: ['assets/images/jewelry/diamond_set.jpg'],
        stock: 3,
        rating: 5.0,
        reviewCount: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        specifications: {
          'Kích thước': 'Điều chỉnh được',
          'Trọng lượng': '20g',
          'Đá chính': 'Kim cương',
          'Chất liệu': 'Bạch kim 950',
        },
      ),
      Jewelry(
        id: '3',
        name: 'Bộ trang sức Emerald vàng',
        description:
            'Bộ trang sức 5 món bao gồm đồng hồ, vòng tay, nhẫn, bông tai và dây chuyền.',
        price: 35000000,
        category: 'Bộ trang sức',
        material: 'Vàng 18K',
        images: ['assets/images/jewelry/emerald_set.webp'],
        stock: 7,
        rating: 4.5,
        reviewCount: 32,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        specifications: {
          'Số món': '5 món',
          'Trọng lượng': '35g',
          'Đá chính': 'Emerald',
          'Phụ kiện': 'Đồng hồ Geneva',
        },
      ),
      Jewelry(
        id: '4',
        name: 'Nhẫn kim cương solitaire',
        description:
            'Nhẫn kim cương đơn giản, thanh lịch phù hợp cho lễ đính hôn.',
        price: 15000000,
        originalPrice: 18000000,
        category: 'Nhẫn',
        material: 'Vàng trắng 18K',
        images: [
          'assets/images/jewelry/sapphire_set.jpg',
        ], // Using available image
        stock: 10,
        rating: 4.9,
        reviewCount: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        specifications: {
          'Kích thước': '6-8 (có thể điều chỉnh)',
          'Trọng lượng': '3.5g',
          'Kim cương': '1 carat',
          'Độ tinh khiết': 'VS1',
        },
      ),
      Jewelry(
        id: '5',
        name: 'Dây chuyền bạc 925',
        description:
            'Dây chuyền bạc cao cấp với mặt hình trái tim, thích hợp làm quà tặng.',
        price: 2500000,
        category: 'Dây chuyền',
        material: 'Bạc 925',
        images: [
          'assets/images/jewelry/diamond_set.jpg',
        ], // Using available image
        stock: 20,
        rating: 4.3,
        reviewCount: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        specifications: {
          'Chiều dài': '45cm',
          'Trọng lượng': '8g',
          'Mặt dây': 'Hình trái tim',
          'Khóa': 'Khóa tôm bấm',
        },
      ),
      Jewelry(
        id: '6',
        name: 'Bông tai ngọc trai',
        description:
            'Bông tai ngọc trai Akoya tự nhiên, kiểu dáng cổ điển và sang trọng.',
        price: 8500000,
        category: 'Bông tai',
        material: 'Vàng 14K',
        images: [
          'assets/images/jewelry/emerald_set.webp',
        ], // Using available image
        stock: 15,
        rating: 4.7,
        reviewCount: 28,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        specifications: {
          'Kích thước ngọc trai': '8-9mm',
          'Loại ngọc trai': 'Akoya tự nhiên',
          'Màu sắc': 'Trắng kem',
          'Kiểu khóa': 'Khóa bấm',
        },
      ),
      Jewelry(
        id: '7',
        name: 'Lắc tay vàng trắng',
        description:
            'Lắc tay vàng trắng với họa tiết hoa văn tinh xảo, phù hợp mọi lứa tuổi.',
        price: 12000000,
        originalPrice: 14000000,
        category: 'Lắc tay',
        material: 'Vàng trắng 18K',
        images: [
          'assets/images/jewelry/sapphire_set.jpg',
        ], // Using available image
        stock: 8,
        rating: 4.6,
        reviewCount: 19,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        specifications: {
          'Chiều dài': '18cm',
          'Trọng lượng': '12g',
          'Họa tiết': 'Hoa văn cổ điển',
          'Khóa': 'Khóa an toàn',
        },
      ),
      Jewelry(
        id: '8',
        name: 'Đồng hồ nữ Diamond',
        description:
            'Đồng hồ nữ cao cấp với viền kim cương, mặt số mother of pearl.',
        price: 28000000,
        category: 'Đồng hồ',
        material: 'Vàng 18K',
        images: [
          'assets/images/jewelry/emerald_set.webp',
        ], // Using available image
        stock: 4,
        rating: 4.8,
        reviewCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        specifications: {
          'Đường kính mặt': '32mm',
          'Chống nước': '50m',
          'Máy': 'Quartz Nhật Bản',
          'Mặt số': 'Mother of Pearl',
        },
      ),
    ];
    notifyListeners();
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

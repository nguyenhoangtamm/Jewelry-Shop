import 'package:flutter/material.dart';
import 'package:jewelry_management_app/database/database_helper.dart';
import 'package:jewelry_management_app/models/favorite_jewelries.dart';
import 'package:jewelry_management_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Jewelry> _wishlist = [];
  final favoriteJewelriesDbHelper = GenericDbHelper<FavoriteJewelry>(
      'favorite_jewelries', FavoriteJewelry.fromJson);
  List<Jewelry> get wishlist => _wishlist;
  final jewelryDbHelper =
      GenericDbHelper<Jewelry>('jewelries', Jewelry.fromJson);
  WishlistProvider();

  Future<void> initializeWishlist(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      _wishlist.clear();
      notifyListeners();
      return;
    }

    final favorites = await favoriteJewelriesDbHelper.getAll();
    _wishlist.clear();

    // Lấy danh sách jewelry theo favorite (lọc theo userId và isDeleted)
    final filteredFavorites = favorites
        .where((f) => f.userId == userId && f.isDeleted != true)
        .toList();

    // Lấy tất cả jewelry theo id (song song)
    final jewelryList = await Future.wait(
      filteredFavorites
          .map((favorite) => jewelryDbHelper.getById(favorite.jewelryId)),
    );

    // Thêm vào wishlist nếu không null
    _wishlist.addAll(jewelryList.whereType<Jewelry>());

    notifyListeners();
  }

  bool isInWishlist(Jewelry item) {
    return _wishlist.any((j) => j.id == item.id);
  }

  void toggleWishlist(BuildContext context, Jewelry item) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;
    if (userId == null) return;

    if (isInWishlist(item)) {
      // Xóa khỏi wishlist và cập nhật database (isDeleted = true)
      _wishlist.removeWhere((j) => j.id == item.id);
      // Tìm favorite theo jewelryId và userId
      final favorites = await favoriteJewelriesDbHelper.getAll();
      final favorite = favorites.firstWhere(
        (f) => f.jewelryId == item.id && f.userId == userId,
        orElse: () => FavoriteJewelry(
          id: '',
          jewelryId: '',
          userId: '',
          addedAt: DateTime.now(),
          createdAt: DateTime.now(),
          isDeleted: false,
        ),
      );
      if (favorite.id.isNotEmpty) {
        await favoriteJewelriesDbHelper
            .update(favorite.copyWith(isDeleted: true));
      }
    } else {
      _wishlist.add(item);
      // Tìm favorite đã từng tồn tại (kể cả đã xóa mềm)
      final favorites = await favoriteJewelriesDbHelper.getAll();
      final favorite = favorites.firstWhere(
        (f) => f.jewelryId == item.id && f.userId == userId,
        orElse: () => FavoriteJewelry(
          id: '',
          jewelryId: '',
          userId: '',
          addedAt: DateTime.now(),
          createdAt: DateTime.now(),
          isDeleted: false,
        ),
      );
      if (favorite.id.isNotEmpty) {
        // Nếu đã có, chỉ cần update lại isDeleted = false
        await favoriteJewelriesDbHelper.update(
          favorite.copyWith(isDeleted: false, addedAt: DateTime.now()),
        );
      } else {
        // Nếu chưa có, insert mới
        final newFavorite = FavoriteJewelry(
          id: UniqueKey().toString(),
          jewelryId: item.id,
          userId: userId,
          addedAt: DateTime.now(),
          createdAt: DateTime.now(),
          isDeleted: false,
        );
        await favoriteJewelriesDbHelper.insert(newFavorite);
      }
    }
    notifyListeners();
  }

  Future<void> removeWishlist(BuildContext context, Jewelry item) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;
    if (userId == null) return;

    if (isInWishlist(item)) {
      // Xóa khỏi wishlist và cập nhật database (isDeleted = true)
      _wishlist.removeWhere((j) => j.id == item.id);
      // Tìm favorite theo jewelryId và userId
      final favorites = await favoriteJewelriesDbHelper.getAll();
      final favorite = favorites.firstWhere(
        (f) => f.jewelryId == item.id && f.userId == userId && !f.isDeleted,
        orElse: () => FavoriteJewelry(
          id: '',
          jewelryId: '',
          userId: '',
          addedAt: DateTime.now(),
          createdAt: DateTime.now(),
          isDeleted: false,
        ),
      );
      if (favorite.id.isNotEmpty) {
        await favoriteJewelriesDbHelper
            .update(favorite.copyWith(isDeleted: true));
      }
      if (favorite.id.isNotEmpty) {
        await favoriteJewelriesDbHelper
            .update(favorite.copyWith(isDeleted: true));
      }
      notifyListeners();
    }
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}

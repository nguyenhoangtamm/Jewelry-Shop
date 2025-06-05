import 'package:flutter/material.dart';
import 'package:jewelry_management_app/favorite/favorite_service.dart';
import 'package:provider/provider.dart';

import '../../models/jewelry.dart';
import '../../widgets/jewelry_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteService = context.watch<FavoriteService>();
    final List<Jewelry> favorites = favoriteService.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm yêu thích'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('Chưa có sản phẩm yêu thích nào'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final jewelry = favorites[index];
                return JewelryCard(jewelry: jewelry);
              },
            ),
    );
  }
}

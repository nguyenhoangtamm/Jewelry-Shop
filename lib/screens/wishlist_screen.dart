import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';
import '../providers/wishlist_provider.dart';
import 'jewelry_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu thích'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: wishlist.isEmpty
          ? const Center(
              child: Text('Bạn chưa thêm sản phẩm nào vào yêu thích.'),
            )
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final Jewelry item = wishlist[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl:
                        item.imageUrls.isNotEmpty ? item.imageUrls.first : '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image_not_supported),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      wishlistProvider.toggleWishlist(item);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JewelryDetailScreen(jewelry: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

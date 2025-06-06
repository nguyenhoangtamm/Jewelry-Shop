import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';
import '../providers/cart_provider.dart';
import '../providers/jewelry_provider.dart';
import '../screens/jewelry_detail_screen.dart';
import '../utils/app_theme.dart';

class JewelryGrid extends StatelessWidget {
  const JewelryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JewelryProvider>(
      builder: (context, jewelryProvider, child) {
        final jewelries = jewelryProvider.jewelries;

        if (jewelries.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.diamond, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Không tìm thấy trang sức nào',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: jewelries.length,
          itemBuilder: (context, index) {
            final jewelry = jewelries[index];
            return JewelryCard(jewelry: jewelry);
          },
        );
      },
    );
  }
}

class JewelryCard extends StatelessWidget {
  final Jewelry jewelry;

  const JewelryCard({super.key, required this.jewelry});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(jewelry.id);
        final quantityInCart = cartProvider.getQuantityInCart(jewelry.id);

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JewelryDetailScreen(jewelry: jewelry),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image với badges
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: jewelry.imageUrls.isNotEmpty
                                ? jewelry.imageUrls.first
                                : '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.diamond,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Badge chứng nhận
                      if (jewelry.isCertified)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'Chứng nhận',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Badge hết hàng
                      if (!jewelry.isAvailable)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'HẾT HÀNG',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên và thương hiệu
                        Text(
                          jewelry.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          jewelry.brand,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Chất liệu và đá quý
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: _getColorFromString(jewelry.color),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${jewelry.material}${jewelry.gemstone.isNotEmpty ? ' - ${jewelry.gemstone}' : ''}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Rating
                        if (jewelry.reviewCount > 0)
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: jewelry.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${jewelry.reviewCount})',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                        const Spacer(),

                        // Price and Add Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${jewelry.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                if (jewelry.weight > 0)
                                  Text(
                                    '${jewelry.weight}g',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                            if (jewelry.isAvailable && !isInCart)
                              InkWell(
                                onTap: () {
                                  cartProvider.addToCart(jewelry);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${jewelry.name} đã thêm vào giỏ hàng',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AppTheme.successColor,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              )
                            else if (jewelry.isAvailable && isInCart)
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        final cartItem =
                                            cartProvider.items.firstWhere(
                                          (item) =>
                                              item.jewelry.id == jewelry.id,
                                        );
                                        cartProvider.decreaseQuantity(
                                          cartItem.id,
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        quantityInCart.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final cartItem =
                                            cartProvider.items.firstWhere(
                                          (item) =>
                                              item.jewelry.id == jewelry.id,
                                        );
                                        cartProvider.increaseQuantity(
                                          cartItem.id,
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'vàng':
      case 'gold':
        return Colors.amber;
      case 'bạc':
      case 'silver':
        return Colors.grey;
      case 'trắng':
      case 'white':
        return Colors.white;
      case 'đen':
      case 'black':
        return Colors.black;
      case 'hồng':
      case 'pink':
        return Colors.pink;
      case 'xanh':
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_management_app/favorite/favorite_service.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';
import '../services/cart_service.dart';
import '../utils/app_theme.dart';

class JewelryCard extends StatelessWidget {
  final Jewelry jewelry;
  final VoidCallback? onTap;
  final bool showAddToCart;

  const JewelryCard({
    super.key,
    required this.jewelry,
    this.onTap,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            _buildDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: jewelry.mainImage.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: jewelry.mainImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          _buildPlaceholderImage(),
                    )
                  : Image.asset(
                      jewelry.mainImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    ),
            ),
          ),
          if (jewelry.hasDiscount)
            _buildBadge(
              text: '-${jewelry.discountPercentage.toInt()}%',
              color: Colors.red,
              alignLeft: true,
            ),
          if (!jewelry.inStock)
            _buildBadge(
              text: 'Hết hàng',
              color: Colors.grey[700]!,
              alignLeft: false,
            ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jewelry.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            jewelry.material,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.silverGray,
                ),
          ),
          const SizedBox(height: 4),
          _buildRating(context),
          const SizedBox(height: 8), // Thay Spacer bằng SizedBox
          _buildPriceAndCart(context),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color color,
    required bool alignLeft,
  }) {
    return Positioned(
      top: 8,
      left: alignLeft ? 8 : null,
      right: alignLeft ? null : 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          IconData icon;
          if (index < jewelry.rating.floor()) {
            icon = Icons.star;
          } else if (index < jewelry.rating) {
            icon = Icons.star_half;
          } else {
            icon = Icons.star_border;
          }
          return Icon(icon, size: 12, color: Colors.amber);
        }),
        const SizedBox(width: 4),
        Text(
          '(${jewelry.reviewCount})',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.silverGray,
              ),
        ),
      ],
    );
  }

  Widget _buildPriceAndCart(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Giá
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (jewelry.hasDiscount)
                Text(
                  jewelry.originalPrice!.formatted,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: AppTheme.silverGray,
                      ),
                ),
              Text(
                jewelry.price.formatted,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Nút yêu thích + giỏ hàng
        Column(
          children: [
            Consumer<FavoriteService>(
              builder: (context, favoriteService, _) {
                final isFav = favoriteService.isFavorite(jewelry.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    favoriteService.toggleFavorite(jewelry);
                  },
                );
              },
            ),
            if (showAddToCart && jewelry.inStock)
              Consumer<CartService>(
                builder: (context, cartService, _) {
                  final isInCart = cartService.isInCart(jewelry.id);
                  return InkWell(
                    onTap: () async {
                      if (isInCart) return;
                      final success = await cartService.addToCart(jewelry);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Đã thêm vào giỏ hàng'
                                  : 'Không đủ hàng trong kho',
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isInCart
                            ? AppTheme.primaryGold.withOpacity(0.1)
                            : AppTheme.primaryGold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isInCart ? Icons.check : Icons.add_shopping_cart,
                        size: 16,
                        color: isInCart ? AppTheme.primaryGold : Colors.white,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: const Icon(Icons.diamond, size: 40, color: AppTheme.primaryGold),
    );
  }
}

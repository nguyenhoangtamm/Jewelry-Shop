import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child:
                          jewelry.mainImage.startsWith('http')
                              ? CachedNetworkImage(
                                imageUrl: jewelry.mainImage,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                        _buildPlaceholderImage(),
                              )
                              : Image.asset(
                                jewelry.mainImage,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildPlaceholderImage(),
                              ),
                    ),
                  ),

                  // Discount badge
                  if (jewelry.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${jewelry.discountPercentage.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Stock status
                  if (!jewelry.inStock)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Hết hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      jewelry.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Material
                    Text(
                      jewelry.material,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.silverGray,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < jewelry.rating.floor()
                                  ? Icons.star
                                  : index < jewelry.rating
                                  ? Icons.star_half
                                  : Icons.star_border,
                              size: 12,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${jewelry.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.silverGray),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price and action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (jewelry.hasDiscount)
                                Text(
                                  jewelry.originalPrice!.formatted,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme.silverGray,
                                  ),
                                ),
                              Text(
                                jewelry.price.formatted,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.primaryGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (showAddToCart && jewelry.inStock)
                          Consumer<CartService>(
                            builder: (context, cartService, child) {
                              final isInCart = cartService.isInCart(jewelry.id);

                              return InkWell(
                                onTap: () async {
                                  if (isInCart) return;

                                  final success = await cartService.addToCart(
                                    jewelry,
                                  );
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
                                    color:
                                        isInCart
                                            ? AppTheme.primaryGold.withOpacity(
                                              0.1,
                                            )
                                            : AppTheme.primaryGold,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    isInCart
                                        ? Icons.check
                                        : Icons.add_shopping_cart,
                                    size: 16,
                                    color:
                                        isInCart
                                            ? AppTheme.primaryGold
                                            : Colors.white,
                                  ),
                                ),
                              );
                            },
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

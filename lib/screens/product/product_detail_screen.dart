import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/cart_service.dart';
import '../../services/jewelry_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<JewelryService>(
      builder: (context, jewelryService, child) {
        final product = jewelryService.getJewelryById(widget.productId);

        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sản phẩm không tồn tại')),
            body: const Center(child: Text('Không tìm thấy sản phẩm')),
          );
        }

        return Scaffold(
appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      context.go('/home'); // hoặc Navigator.pop(context) nếu bạn dùng push
    },
  ),
  title: Text(product.name),
  actions: [
    Consumer<CartService>(
      builder: (context, cartService, child) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => context.go('/cart'),
            ),
            if (cartService.itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cartService.itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    ),
  ],
),

          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product images
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: product.images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[100],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  product.images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.diamond,
                                        size: 80,
                                        color: AppTheme.primaryGold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Image indicators
                      if (product.images.length > 1)
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedImageIndex == index
                                          ? AppTheme.primaryGold
                                          : AppTheme.silverGray,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Product info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and rating
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < product.rating.floor()
                                          ? Icons.star
                                          : index < product.rating
                                          ? Icons.star_half
                                          : Icons.star_border,
                                      size: 20,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${product.rating} (${product.reviewCount} đánh giá)',
                                  style: const TextStyle(
                                    color: AppTheme.silverGray,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Price
                            if (product.hasDiscount)
                              Text(
                                product.originalPrice!.formatted,
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme.silverGray,
                                  fontSize: 16,
                                ),
                              ),
                            Text(
                              product.price.formatted,
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (product.hasDiscount)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Giảm ${product.discountPercentage.toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Material and category
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoChip(
                                    'Chất liệu',
                                    product.material,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildInfoChip(
                                    'Danh mục',
                                    product.category,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Stock status
                            Row(
                              children: [
                                Icon(
                                  product.inStock
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color:
                                      product.inStock
                                          ? Colors.green
                                          : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  product.inStock
                                      ? 'Còn ${product.stock} sản phẩm'
                                      : 'Hết hàng',
                                  style: TextStyle(
                                    color:
                                        product.inStock
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Description
                            Text(
                              'Mô tả sản phẩm',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),

                            const SizedBox(height: 24),

                            // Specifications
                            if (product.specifications != null &&
                                product.specifications!.isNotEmpty) ...[
                              Text(
                                'Thông số kỹ thuật',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children:
                                        product.specifications!.entries
                                            .map(
                                              (entry) => Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        entry.key,
                                                        style: const TextStyle(
                                                          color:
                                                              AppTheme
                                                                  .silverGray,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        entry.value.toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom action bar
              if (product.inStock)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Quantity selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.silverGray),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed:
                                  _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                              icon: const Icon(Icons.remove),
                              iconSize: 20,
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppTheme.silverGray,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  _quantity < product.stock
                                      ? () => setState(() => _quantity++)
                                      : null,
                              icon: const Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Add to cart button
                      Expanded(
                        child: Consumer<CartService>(
                          builder: (context, cartService, child) {
                            return CustomButton(
                              text: 'Thêm vào giỏ hàng',
                              icon: Icons.add_shopping_cart,
                              onPressed: () async {
                                final success = await cartService.addToCart(
                                  product,
                                  quantity: _quantity,
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Đã thêm $_quantity sản phẩm vào giỏ hàng'
                                            : 'Không đủ hàng trong kho',
                                      ),
                                      backgroundColor:
                                          success ? Colors.green : Colors.red,
                                      action:
                                          success
                                              ? SnackBarAction(
                                                label: 'Xem giỏ hàng',
                                                textColor: Colors.white,
                                                onPressed:
                                                    () => context.go('/cart'),
                                              )
                                              : null,
                                    ),
                                  );

                                  if (success) {
                                    setState(() => _quantity = 1);
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGold.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.silverGray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.deepBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

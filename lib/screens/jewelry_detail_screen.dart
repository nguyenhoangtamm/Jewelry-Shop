import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jewelry_management_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';

class JewelryDetailScreen extends StatefulWidget {
  final Jewelry jewelry;

  const JewelryDetailScreen({super.key, required this.jewelry});

  @override
  State<JewelryDetailScreen> createState() => _JewelryDetailScreenState();
}

class _JewelryDetailScreenState extends State<JewelryDetailScreen> {
  int quantity = 1;
  final TextEditingController _engravingController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? selectedGiftWrap;
  int currentImageIndex = 0;
  PageController pageController = PageController();
  bool isFavorite = false;

  final List<String> giftWrapOptions = [
    'Không gói quà',
    'Hộp quà cao cấp',
    'Túi quà sang trọng',
    'Hộp gỗ đặc biệt',
  ];

  @override
  void dispose() {
    _engravingController.dispose();
    _messageController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isFavorite = wishlistProvider.isInWishlist(widget.jewelry);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jewelry.name),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              wishlistProvider.toggleWishlist(widget.jewelry);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
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
                  // Jewelry Images Carousel
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentImageIndex = index;
                            });
                          },
                          itemCount: widget.jewelry.imageUrls.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.jewelry.imageUrls[index],
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
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                        // Image indicator
                        if (widget.jewelry.imageUrls.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.jewelry.imageUrls.length,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentImageIndex == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Stock status badge
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.jewelry.isAvailable
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.jewelry.isAvailable
                                  ? 'Còn hàng (${widget.jewelry.stockQuantity})'
                                  : 'Hết hàng',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Brand
                        Text(
                          widget.jewelry.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.jewelry.category,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Thương hiệu: ${widget.jewelry.brand}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Rating and Reviews
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: widget.jewelry.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.jewelry.rating} (${widget.jewelry.reviewCount} đánh giá)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Price and Certificate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.jewelry.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            if (widget.jewelry.isCertified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Có chứng nhận',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Product Details
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chi tiết sản phẩm',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                  'Chất liệu', widget.jewelry.material),
                              if (widget.jewelry.gemstone.isNotEmpty)
                                _buildDetailRow(
                                    'Đá quý', widget.jewelry.gemstone),
                              _buildDetailRow(
                                  'Kích thước', widget.jewelry.size),
                              _buildDetailRow('Màu sắc', widget.jewelry.color),
                              _buildDetailRow(
                                  'Trọng lượng', '${widget.jewelry.weight}g'),
                              if (widget.jewelry.origin.isNotEmpty)
                                _buildDetailRow(
                                    'Xuất xứ', widget.jewelry.origin),
                              if (widget.jewelry.certificateNumber != null)
                                _buildDetailRow('Số chứng nhận',
                                    widget.jewelry.certificateNumber!),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        const Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.jewelry.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Gift Wrap Options
                        const Text(
                          'Tùy chọn gói quà',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedGiftWrap ?? giftWrapOptions[0],
                            isExpanded: true,
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGiftWrap = newValue;
                              });
                            },
                            items: giftWrapOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Engraving
                        const Text(
                          'Khắc chữ (tùy chọn)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _engravingController,
                          maxLength: 20,
                          decoration: InputDecoration(
                            hintText: 'Nhập nội dung khắc (tối đa 20 ký tự)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Personal Message
                        const Text(
                          'Lời nhắn cá nhân',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _messageController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Nhập lời nhắn cá nhân (không bắt buộc)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quantity Selector
                        Row(
                          children: [
                            const Text(
                              'Số lượng:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: quantity > 1
                                        ? () {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        quantity < widget.jewelry.stockQuantity
                                            ? () {
                                                setState(() {
                                                  quantity++;
                                                });
                                              }
                                            : null,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(widget.jewelry.price * quantity).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.jewelry.isAvailable
                        ? () {
                            final cartProvider = context.read<CartProvider>();
                            cartProvider.addToCart(
                              widget.jewelry,
                              quantity: quantity,
                              giftWrapOption:
                                  selectedGiftWrap != giftWrapOptions[0]
                                      ? selectedGiftWrap
                                      : null,
                              engraving: _engravingController.text.isNotEmpty
                                  ? _engravingController.text
                                  : null,
                              personalizedMessage:
                                  _messageController.text.isNotEmpty
                                      ? _messageController.text
                                      : null,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.jewelry.name} x$quantity đã thêm vào giỏ hàng',
                                ),
                                backgroundColor: AppTheme.successColor,
                                duration: const Duration(seconds: 2),
                              ),
                            );

                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: widget.jewelry.isAvailable
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    child: Text(
                      widget.jewelry.isAvailable
                          ? 'Thêm vào giỏ hàng'
                          : 'Tạm hết hàng',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

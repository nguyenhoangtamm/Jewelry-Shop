import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';
import '../providers/jewelry_provider.dart';
import '../screens/add_jewelry_screen.dart';
import '../utils/app_theme.dart';

class AdminJewelryCard extends StatelessWidget {
  final Jewelry jewelry;

  const AdminJewelryCard({super.key, required this.jewelry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Jewelry Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: jewelry.imageUrls.isNotEmpty
                        ? jewelry.imageUrls.first
                        : '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.diamond,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  if (jewelry.isCertified)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Jewelry Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          jewelry.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: jewelry.isAvailable
                              ? AppTheme.successColor.withOpacity(0.1)
                              : AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          jewelry.isAvailable ? 'Có sẵn' : 'Hết hàng',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: jewelry.isAvailable
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Brand và Category
                  Row(
                    children: [
                      Text(
                        jewelry.brand,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          jewelry.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Material và Gemstone
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: _getColorFromString(jewelry.color),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        jewelry.material,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (jewelry.gemstone.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${jewelry.gemstone}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Kích thước và Trọng lượng
                  Row(
                    children: [
                      Text(
                        'Size: ${jewelry.size}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (jewelry.weight > 0) ...[
                        const SizedBox(width: 12),
                        Text(
                          '${jewelry.weight}g',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    jewelry.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${jewelry.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'Kho: ${jewelry.stockQuantity}',
                            style: TextStyle(
                              fontSize: 10,
                              color: jewelry.stockQuantity > 10
                                  ? Colors.green[600]
                                  : jewelry.stockQuantity > 0
                                      ? Colors.orange[600]
                                      : Colors.red[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '⭐ ${jewelry.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${jewelry.reviewCount})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action Buttons
            Column(
              children: [
                // Edit Button
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddJewelryScreen(jewelryToEdit: jewelry),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.blue[600], size: 20),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),

                // Delete Button
                IconButton(
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                  icon: Icon(Icons.delete, color: Colors.red[600], size: 20),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),

                // Toggle Availability Button
                IconButton(
                  onPressed: () {
                    final updatedJewelry = jewelry.copyWith(
                      isAvailable: !jewelry.isAvailable,
                    );
                    context
                        .read<JewelryProvider>()
                        .updateJewelry(updatedJewelry);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          updatedJewelry.isAvailable
                              ? '${jewelry.name} đã được đặt có sẵn'
                              : '${jewelry.name} đã được đặt hết hàng',
                        ),
                        backgroundColor: updatedJewelry.isAvailable
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                      ),
                    );
                  },
                  icon: Icon(
                    jewelry.isAvailable
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: jewelry.isAvailable
                        ? Colors.orange[600]
                        : Colors.green[600],
                    size: 20,
                  ),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),

                // Stock Button
                IconButton(
                  onPressed: () {
                    _showStockDialog(context);
                  },
                  icon: Icon(
                    Icons.inventory,
                    color: jewelry.stockQuantity > 10
                        ? Colors.green[600]
                        : jewelry.stockQuantity > 0
                            ? Colors.orange[600]
                            : Colors.red[600],
                    size: 20,
                  ),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa trang sức'),
          content: Text('Bạn có chắc chắn muốn xóa "${jewelry.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context.read<JewelryProvider>().removeJewelry(jewelry.id);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${jewelry.name} đã được xóa'),
                    backgroundColor: AppTheme.errorColor,
                    action: SnackBarAction(
                      label: 'Hoàn tác',
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<JewelryProvider>().addJewelry(jewelry);
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                'Xóa',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStockDialog(BuildContext context) {
    final TextEditingController stockController = TextEditingController(
      text: jewelry.stockQuantity.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cập nhật số lượng kho'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Trang sức: ${jewelry.name}'),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số lượng trong kho',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final newStock = int.tryParse(stockController.text) ?? 0;
                final updatedJewelry = jewelry.copyWith(
                  stockQuantity: newStock,
                  isAvailable: newStock > 0,
                );
                context.read<JewelryProvider>().updateJewelry(updatedJewelry);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Đã cập nhật kho ${jewelry.name}: $newStock sản phẩm',
                    ),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: const Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }
}

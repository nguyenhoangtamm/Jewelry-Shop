import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/jewelry_service.dart';
import '../utils/app_theme.dart';
import '../widgets/jewelry_card.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  String _selectedCategory = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'), // Quay về trang /admin
        ),
        title: const Text('Quản lý sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddProductDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryGold,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.deepBlue,
                    ),
                  ),
                );
              },
            ),
          ),

          // Products list
          Expanded(
            child: Consumer<JewelryService>(
              builder: (context, jewelryService, child) {
                final allProducts = jewelryService.allJewelry;
                final filteredProducts =
                    _selectedCategory == 'Tất cả'
                        ? allProducts
                        : allProducts
                            .where((p) => p.category == _selectedCategory)
                            .toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppTheme.silverGray,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có sản phẩm nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.silverGray,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child:
                              product.mainImage.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product.mainImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.diamond,
                                          color: AppTheme.primaryGold,
                                          size: 30,
                                        );
                                      },
                                    ),
                                  )
                                  : const Icon(
                                    Icons.diamond,
                                    color: AppTheme.primaryGold,
                                    size: 30,
                                  ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category,
                              style: const TextStyle(
                                color: AppTheme.silverGray,
                              ),
                            ),
                            Text(
                              product.price.formatted,
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Stock status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    product.inStock ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                product.inStock ? 'Còn hàng' : 'Hết hàng',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton(
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 8),
                                          Text('Chỉnh sửa'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'stock',
                                      child: Row(
                                        children: [
                                          Icon(Icons.inventory),
                                          SizedBox(width: 8),
                                          Text('Cập nhật kho'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text(
                                            'Xóa',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    _showEditProductDialog(context, product);
                                    break;
                                  case 'stock':
                                    _showUpdateStockDialog(context, product);
                                    break;
                                  case 'delete':
                                    _showDeleteConfirmDialog(context, product);
                                    break;
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () => context.go('/product/${product.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm sản phẩm'),
            content: const Text(
              'Chức năng thêm sản phẩm sẽ được cập nhật trong phiên bản tiếp theo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  void _showEditProductDialog(BuildContext context, product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chỉnh sửa sản phẩm'),
            content: Text(
              'Chỉnh sửa sản phẩm "${product.name}" sẽ được cập nhật trong phiên bản tiếp theo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, product) {
    final stockController = TextEditingController(
      text: product.stock.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cập nhật số lượng'),
            content: TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số lượng trong kho',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  final newStock = int.tryParse(stockController.text);
                  if (newStock != null && newStock >= 0) {
                    final success = await Provider.of<JewelryService>(
                      context,
                      listen: false,
                    ).updateStock(product.id, newStock);

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Cập nhật số lượng thành công'
                                : 'Có lỗi xảy ra',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Cập nhật'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text('Bạn có chắc muốn xóa sản phẩm "${product.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  final success = await Provider.of<JewelryService>(
                    context,
                    listen: false,
                  ).deleteJewelry(product.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success ? 'Xóa sản phẩm thành công' : 'Có lỗi xảy ra',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }
}

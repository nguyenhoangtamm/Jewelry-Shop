import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/jewelry.dart';
import '../providers/jewelry_provider.dart';
import '../utils/app_theme.dart';

// Khai báo danh sách các quốc gia
final List<String> _origins = ['Việt Nam', 'Ý', 'Thụy Sĩ', 'Mỹ', 'Nhật Bản'];

// Biến để lưu giá trị đã chọn
String? _selectedOrigin;
// Danh sách chất liệu và đá quý
final List<String> _materials = ['Vàng 18K', 'Vàng 24K', 'Bạc 925', 'Bạch kim'];
final List<String> _gemstones = [
  'Không có',
  'Kim cương',
  'Ruby',
  'Sapphire',
  'Ngọc trai'
];

// Biến lưu lựa chọn
String? _selectedMaterial;
String? _selectedGemstone;

class AddJewelryScreen extends StatefulWidget {
  final Jewelry? jewelryToEdit;

  const AddJewelryScreen({super.key, this.jewelryToEdit});

  @override
  State<AddJewelryScreen> createState() => _AddJewelryScreenState();
}

class _AddJewelryScreenState extends State<AddJewelryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlsController = TextEditingController();
  final _materialController = TextEditingController();
  final _gemstoneController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _brandController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _originController = TextEditingController();
  final _certificateNumberController = TextEditingController();

  String _selectedCategory = 'Nhẫn';
  bool _isAvailable = true;
  bool _isCertified = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Nhẫn',
    'Dây chuyền',
    'Bông tai',
    'Vòng tay',
    'Lắc tay',
    'Đồng hồ',
    'Mặt dây chuyền',
    'Cài áo',
    'Nhẫn cưới',
    'Trang sức trẻ em',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.jewelryToEdit != null) {
      _populateFormWithExistingJewelry();
    } else {
      _stockQuantityController.text = '1';
      _weightController.text = '0.0';
    }
  }

  void _populateFormWithExistingJewelry() {
    final jewelry = widget.jewelryToEdit!;
    _nameController.text = jewelry.name;
    _descriptionController.text = jewelry.description;
    _priceController.text = jewelry.price.toInt().toString();
    _imageUrlsController.text = jewelry.imageUrls.join('\n');
    _materialController.text = jewelry.material;
    _gemstoneController.text = jewelry.gemstone;
    _sizeController.text = jewelry.size;
    _colorController.text = jewelry.color;
    _brandController.text = jewelry.brand;
    _stockQuantityController.text = jewelry.stockQuantity.toString();
    _weightController.text = jewelry.weight.toString();
    _originController.text = jewelry.origin;
    _certificateNumberController.text = jewelry.certificateNumber ?? '';
    _selectedCategory = jewelry.category;
    _isAvailable = jewelry.isAvailable;
    _isCertified = jewelry.isCertified;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlsController.dispose();
    _materialController.dispose();
    _gemstoneController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    _brandController.dispose();
    _stockQuantityController.dispose();
    _weightController.dispose();
    _originController.dispose();
    _certificateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.jewelryToEdit != null ? 'Sửa trang sức' : 'Thêm trang sức'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              if (_imageUrlsController.text.isNotEmpty) ...[
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlsController.text.split('\n').first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên trang sức *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên trang sức';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price and Stock Quantity
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Giá (VNĐ) *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giá';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Giá không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockQuantityController,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng tồn kho *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số lượng';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Số lượng không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Danh mục *',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMaterial,
                      decoration: const InputDecoration(
                        labelText: 'Chất liệu *',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Chọn chất liệu'),
                      items: _materials.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn chất liệu';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMaterial = newValue;
                          _materialController.text = newValue ?? '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGemstone,
                      decoration: const InputDecoration(
                        labelText: 'Đá quý',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Chọn đá quý'),
                      items: _gemstones.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGemstone = newValue;
                          _gemstoneController.text = newValue ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: const InputDecoration(
                        labelText: 'Kích thước *',
                        border: OutlineInputBorder(),
                        hintText: 'Size 6, 45cm...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập kích thước';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(
                        labelText: 'Màu sắc *',
                        border: OutlineInputBorder(),
                        hintText: 'Vàng, Bạc, Hồng...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập màu sắc';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Brand and Weight
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Thương hiệu *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập thương hiệu';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Trọng lượng (gram)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Trọng lượng không hợp lệ';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedOrigin,
                decoration: const InputDecoration(
                  labelText: 'Xuất xứ',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Chọn xuất xứ'),
                items: _origins.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOrigin = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Image URLs
              TextFormField(
                controller: _imageUrlsController,
                decoration: const InputDecoration(
                  labelText: 'URL hình ảnh (mỗi dòng một URL) *',
                  border: OutlineInputBorder(),
                  hintText:
                      'https://example.com/image1.jpg\nhttps://example.com/image2.jpg',
                ),
                maxLines: 3,
                onChanged: (value) {
                  setState(() {}); // Rebuild to show image preview
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ít nhất một URL hình ảnh';
                  }
                  final urls =
                      value.split('\n').where((url) => url.trim().isNotEmpty);
                  for (final url in urls) {
                    if (!Uri.tryParse(url.trim())!.isAbsolute) {
                      return 'URL không hợp lệ: ${url.trim()}';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Certificate Number (if certified)
              if (_isCertified) ...[
                TextFormField(
                  controller: _certificateNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Số chứng nhận',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Availability and Certification
              CheckboxListTile(
                title: const Text('Trang sức có sẵn'),
                subtitle: const Text('Khách hàng có thể mua sản phẩm này'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              CheckboxListTile(
                title: const Text('Có chứng nhận'),
                subtitle: const Text('Sản phẩm có giấy chứng nhận chất lượng'),
                value: _isCertified,
                onChanged: (value) {
                  setState(() {
                    _isCertified = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 24),

              // Sample Image URLs
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'URL hình ảnh mẫu:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...[
                      'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
                      'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=400',
                      'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400',
                      'https://images.unsplash.com/photo-1596944924616-7b38e7cfac36?w=400',
                    ].map((url) {
                      return GestureDetector(
                        onTap: () {
                          if (_imageUrlsController.text.isEmpty) {
                            _imageUrlsController.text = url;
                          } else {
                            _imageUrlsController.text += '\n$url';
                          }
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue[300]!),
                          ),
                          child: Text(
                            url,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveJewelry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Đang lưu...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.jewelryToEdit != null
                              ? 'Cập nhật trang sức'
                              : 'Thêm trang sức',
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
      ),
    );
  }

  Future<void> _saveJewelry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final imageUrls = _imageUrlsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final jewelry = Jewelry(
        id: widget.jewelryToEdit?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrls: imageUrls,
        category: _selectedCategory,
        rating: widget.jewelryToEdit?.rating ?? 0.0,
        reviewCount: widget.jewelryToEdit?.reviewCount ?? 0,
        material: _materialController.text,
        gemstone: _gemstoneController.text,
        size: _sizeController.text,
        color: _colorController.text,
        brand: _brandController.text,
        isAvailable: _isAvailable,
        stockQuantity: int.parse(_stockQuantityController.text),
        weight: double.tryParse(_weightController.text) ?? 0.0,
        origin: _originController.text,
        isCertified: _isCertified,
        certificateNumber:
            _isCertified && _certificateNumberController.text.isNotEmpty
                ? _certificateNumberController.text
                : null,
      );

      final jewelryProvider = context.read<JewelryProvider>();

      if (widget.jewelryToEdit != null) {
        jewelryProvider.updateJewelry(jewelry);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${jewelry.name} đã được cập nhật'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } else {
        jewelryProvider.addJewelry(jewelry);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${jewelry.name} đã được thêm'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

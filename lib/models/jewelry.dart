import 'dart:convert';

import 'base_model.dart';

class Jewelry extends BaseModel {
  String name;
  String description;
  double price;
  double? originalPrice;
  String category;
  String material;
  List<String> images;
  int stock;
  bool isAvailable;
  double rating;
  int reviewCount;
  Map<String, dynamic>? specifications;

  Jewelry({
    required super.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.material,
    required this.images,
    required this.stock,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.specifications,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  @override
  String get tableName => 'jewelries';

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  bool get inStock => stock > 0 && isAvailable;

  String get mainImage => images.isNotEmpty ? images.first : '';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'material': material,
      'images': images,
      'stock': stock,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'specifications': specifications,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  static Jewelry fromJson(Map<String, dynamic> json) {
    return Jewelry(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      category: json['category'],
      material: json['material'],
      images: json['images'] is String
          ? List<String>.from(jsonDecode(json['images']))
          : (json['images'] is List && json['images'].isNotEmpty && json['images'][0] is List
          ? List<String>.from(json['images'][0])
          : List<String>.from(json['images'])),

      stock: json['stock'],
      isAvailable: json['isAvailable'] == true || json['isAvailable'] == 1,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      specifications: json['specifications'] != null
          ? (json['specifications'] is String
          ? jsonDecode(json['specifications']) as Map<String, dynamic>
          : Map<String, dynamic>.from(json['specifications']))
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isDeleted:
      json['isDeleted'] == true || json['isDeleted'] == 1,
    );
  }

  Jewelry copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? category,
    String? material,
    List<String>? images,
    int? stock,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Jewelry(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      material: material ?? this.material,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

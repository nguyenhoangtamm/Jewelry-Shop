import 'dart:convert';

import 'package:jewelry_management_app/models/base_model.dart';

class Jewelry extends BaseModel {
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int reviewCount;
  final String material;
  final String gemstone;
  final String size;
  final String color;
  final String brand;
  final bool isAvailable;
  final int stockQuantity;
  final double weight; // in grams
  final String origin;
  final bool isCertified;
  final String? certificateNumber;

  Jewelry({
    required super.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.material,
    this.gemstone = '',
    required this.size,
    required this.color,
    required this.brand,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.weight = 0.0,
    this.origin = '',
    this.isCertified = false,
    this.certificateNumber,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });
  @override
  String get tableName => 'jewelries';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'material': material,
      'gemstone': gemstone,
      'size': size,
      'color': color,
      'brand': brand,
      'isAvailable': isAvailable ? 1 : 0, // convert bool to int
      'stockQuantity': stockQuantity,
      'weight': weight,
      'origin': origin,
      'isCertified': isCertified ? 1 : 0, // convert bool to int
      'certificateNumber': certificateNumber,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0, // convert bool to int
    };
  }

  static Jewelry fromJson(Map<String, dynamic> json) {
    return Jewelry(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrls: json['imageUrls'] is String
          ? List<String>.from(jsonDecode(json['imageUrls']))
          : (json['imageUrls'] is List &&
                  json['imageUrls'].isNotEmpty &&
                  json['imageUrls'][0] is List
              ? List<String>.from(json['imageUrls'][0])
              : List<String>.from(json['imageUrls'])),
      category: json['category'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      material: json['material'],
      gemstone: json['gemstone'] ?? '',
      size: json['size'],
      color: json['color'],
      brand: json['brand'],
      isAvailable: json['isAvailable'] == 1, // convert int to bool
      stockQuantity: json['stockQuantity'] ?? 0,
      weight: json['weight']?.toDouble() ?? 0.0,
      origin: json['origin'] ?? '',
      isCertified: json['isCertified'] == 1, // convert int to bool
      certificateNumber: json['certificateNumber'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] == 1, // convert int to bool
    );
  }

  Jewelry copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? imageUrls,
    String? category,
    double? rating,
    int? reviewCount,
    String? material,
    String? gemstone,
    String? size,
    String? color,
    String? brand,
    bool? isAvailable,
    int? stockQuantity,
    double? weight,
    String? origin,
    bool? isCertified,
    String? certificateNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Jewelry(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      material: material ?? this.material,
      gemstone: gemstone ?? this.gemstone,
      size: size ?? this.size,
      color: color ?? this.color,
      brand: brand ?? this.brand,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      weight: weight ?? this.weight,
      origin: origin ?? this.origin,
      isCertified: isCertified ?? this.isCertified,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

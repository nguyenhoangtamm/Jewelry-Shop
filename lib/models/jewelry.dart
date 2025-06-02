class Jewelry {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final String material;
  final List<String> images;
  final int stock;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final Map<String, dynamic>? specifications;

  Jewelry({
    required this.id,
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
    required this.createdAt,
    this.specifications,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  bool get inStock => stock > 0 && isAvailable;
  String get mainImage => images.isNotEmpty ? images.first : '';

  factory Jewelry.fromJson(Map<String, dynamic> json) {
    return Jewelry(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      originalPrice:
          json['originalPrice'] != null
              ? (json['originalPrice'] as num).toDouble()
              : null,
      category: json['category'],
      material: json['material'],
      images: List<String>.from(json['images']),
      stock: json['stock'],
      isAvailable: json['isAvailable'] ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      specifications: json['specifications'],
    );
  }

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
      'createdAt': createdAt.toIso8601String(),
      'specifications': specifications,
    };
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
    DateTime? createdAt,
    Map<String, dynamic>? specifications,
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
      createdAt: createdAt ?? this.createdAt,
      specifications: specifications ?? this.specifications,
    );
  }
}

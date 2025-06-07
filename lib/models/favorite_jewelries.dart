import 'dart:convert';

import 'base_model.dart';

class FavoriteJewelry extends BaseModel {
  final String jewelryId;
  final String userId;
  final DateTime addedAt;

  FavoriteJewelry({
    required super.id,
    required this.jewelryId,
    required this.userId,
    required this.addedAt,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });
  @override
  String get tableName => 'favorite_jewelries';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jewelryId': jewelryId,
      'userId': userId,
      'addedAt': addedAt.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  static FavoriteJewelry fromJson(Map<String, dynamic> json) {
    return FavoriteJewelry(
      id: json['id'],
      jewelryId: json['jewelryId'],
      userId: json['userId'],
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),

      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isDeleted: json['isDeleted'] == 1, // convert int to bool
    );
  }

  FavoriteJewelry copyWith({
    String? id,
    String? jewelryId,
    String? userId,
    DateTime? addedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return FavoriteJewelry(
      id: id ?? this.id,
      jewelryId: jewelryId ?? this.jewelryId,
      userId: userId ?? this.userId,
      addedAt: addedAt ?? this.addedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

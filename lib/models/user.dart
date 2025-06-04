import 'base_model.dart';

class User extends BaseModel {
  String name;
  int? gender; // 1 là nam, 2 là nữ
  String email;
  bool isAdmin;// 1 là true, 0 là false
  String password;
  String? phone;
  DateTime? dateOfBirth;
  String? address;
  String? avatar;
  bool isActive = true;// 1 là true, 0 là false
  User({
    required super.id,
    required this.name,
    required this.email,
    required this.password,
    this.gender,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.avatar,
    this.isAdmin = false,
    this.isActive = true,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });
  @override
  String get tableName => 'users';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender':gender,
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      isAdmin: (json['isAdmin'] == 1 || json['isAdmin'] == true),   // convert int->bool
      isActive: (json['isActive'] == 1 || json['isActive'] == true),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      avatar: json['avatar'],
      isDeleted: (json['isDeleted'] == 1 || json['isDeleted'] == true),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    bool? isAdmin,
    String? avatar,
    DateTime? createdAt,
    bool? isActive,
    DateTime? updatedAt,
    bool? isDeleted,
    String? password,
    int? gender,
    DateTime? dateOfBirth,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isAdmin: isAdmin ?? this.isAdmin,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
    );
  }

}

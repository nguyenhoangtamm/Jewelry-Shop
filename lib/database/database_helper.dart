import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:jewelry_management_app/models/cart_item.dart';
import 'package:jewelry_management_app/models/jewelry.dart';
import 'package:jewelry_management_app/models/order.dart';
import 'package:jewelry_management_app/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jewelry_management_app/database/data.dart';

import 'package:jewelry_management_app/models/base_model.dart';

class DatabaseHelper {
  static Database? _database;
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "app_database.db");

    // Đảm bảo đóng database trước khi xóa
    try {
      await _database?.close();
    } catch (_) {}

    // XÓA database cũ nếu tồn tại
    if (await File(path).exists()) {
      await File(path).delete();
    }

    // Copy lại file database từ assets
    ByteData data = await rootBundle.load("assets/db/app_database.db");
    List<int> bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes, flush: true);

    return await openDatabase(path);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  fullName TEXT NOT NULL,
  gender INTEGER,
  email TEXT NOT NULL,
  password TEXT NOT NULL,
  isAdmin INTEGER DEFAULT 0,
  isActive INTEGER DEFAULT 1,
  phone TEXT,
  dateOfBirth TEXT,
  address TEXT,
  avatar TEXT,
  createdAt TEXT,
  updatedAt TEXT,
  isDeleted INTEGER DEFAULT 0
);
      CREATE TABLE jewelries (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  price REAL NOT NULL,
  imageUrls TEXT, -- Lưu dạng JSON string
  category TEXT NOT NULL,
  rating REAL DEFAULT 0.0,
  reviewCount INTEGER DEFAULT 0,
  material TEXT NOT NULL,
  gemstone TEXT,
  size TEXT NOT NULL,
  color TEXT NOT NULL,
  brand TEXT NOT NULL,
  isAvailable INTEGER DEFAULT 1,
  stockQuantity INTEGER DEFAULT 0,
  weight REAL DEFAULT 0.0,
  origin TEXT,
  isCertified INTEGER DEFAULT 0,
  certificateNumber TEXT,
  createdAt TEXT,
  updatedAt TEXT,
  isDeleted INTEGER DEFAULT 0
);
    CREATE TABLE orders(
      id TEXT PRIMARY KEY,
      userId TEXT,
      subtotal REAL,
      shippingFee REAL,
      discount REAL,
      total REAL,
      status TEXT,
      shippingAddress TEXT,
      notes TEXT,
      createdAt TEXT,
      updatedAt TEXT,
      trackingNumber TEXT,
      isDeleted INTEGER,
      FOREIGN KEY(userId) REFERENCES users(id)
      );
      CREATE TABLE cart_items (
        id TEXT PRIMARY KEY,
        jewelryId TEXT NOT NULL, 
        quantity INTEGER NOT NULL,
        addedAt TEXT NOT NULL,
        createdAt TEXT,
        updatedAt TEXT,
        isDeleted INTEGER NOT NULL DEFAULT 0
      );
       CREATE TABLE order_details (
    id TEXT PRIMARY KEY,
    orderId TEXT NOT NULL,
    jewelryId TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price REAL NOT NULL,
    addedAt TEXT,
    createdAt TEXT,
    updatedAt TEXT,
    isDeleted INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(orderId) REFERENCES orders(id),
    FOREIGN KEY(jewelryId) REFERENCES jewelries(id)
  );
CREATE TABLE favorite_jewelries (
  id TEXT PRIMARY KEY,
  jewelryId TEXT NOT NULL,
  userId TEXT NOT NULL,
  addedAt TEXT NOT NULL,
  createdAt TEXT,
  updatedAt TEXT,
  isDeleted INTEGER DEFAULT 0,
  FOREIGN KEY(jewelryId) REFERENCES jewelries(id),
  FOREIGN KEY(userId) REFERENCES users(id)
);

    ''');

    // Chèn dữ liệu
    for (final user in users) {
      await db.insert('users', user.toJson());
    }
    // Bạn có thể thêm các bảng khác ở đây
    for (final jewelry in jewelries) {
      await db.insert('jewelries', jewelry.toJson());
    }
    // Thêm dữ liệu mẫu cho bảng orders

// Dữ liệu mẫu cho bảng order_details (mỗi sản phẩm 1 dòng)

// Chèn dữ liệu vào bảng orders
    for (final order in orders) {
      await db.insert('orders', order.toJson());
    }

// Chèn dữ liệu vào bảng order_details
    for (final detail in orderDetails) {
      await db.insert('order_details', detail);
    }
// favorite_jewelries
    for (final favorite in favoriteJewelries) {
      await db.insert('favorite_jewelries', favorite);
    }
  }
}

// Generic DB helper dùng cho từng bảng, model cụ thể
class GenericDbHelper<T extends BaseModel> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromJson;

  GenericDbHelper(this.tableName, this.fromJson);

  Future<List<T>> getAll() async {
    final db = await DatabaseHelper.database;
    final result = await db.query(tableName);
    return result.map((e) => fromJson(e)).toList();
  }

  Future<T?> getById(String id) async {
    final db = await DatabaseHelper.database;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return fromJson(result.first);
    }
    return null;
  }

  Future<int> insert(T model) async {
    final db = await DatabaseHelper.database;
    return await db.insert(tableName, model.toJson());
  }

  Future<int> update(T model) async {
    final db = await DatabaseHelper.database;
    return await db.update(tableName, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<T>> getByForeignKey(String foreignKey, dynamic value) async {
    final db = await DatabaseHelper.database;
    final result =
        await db.query(tableName, where: '$foreignKey = ?', whereArgs: [value]);
    return result.map((e) => fromJson(e)).toList();
  }
}

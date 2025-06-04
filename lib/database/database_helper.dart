import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:jewelry_management_app/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

    // if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load("assets/db/app_database.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    // }
    return await openDatabase(
      path,
      // version: 1,
      // onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender INTEGER,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        isAdmin INTEGER NOT NULL DEFAULT 0,
        isActive INTEGER NOT NULL DEFAULT 1,
        phone TEXT,
        dateOfBirth TEXT,
        address TEXT,
        avatar TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        isDeleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
    final users = [
      User(
        id: "1",
        email: 'admin@jewelry.com',
        name: 'Admin User',
        phone: '0123456789',
        password: 'admin123', // có thể hash nếu muốn
        gender: 1,
        address: '123 Main St',
        avatar: null,
        isAdmin: true,
        isActive: true,
        isDeleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: null,
        dateOfBirth: DateTime(1990, 1, 1),
      ),
      User(
        id: '2',
        email: 'user@jewelry.com',
        name: 'Normal User',
        phone: '0987654321',
        password: 'user123',
        gender: 2,
        address: '456 Other St',
        avatar: null,
        isAdmin: false,
        isActive: true,
        isDeleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: null,
        dateOfBirth: DateTime(1995, 5, 10),
      ),
    ];

    // Chèn dữ liệu
    for (final user in users) {
      await db.insert('users', user.toJson());
    }
    // Bạn có thể thêm các bảng khác ở đây
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

  Future<T?> getById(int id) async {
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
    return await db.update(tableName, model.toJson(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

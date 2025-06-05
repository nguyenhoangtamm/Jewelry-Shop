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
        id TEXT PRIMARY KEY,
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
      );
      CREATE TABLE jewelries (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      price REAL NOT NULL,
      originalPrice REAL,
      category TEXT NOT NULL,
      material TEXT NOT NULL,
      images TEXT NOT NULL, -- lưu dạng JSON string
      stock INTEGER NOT NULL,
      isAvailable INTEGER NOT NULL DEFAULT 1,
      rating REAL NOT NULL DEFAULT 0.0,
      reviewCount INTEGER NOT NULL DEFAULT 0,
      specifications TEXT, -- lưu dạng JSON string
      createdAt TEXT,
      updatedAt TEXT,
      isDeleted INTEGER NOT NULL DEFAULT 0
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
    final jewelries = [
      Jewelry(
        id: '1',
        name: 'Bộ trang sức Sapphire',
        description:
            'Bộ trang sức sang trọng với đá Sapphire xanh tự nhiên, thiết kế tinh tế và đẳng cấp.',
        price: 25000000,
        originalPrice: 30000000,
        category: 'Bộ trang sức',
        material: 'Vàng 18K',
        images: ['assets/images/jewelry/sapphire_set.jpg'],
        stock: 5,
        rating: 4.8,
        reviewCount: 24,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        specifications: {
          'Kích thước': 'Điều chỉnh được',
          'Trọng lượng': '15g',
          'Đá chính': 'Sapphire tự nhiên',
          'Đá phụ': 'Kim cương nhân tạo',
        },
      ),
      Jewelry(
        id: '2',
        name: 'Bộ trang sức Kim cương',
        description:
            'Bộ trang sức cao cấp với kim cương và đá CZ, ánh sáng lung linh.',
        price: 45000000,
        originalPrice: 50000000,
        category: 'Bộ trang sức',
        material: 'Bạch kim',
        images: ['assets/images/jewelry/diamond_set.jpg'],
        stock: 3,
        rating: 5.0,
        reviewCount: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        specifications: {
          'Kích thước': 'Điều chỉnh được',
          'Trọng lượng': '20g',
          'Đá chính': 'Kim cương',
          'Chất liệu': 'Bạch kim 950',
        },
      ),
      Jewelry(
        id: '3',
        name: 'Bộ trang sức Emerald vàng',
        description:
            'Bộ trang sức 5 món bao gồm đồng hồ, vòng tay, nhẫn, bông tai và dây chuyền.',
        price: 35000000,
        category: 'Bộ trang sức',
        material: 'Vàng 18K',
        images: ['assets/images/jewelry/emerald_set.webp'],
        stock: 7,
        rating: 4.5,
        reviewCount: 32,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        specifications: {
          'Số món': '5 món',
          'Trọng lượng': '35g',
          'Đá chính': 'Emerald',
          'Phụ kiện': 'Đồng hồ Geneva',
        },
      ),
      Jewelry(
        id: '4',
        name: 'Nhẫn kim cương solitaire',
        description:
            'Nhẫn kim cương đơn giản, thanh lịch phù hợp cho lễ đính hôn.',
        price: 15000000,
        originalPrice: 18000000,
        category: 'Nhẫn',
        material: 'Vàng trắng 18K',
        images: [
          'assets/images/jewelry/sapphire_set.jpg',
        ], // Using available image
        stock: 10,
        rating: 4.9,
        reviewCount: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        specifications: {
          'Kích thước': '6-8 (có thể điều chỉnh)',
          'Trọng lượng': '3.5g',
          'Kim cương': '1 carat',
          'Độ tinh khiết': 'VS1',
        },
      ),
      Jewelry(
        id: '5',
        name: 'Dây chuyền bạc 925',
        description:
            'Dây chuyền bạc cao cấp với mặt hình trái tim, thích hợp làm quà tặng.',
        price: 2500000,
        category: 'Dây chuyền',
        material: 'Bạc 925',
        images: [
          'assets/images/jewelry/diamond_set.jpg',
        ], // Using available image
        stock: 20,
        rating: 4.3,
        reviewCount: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        specifications: {
          'Chiều dài': '45cm',
          'Trọng lượng': '8g',
          'Mặt dây': 'Hình trái tim',
          'Khóa': 'Khóa tôm bấm',
        },
      ),
      Jewelry(
        id: '6',
        name: 'Bông tai ngọc trai',
        description:
            'Bông tai ngọc trai Akoya tự nhiên, kiểu dáng cổ điển và sang trọng.',
        price: 8500000,
        category: 'Bông tai',
        material: 'Vàng 14K',
        images: [
          'assets/images/jewelry/emerald_set.webp',
        ], // Using available image
        stock: 15,
        rating: 4.7,
        reviewCount: 28,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        specifications: {
          'Kích thước ngọc trai': '8-9mm',
          'Loại ngọc trai': 'Akoya tự nhiên',
          'Màu sắc': 'Trắng kem',
          'Kiểu khóa': 'Khóa bấm',
        },
      ),
      Jewelry(
        id: '7',
        name: 'Lắc tay vàng trắng',
        description:
            'Lắc tay vàng trắng với họa tiết hoa văn tinh xảo, phù hợp mọi lứa tuổi.',
        price: 12000000,
        originalPrice: 14000000,
        category: 'Lắc tay',
        material: 'Vàng trắng 18K',
        images: [
          'assets/images/jewelry/sapphire_set.jpg',
        ], // Using available image
        stock: 8,
        rating: 4.6,
        reviewCount: 19,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        specifications: {
          'Chiều dài': '18cm',
          'Trọng lượng': '12g',
          'Họa tiết': 'Hoa văn cổ điển',
          'Khóa': 'Khóa an toàn',
        },
      ),
      Jewelry(
        id: '8',
        name: 'Đồng hồ nữ Diamond',
        description:
            'Đồng hồ nữ cao cấp với viền kim cương, mặt số mother of pearl.',
        price: 28000000,
        category: 'Đồng hồ',
        material: 'Vàng 18K',
        images: [
          'assets/images/jewelry/emerald_set.webp',
        ], // Using available image
        stock: 4,
        rating: 4.8,
        reviewCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        specifications: {
          'Đường kính mặt': '32mm',
          'Chống nước': '50m',
          'Máy': 'Quartz Nhật Bản',
          'Mặt số': 'Mother of Pearl',
        },
      ),
    ];
    for (final jewelry in jewelries) {
      await db.insert('jewelries', jewelry.toJson());
    }
    // Thêm dữ liệu mẫu cho bảng orders
    final orders = [
      Order(
        id: 'DH001',
        userId: 'user_01',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        total: 150000,
        subtotal: 130000,
        shippingFee: 20000,
        discount: 0,
        shippingAddress: '123 Đường Lê Duẫn, Quận 1, Tp.HCM ',
        status: OrderStatus.pending,
        trackingNumber: null,
      ),
      Order(
        id: 'DH002',
        userId: 'user_02',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        total: 300000,
        subtotal: 280000,
        shippingFee: 20000,
        discount: 0,
        shippingAddress: '456 Đường Nguyễn Đình Chiểu, Quận 3, Tp.HCM ',
        status: OrderStatus.delivered,
        trackingNumber: 'TRACK12345',
      ),
      Order(
        id: 'DH003',
        userId: 'user_03',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        total: 500000,
        subtotal: 480000,
        shippingFee: 20000,
        discount: 0,
        shippingAddress:
            'Đường Phạm Hữu Lầu, Phường 6, Tp.Cao Lãnh, Tỉnh Đồng Tháp ',
        status: OrderStatus.shipping,
        trackingNumber: 'TRACK67890',
      ),
    ];

// Dữ liệu mẫu cho bảng order_details (mỗi sản phẩm 1 dòng)
    final orderDetails = [
      // Đơn hàng DH001
      {
        'id': 'od001',
        'orderId': 'DH001',
        'jewelryId': '1',
        'quantity': 1,
        'price': 130000,
        'addedAt':
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'createdAt':
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'isDeleted': 0,
      },
      // Đơn hàng DH002
      {
        'id': 'od002',
        'orderId': 'DH002',
        'jewelryId': '2',
        'quantity': 2,
        'price': 140000,
        'addedAt':
            DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
        'createdAt':
            DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
        'isDeleted': 0,
      },
      // Đơn hàng DH003
      {
        'id': 'od003',
        'orderId': 'DH003',
        'jewelryId': '3',
        'quantity': 1,
        'price': 480000,
        'addedAt':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'createdAt':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'isDeleted': 0,
      },
    ];

// Chèn dữ liệu vào bảng orders
    for (final order in orders) {
      await db.insert('orders', order.toJson());
    }

// Chèn dữ liệu vào bảng order_details
    for (final detail in orderDetails) {
      await db.insert('order_details', detail);
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
    final result = await db.query(tableName, where: '$foreignKey = ?', whereArgs: [value]);
    return result.map((e) => fromJson(e)).toList();
  }
}

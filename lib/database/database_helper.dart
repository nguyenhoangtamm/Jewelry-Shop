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
    ''');
    final users = [
      User(
        id: '1',
        username: 'johndoe',
        fullName: 'John Doe',
        gender: 1,
        email: 'johndoe@example.com',
        password: 'hashed_password_here',
        isAdmin: false,
        isActive: true,
        phone: '0123456789',
        dateOfBirth: DateTime.parse('2000-01-01T00:00:00.000'),
        address: 'Hà Nội',
        avatar: null,
        createdAt: DateTime.parse('2024-06-06T12:00:00.000'),
        updatedAt: null,
        isDeleted: true,
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
      name: 'Nhẫn Vàng 18K Đính Kim Cương',
      description:
          'Nhẫn vàng 18K với kim cương tự nhiên 0.5 carat, thiết kế tinh tế, phù hợp cho lễ đính hôn và cưới hỏi',
      price: 25000000,
      imageUrls: [
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600&h=400&fit=crop',
        'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600&h=400&fit=crop',
      ],
      category: 'Nhẫn',
      rating: 4.9,
      reviewCount: 127,
      material: 'Vàng 18K',
      gemstone: 'Kim cương',
      size: '16',
      color: 'Vàng',
      brand: 'Diamond Palace',
      stockQuantity: 5,
      weight: 3.2,
      origin: 'Việt Nam',
      isCertified: true,
      certificateNumber: 'GIA-2023-001',
    ),
    Jewelry(
      id: '2',
      name: 'Dây Chuyền Bạc Ý 925',
      description:
          'Dây chuyền bạc Ý 925 cao cấp, thiết kế cổ điển, phù hợp cho cả nam và nữ',
      price: 1500000,
      imageUrls: [
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&h=400&fit=crop',
      ],
      category: 'Dây chuyền',
      rating: 4.6,
      reviewCount: 89,
      material: 'Bạc 925',
      size: '50cm',
      color: 'Bạc',
      brand: 'Silver Star',
      stockQuantity: 15,
      weight: 12.5,
      origin: 'Ý',
      isCertified: false,
    ),
    Jewelry(
      id: '3',
      name: 'Bông Tai Ngọc Trai Akoya',
      description:
          'Bông tai ngọc trai Akoya tự nhiên từ Nhật Bản, kích thước 8-9mm, ánh sáng tuyệt đẹp',
      price: 8500000,
      imageUrls: [
        'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=600&h=400&fit=crop',
      ],
      category: 'Bông tai',
      rating: 4.8,
      reviewCount: 156,
      material: 'Vàng trắng 14K',
      gemstone: 'Ngọc trai Akoya',
      size: '8-9mm',
      color: 'Trắng',
      brand: 'Pearl Beauty',
      stockQuantity: 8,
      weight: 2.1,
      origin: 'Nhật Bản',
      isCertified: true,
      certificateNumber: 'PEARL-2023-002',
    ),
    Jewelry(
      id: '4',
      name: 'Lắc Tay Vàng Hồng 10K',
      description:
          'Lắc tay vàng hồng 10K trẻ trung, thiết kế hiện đại, phù hợp cho phái nữ',
      price: 4200000,
      imageUrls: [
        'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=600&h=400&fit=crop',
      ],
      category: 'Lắc tay',
      rating: 4.5,
      reviewCount: 203,
      material: 'Vàng hồng 10K',
      size: '18cm',
      color: 'Vàng hồng',
      brand: 'Rose Gold',
      stockQuantity: 12,
      weight: 8.7,
      origin: 'Hàn Quốc',
      isCertified: false,
    ),
    Jewelry(
      id: '5',
      name: 'Đồng Hồ Rolex Submariner',
      description:
          'Đồng hồ Rolex Submariner thép không gỉ, chống nước 300m, máy cơ tự động',
      price: 280000000,
      imageUrls: [
        'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=600&h=400&fit=crop',
      ],
      category: 'Đồng hồ',
      rating: 5.0,
      reviewCount: 45,
      material: 'Thép không gỉ',
      size: '40mm',
      color: 'Đen',
      brand: 'Rolex',
      stockQuantity: 2,
      weight: 155.0,
      origin: 'Thụy Sĩ',
      isCertified: true,
      certificateNumber: 'ROLEX-2023-003',
    ),
    Jewelry(
      id: '6',
      name: 'Vòng tay trẻ em bạc PNJSilver 0000K000058',
      description:
          'Vòng tay bạc PNJSilver dành cho trẻ em với thiết kế tinh tế, chất liệu bạc cao cấp an toàn cho bé, mang lại vẻ ngoài đáng yêu và sang trọng.',
      price: 650000,
      imageUrls: [
        'https://cdn.pnj.io/images/thumbnails/485/485/detailed/137/sv0000k000058-vong-tay-tre-em-bac-pnjsilver-1.png',
      ],
      category: 'Vòng tay trẻ em',
      rating: 4.8,
      reviewCount: 112,
      material: 'Bạc S925',
      size: '13cm',
      color: 'Bạc',
      brand: 'PNJSilver',
      stockQuantity: 20,
      weight: 4.5,
      origin: 'Việt Nam',
      isCertified: true,
      certificateNumber: 'SILVER-2025-006',
    ),
    Jewelry(
      id: '7',
      name: 'Cặp nhẫn cưới Vàng 18K đính đá ECZ PNJ Chung Đôi 00878-00877',
      description:
          'Nhẫn cưới đôi vàng trắng 18K, thiết kế đơn giản thanh lịch, khắc tên miễn phí',
      price: 18000000,
      imageUrls: [
        'https://cdn.pnj.io/images/thumbnails/485/485/detailed/248/sp-gnxm00y000878-gnxm00y000877-cap-nhan-cuoi-vang-18k-dinh-da-ecz-pnj-chung-doi-1.png',
      ],
      category: 'Nhẫn',
      rating: 4.9,
      reviewCount: 234,
      material: 'Vàng trắng 18K',
      size: 'Đôi 16-18',
      color: 'Trắng',
      brand: 'Wedding Ring',
      stockQuantity: 10,
      weight: 7.5,
      origin: 'Việt Nam',
      isCertified: false,
    ),
    Jewelry(
      id: '8',
      name: 'Vòng Cổ Ngọc Bích Tự Nhiên',
      description:
          'Vòng cổ ngọc bích tự nhiên từ Myanmar, màu xanh đậm, chất lượng cao',
      price: 35000000,
      imageUrls: [
        'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600&h=400&fit=crop',
      ],
      category: 'Vòng cổ',
      rating: 4.8,
      reviewCount: 67,
      material: 'Ngọc bích',
      gemstone: 'Ngọc bích',
      size: '55cm',
      color: 'Xanh',
      brand: 'Jade Master',
      stockQuantity: 3,
      weight: 45.0,
      origin: 'Myanmar',
      isCertified: true,
      certificateNumber: 'JADE-2023-005',
    ),
    Jewelry(
      id: '9',
      name: 'Cặp Nhẫn Đôi Titan',
      description:
          'Cặp nhẫn đôi titan không gỉ, thiết kế thể thao, phù hợp cho các cặp đôi trẻ',
      price: 2500000,
      imageUrls: [
        'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?w=600&h=400&fit=crop',
      ],
      category: 'Nhẫn',
      rating: 4.4,
      reviewCount: 145,
      material: 'Titan',
      size: 'Đôi 17-19',
      color: 'Xám',
      brand: 'Titan Sport',
      stockQuantity: 20,
      weight: 4.2,
      origin: 'Hàn Quốc',
      isCertified: false,
    ),
    Jewelry(
      id: '10',
      name: 'Bộ Trang Sức Cưới Hoàn Chỉnh',
      description:
          'Bộ trang sức cưới hoàn chỉnh gồm nhẫn, bông tai, dây chuyền vàng 18K đính kim cương',
      price: 85000000,
      imageUrls: [
        'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600&h=400&fit=crop',
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600&h=400&fit=crop',
      ],
      category: 'Bộ trang sức',
      rating: 5.0,
      reviewCount: 28,
      material: 'Vàng 18K',
      gemstone: 'Kim cương',
      size: 'Bộ hoàn chỉnh',
      color: 'Vàng',
      brand: 'Luxury Set',
      stockQuantity: 2,
      weight: 25.8,
      origin: 'Việt Nam',
      isCertified: true,
      certificateNumber: 'SET-2023-006',
    ),
  ];
    for (final jewelry in jewelries) {
      await db.insert('jewelries', jewelry.toJson());
    }
    // Thêm dữ liệu mẫu cho bảng orders
    final orders = [
      Order(
      id: 'DH001',
      items: [],
      totalAmount: 150000,
      status: OrderStatus.pending,
      orderTime: DateTime.now().subtract(const Duration(days: 2)),
      customerName: 'Nguyễn Văn A',
      customerPhone: '0123456789',
      customerEmail: 'user01@example.com',
      deliveryAddress: '123 Đường Lê Duẫn, Quận 1, Tp.HCM',
      giftMessage: null,
      deliveryFee: 20000,
      discount: 0,
      paymentMethod: PaymentMethod.cash,
      trackingNumber: null,
      estimatedDeliveryDate: DateTime.now().add(const Duration(days: 3)),
      isGift: false,
      insuranceFee: 0,
      ),
      Order(
      id: 'DH002',
      items: [],
      totalAmount: 300000,
      status: OrderStatus.delivered,
      orderTime: DateTime.now().subtract(const Duration(days: 5)),
      customerName: 'Trần Thị B',
      customerPhone: '0987654321',
      customerEmail: 'user02@example.com',
      deliveryAddress: '456 Đường Nguyễn Đình Chiểu, Quận 3, Tp.HCM',
      giftMessage: 'Chúc mừng sinh nhật!',
      deliveryFee: 20000,
      discount: 0,
      paymentMethod: PaymentMethod.bankTransfer,
      trackingNumber: 'TRACK12345',
      estimatedDeliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      isGift: true,
      insuranceFee: 10000,
      ),
      Order(
      id: 'DH003',
      items: [],
      totalAmount: 500000,
      status: OrderStatus.processing,
      orderTime: DateTime.now().subtract(const Duration(days: 1)),
      customerName: 'Lê Văn C',
      customerPhone: '0912345678',
      customerEmail: 'user03@example.com',
      deliveryAddress: 'Đường Phạm Hữu Lầu, Phường 6, Tp.Cao Lãnh, Tỉnh Đồng Tháp',
      giftMessage: null,
      deliveryFee: 20000,
      discount: 0,
      paymentMethod: PaymentMethod.creditCard,
      trackingNumber: 'TRACK67890',
      estimatedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
      isGift: false,
      insuranceFee: 5000,
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
    final result =
        await db.query(tableName, where: '$foreignKey = ?', whereArgs: [value]);
    return result.map((e) => fromJson(e)).toList();
  }
}

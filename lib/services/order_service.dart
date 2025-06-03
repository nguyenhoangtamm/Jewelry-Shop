import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/jewelry.dart';

class OrderService {
  static List<Order> getDemoOrders() {
    return [
      Order(
        id: 'DH001',
        userId: 'user_01',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        total: 150000,
        subtotal: 130000,
        shippingFee: 20000,
        discount: 0,
        items: [
          CartItem(
            id: 'ci001',
            jewelry: Jewelry(
              id: 'j001',
              name: 'Vòng tay bạc',
              price: 130000,
              description: '',
              category: '',
              material: '',
              images: [],
              stock: 10, // không null
              createdAt: DateTime.now().subtract(const Duration(days: 30)), // không null
            ),
            quantity: 1,
            addedAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ],
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
        items: [
          CartItem(
            id: 'ci002',
            jewelry: Jewelry(
              id: 'j002',
              name: 'Nhẫn vàng 18k',
              price: 140000,
              description: '',
              category: '',
              material: '',
              images: [],
              stock: 5,
              createdAt: DateTime.now().subtract(const Duration(days: 40)),
            ),
            quantity: 2,
            addedAt: DateTime.now().subtract(const Duration(days: 6)),
          ),
        ],
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
        items: [
          CartItem(
            id: 'ci003',
            jewelry: Jewelry(
              id: 'j003',
              name: 'Dây chuyền đá quý',
              price: 480000,
              description: '',
              category: '',
              material: '',
              images: [],
              stock: 8,
              createdAt: DateTime.now().subtract(const Duration(days: 10)),
            ),
            quantity: 1,
            addedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        shippingAddress: 'Đường Phạm Hữu Lầu, Phường 6, Tp.Cao Lãnh, Tỉnh Đồng Tháp ',
        status: OrderStatus.shipping,
        trackingNumber: 'TRACK67890',
      ),
    ];
  }
}

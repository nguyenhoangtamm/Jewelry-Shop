import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoading => _isLoading;

  final List<User> _mockUsers = [
    User(
      id: '1',
      email: 'admin@jewelry.com',
      name: 'Admin User',
      phone: '0123456789',
      role: 'admin',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: '2',
      email: 'user@jewelry.com',
      name: 'Normal User',
      phone: '0987654321',
      role: 'user',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  AuthService() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId != null) {
        _currentUser = _mockUsers.firstWhere(
          (user) => user.id == userId,
          orElse: () => _mockUsers[1],
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from storage: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = _mockUsers.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('Invalid credentials'),
      );

      if (password != '123456') {
        throw Exception('Invalid credentials');
      }

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String email, String password, String name, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final exists = _mockUsers.any((u) => u.email == email);
      if (exists) {
        throw Exception('Email already exists');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        phone: phone,
        role: 'user',
        createdAt: DateTime.now(),
      );

      _mockUsers.add(newUser);
      _currentUser = newUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', newUser.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    notifyListeners();
  }

  Future<bool> updateProfile(
      {String? name, String? phone, String? avatar}) async {
    if (_currentUser == null) return false;

    try {
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phone: phone ?? _currentUser!.phone,
        avatar: avatar ?? _currentUser!.avatar,
      );

      final index = _mockUsers.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _mockUsers[index] = _currentUser!;
      }

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateUserProfile({required String name, required String phone}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: name, phone: phone);

      final index = _mockUsers.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _mockUsers[index] = _currentUser!;
      }

      notifyListeners();
    }
  }

  List<User> getAllUsers() => _mockUsers;

  Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      final index = _mockUsers.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _mockUsers[index] = _mockUsers[index].copyWith(isActive: isActive);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

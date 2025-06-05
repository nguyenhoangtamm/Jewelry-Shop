import 'package:flutter/foundation.dart';
import 'package:jewelry_management_app/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final userDbHelper = GenericDbHelper<User>('users', User.fromJson);
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    _users = await userDbHelper.getAll();
    notifyListeners();
  }
  AuthService() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId != null) {
        final users = await userDbHelper.getAll();
        _currentUser = users.firstWhere(
              (user) => user.id == userId,
          orElse: () => throw Exception('User not found'),
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

      final users = await userDbHelper.getAll();

      final user = users.firstWhere(
            (u) => u.email == email && u.password == password,
        orElse: () => throw Exception('Invalid credentials'),
      );
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id.toString());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      _isLoading = false;
      notifyListeners();
      print('đã false');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final users = await userDbHelper.getAll();
      if (users.any((u) => u.email == email)) {
        throw Exception('Email already exists');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        phone: phone,
        password: password,
        isAdmin: false,
        isActive: true,
        isDeleted: false,
        createdAt: DateTime.now(),
      );

      await userDbHelper.insert( newUser);

      _currentUser = newUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', newUser.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
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

  Future<bool> updateProfile({String? name, String? phone, String? avatar}) async {
    if (_currentUser == null) return false;

    try {
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phone: phone ?? _currentUser!.phone,
        avatar: avatar ?? _currentUser!.avatar,
      );
      await userDbHelper.update(_currentUser!);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
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
  Future<List<User>> getAllUsers() async {
    return await userDbHelper.getAll();
  }

  Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      final users = await getAllUsers();
      final user = users.firstWhere((u) => u.id == userId, orElse: () => throw Exception('User not found'));
      final updatedUser = user.copyWith(isActive: isActive);

      await userDbHelper.update(updatedUser);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update user status error: $e');
      return false;
    }
  }
}

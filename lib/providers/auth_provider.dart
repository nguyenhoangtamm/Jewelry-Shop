import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_management_app/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  final userDbHelper = GenericDbHelper<User>('users', User.fromJson);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  AuthProvider() {
    _loadCurrentUser();
  }

  // Load user from shared preferences
  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      if (userJson != null) {
        final userMap = json.decode(userJson);
        _currentUser = User.fromJson(userMap);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  // Save user to shared preferences
  Future<void> _saveCurrentUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toJson());
      await prefs.setString('current_user', userJson);
    } catch (e) {
      _currentUser = null;
      notifyListeners();
    }
  }

  // Hash password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // 1. Check trong database (SQLite)
      final users = await userDbHelper.getAll();
      final hashedPassword = _hashPassword(password);
      User? userDb;
      try {
        userDb = users.firstWhere(
          (u) => u.username == username && u.password == hashedPassword,
        );
      } catch (e) {
        userDb = null;
      }
      if (userDb != null) {
        _currentUser = userDb;
        await _saveCurrentUser(userDb);
        _setLoading(false);
        notifyListeners();
        return true;
      }

      // 2. Check trong SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      if (usersJson != null) {
        final usersList = json.decode(usersJson) as List;
        for (final userMap in usersList) {
          if (userMap['username'] == username &&
              userMap['password'] == hashedPassword) {
            final user = User.fromJson(userMap);
            _currentUser = user;
            await _saveCurrentUser(user);
            _setLoading(false);
            notifyListeners();
            return true;
          }
        }
      }

      // Không tìm thấy user
      _setError('Tên đăng nhập hoặc mật khẩu không đúng');
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Có lỗi xảy ra: $e');
      _setLoading(false);
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String username,
    required String email,
    required String fullName,
    required String password,
    String? phone,
    String? address,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if username already exists
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      List<dynamic> usersList = [];

      if (usersJson != null) {
        usersList = json.decode(usersJson) as List;

        // Check for existing username or email
        for (final userMap in usersList) {
          if (userMap['username'] == username) {
            _setError('Tên đăng nhập đã tồn tại');
            _setLoading(false);
            return false;
          }
          if (userMap['email'] == email) {
            _setError('Email đã được sử dụng');
            _setLoading(false);
            return false;
          }
        }
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        email: email,
        fullName: fullName,
        isAdmin: false,
        password: _hashPassword(password),
        createdAt: DateTime.now(),
        phone: phone,
        address: address,
      );
      await userDbHelper.insert(newUser);

      // Save user with hashed password
      final userWithPassword = newUser.toJson();
      userWithPassword['password'] = _hashPassword(password);

      usersList.add(userWithPassword);
      await prefs.setString('registered_users', json.encode(usersList));

      // Auto login after registration
      _currentUser = newUser;
      await _saveCurrentUser(newUser);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Có lỗi xảy ra: $e');
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = _currentUser!.copyWith(
        fullName: fullName ?? _currentUser!.fullName,
        email: email ?? _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        address: address ?? _currentUser!.address,
      );

      _currentUser = updatedUser;
      await _saveCurrentUser(updatedUser);
      await userDbHelper.update(updatedUser);

      // Update in registered users list if not admin
      if (!updatedUser.isAdmin) {
        final prefs = await SharedPreferences.getInstance();
        final usersJson = prefs.getString('registered_users');

        if (usersJson != null) {
          final usersList = json.decode(usersJson) as List;

          for (int i = 0; i < usersList.length; i++) {
            if (usersList[i]['id'] == updatedUser.id) {
              usersList[i] = updatedUser.toJson();
              break;
            }
          }

          await prefs.setString('registered_users', json.encode(usersList));
        }
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Có lỗi xảy ra khi cập nhật: $e');
      _setLoading(false);
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final hashedCurrentPassword = _hashPassword(currentPassword);
      final hashedNewPassword = _hashPassword(newPassword);

      // Kiểm tra mật khẩu hiện tại
      if (_currentUser!.password != hashedCurrentPassword) {
        _setError('Mật khẩu hiện tại không đúng');
        _setLoading(false);
        return false;
      }

      // Cập nhật mật khẩu trong database (SQLite)
      final updatedUser = _currentUser!.copyWith(password: hashedNewPassword);
      await userDbHelper.update(updatedUser);

      // Cập nhật mật khẩu trong SharedPreferences (nếu không phải admin)
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      if (usersJson != null) {
        final usersList = json.decode(usersJson) as List;
        for (int i = 0; i < usersList.length; i++) {
          if (usersList[i]['id'] == _currentUser!.id) {
            usersList[i]['password'] = hashedNewPassword;
            break;
          }
        }
        await prefs.setString('registered_users', json.encode(usersList));
      }

      // Cập nhật user hiện tại
      _currentUser = updatedUser;
      await _saveCurrentUser(updatedUser);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Có lỗi xảy ra khi đổi mật khẩu: $e');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

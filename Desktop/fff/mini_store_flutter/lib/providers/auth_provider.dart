import 'package:flutter/material.dart';
import '../models/user.dart' as my_user;
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  my_user.User? _user;
  bool _isLoading = false;
  bool _initialized = false;
  String? _error;

  my_user.User? get user => _user;
  my_user.User? get currentUser => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      _isLoading = true;
      _error = null;

      await _authService.initialize();
      _user = await _authService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _authService.register(
        email,
        password,
        name,
      );

      if (!success) {
        // تم اختصارها هنا لتطبيق الـ Null-aware والتخلص من التحذير
        _error ??= 'فشل إنشاء الحساب';
        return false;
      }

      _user = await _authService.getCurrentUser();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // تم تعديل المرجعية إلى _authService الموحدة في الأعلى منعا لأي تضارب
      final success = await _authService.login(
        email.trim(),
        password.trim(),
      );

      debugPrint('LOGIN RESULT = $success');

      if (!success) {
        // تم اختصارها هنا لتطبيق الـ Null-aware والتخلص من التحذير
        _error ??= 'البريد أو كلمة المرور غير صحيحة';
        return false;
      }

      _user = await _authService.getCurrentUser();
      debugPrint('CURRENT USER = $_user');

      _user ??= my_user.User(
        id: 'logged',
        name: 'User',
        email: email.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('LOGIN ERROR = $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

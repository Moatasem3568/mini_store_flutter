import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';

  final ApiService _apiService = apiService;

  List<Product> get products => _products;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  /// تحميل جميع المنتجات
  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _apiService.getProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'خطأ في تحميل المنتجات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تحميل الفئات
  Future<void> loadCategories() async {
    try {
      _categories = await _apiService.getCategories();
      notifyListeners();
    } catch (e) {
      _error = 'خطأ في تحميل الفئات: $e';
      notifyListeners();
    }
  }

  /// تحميل المنتجات حسب الفئة
  Future<void> loadProductsByCategory(String category) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedCategory = category;
      notifyListeners();

      _products = await _apiService.getProductsByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'خطأ في تحميل المنتجات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// البحث عن المنتجات
  Future<void> searchProducts(String query) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _apiService.searchProducts(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'خطأ في البحث: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// الحصول على منتج واحد
  Future<Product?> getProduct(String id) async {
    try {
      return await _apiService.getProduct(id);
    } catch (e) {
      _error = 'خطأ في تحميل المنتج: $e';
      notifyListeners();
      return null;
    }
  }

  /// مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// إعادة تعيين الفئة المختارة
  void resetCategory() {
    _selectedCategory = '';
    notifyListeners();
  }
}

// Using `provider` package with `ChangeNotifier`, so no top-level
// Riverpod provider is defined here. The class `ProductsProvider`
// is consumed via `ChangeNotifierProvider(create: ...)` in `main.dart`.

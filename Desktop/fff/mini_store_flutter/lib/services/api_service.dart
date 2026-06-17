import 'dart:developer' as developer;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com';

  // بيانات وهمية للمنتجات
  static final List<Product> mockProducts = [
    Product(
      id: '1',
      name: 'iPhone 15',
      price: 999.99,
      category: 'إلكترونيات',
      image: 'https://via.placeholder.com/300x300?text=iPhone+15',
      description: 'أحدث هاتف ذكي من Apple',
      rating: 4.8,
      reviews: 256,
      stock: 50,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Samsung Galaxy S24',
      price: 899.99,
      category: 'إلكترونيات',
      image: 'https://via.placeholder.com/300x300?text=Galaxy+S24',
      description: 'هاتف ذكي قوي من Samsung',
      rating: 4.7,
      reviews: 189,
      stock: 45,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: 'قميص رجالي',
      price: 49.99,
      category: 'ملابس',
      image: 'https://via.placeholder.com/300x300?text=Shirt',
      description: 'قميص رجالي مريح وأنيق',
      rating: 4.5,
      reviews: 120,
      stock: 100,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '4',
      name: 'كتاب Flutter',
      price: 29.99,
      category: 'كتب',
      image: 'https://via.placeholder.com/300x300?text=Flutter+Book',
      description: 'كتاب شامل لتعلم Flutter',
      rating: 4.9,
      reviews: 95,
      stock: 30,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  /// جلب جميع المنتجات
  Future<List<Product>> getProducts() async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 1));
      return mockProducts;
    } catch (e) {
      developer.log('Error fetching products', error: e);
      return [];
    }
  }

  /// جلب منتج واحد
  Future<Product?> getProduct(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return mockProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      developer.log('Error fetching product', error: e);
      return null;
    }
  }

  /// جلب المنتجات حسب الفئة
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return mockProducts.where((p) => p.category == category).toList();
    } catch (e) {
      developer.log('Error fetching products by category', error: e);
      return [];
    }
  }

  /// جلب جميع الفئات
  Future<List<String>> getCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final categories = <String>{};
      for (var product in mockProducts) {
        categories.add(product.category);
      }
      return categories.toList();
    } catch (e) {
      developer.log('Error fetching categories', error: e);
      return [];
    }
  }

  /// البحث عن المنتجات
  Future<List<Product>> searchProducts(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final lowerQuery = query.toLowerCase();
      return mockProducts
          .where((p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      developer.log('Error searching products', error: e);
      return [];
    }
  }
}

final apiService = ApiService();

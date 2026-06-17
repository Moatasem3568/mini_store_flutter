import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class CartProvider extends ChangeNotifier {
  final DatabaseService _databaseService = databaseService;

  List<CartItem> _cartItems = [];

  bool _initialized = false;
  bool _isLoading = false;

  List<CartItem> get cartItems => _cartItems;

  bool get isLoading => _isLoading;

  int get cartCount => _cartItems.fold(
        0,
        (sum, item) => sum + item.quantity,
      );

  double get totalPrice => _cartItems.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

  // ============================
  // تهيئة السلة (مرة واحدة)
  // ============================
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _initialized = true;

      _isLoading = true;

      await _databaseService.initialize();

      _cartItems = await _databaseService.getCart();
    } catch (e) {
      developer.log(
        'Cart init error',
        error: e,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================
  // إضافة للسلة
  // ============================
  Future<void> addToCart(
    Product product, {
    int quantity = 1,
  }) async {
    try {
      final item = CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );

      await _databaseService.addToCart(
        item,
      );

      _cartItems = await _databaseService.getCart();

      notifyListeners();
    } catch (e) {
      developer.log(
        'Add cart error',
        error: e,
      );
    }
  }

  // ============================
  // تعديل الكمية
  // ============================
  Future<void> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      await _databaseService.updateCartItemQuantity(
        productId,
        quantity,
      );

      _cartItems = await _databaseService.getCart();

      notifyListeners();
    } catch (e) {
      developer.log(
        'Update cart error',
        error: e,
      );
    }
  }

  // ============================
  // حذف عنصر
  // ============================
  Future<void> removeFromCart(
    String productId,
  ) async {
    try {
      await _databaseService.removeFromCart(
        productId,
      );

      _cartItems = await _databaseService.getCart();

      notifyListeners();
    } catch (e) {
      developer.log(
        'Remove cart error',
        error: e,
      );
    }
  }

  // ============================
  // مسح السلة
  // ============================
  Future<void> clearCart() async {
    try {
      await _databaseService.clearCart();

      _cartItems.clear();

      notifyListeners();
    } catch (e) {
      developer.log(
        'Clear cart error',
        error: e,
      );
    }
  }

  // ============================
  // التحقق من وجود منتج
  // ============================
  bool isInCart(
    String productId,
  ) {
    return _cartItems.any(
      (item) => item.product.id == productId,
    );
  }

  // ============================
  // كمية منتج
  // ============================
  int getQuantity(
    String productId,
  ) {
    try {
      return _cartItems
          .firstWhere(
            (item) => item.product.id == productId,
          )
          .quantity;
    } catch (_) {
      return 0;
    }
  }
}

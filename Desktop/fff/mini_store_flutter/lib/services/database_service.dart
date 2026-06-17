import 'dart:developer' as developer;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class DatabaseService {
  static const String cartKey = 'mini_store_cart';
  static const String favoritesKey = 'mini_store_favorites';
  static const String themeKey = 'mini_store_theme';

  late SharedPreferences _prefs;

  bool _initialized = false;

  /// تهيئة الخدمة (تعمل مرة واحدة فقط)
  Future<void> initialize() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();

    _initialized = true;
  }

  // ==================== السلة ====================

  Future<void> addToCart(CartItem cartItem) async {
    try {
      await initialize();

      final cart = await getCart();

      final index = cart.indexWhere(
        (item) => item.product.id == cartItem.product.id,
      );

      if (index != -1) {
        cart[index] = cart[index].copyWith(
          quantity: cart[index].quantity + cartItem.quantity,
        );
      } else {
        cart.add(cartItem);
      }

      await _prefs.setString(
        cartKey,
        jsonEncode(cart.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      developer.log('Error adding to cart: $e');
    }
  }

  Future<List<CartItem>> getCart() async {
    try {
      await initialize();

      final data = _prefs.getString(cartKey);

      if (data == null) return [];

      final decoded = jsonDecode(data) as List;

      return decoded.map((e) => CartItem.fromJson(e)).toList();
    } catch (e) {
      developer.log('Error loading cart: $e');
      return [];
    }
  }

  Future<void> updateCartItemQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final cart = await getCart();

      final index = cart.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index == -1) return;

      if (quantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index] = cart[index].copyWith(quantity: quantity);
      }

      await _prefs.setString(
        cartKey,
        jsonEncode(cart.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      developer.log('Error updating cart: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final cart = await getCart();

      cart.removeWhere(
        (item) => item.product.id == productId,
      );

      await _prefs.setString(
        cartKey,
        jsonEncode(cart.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      developer.log('Error removing cart item: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      await initialize();
      await _prefs.remove(cartKey);
    } catch (e) {
      developer.log('Error clearing cart: $e');
    }
  }

  // ==================== المفضلة ====================

  Future<void> addToFavorites(Product product) async {
    try {
      final favorites = await getFavorites();

      if (!favorites.any((e) => e.id == product.id)) {
        favorites.add(product);

        await _prefs.setString(
          favoritesKey,
          jsonEncode(
            favorites.map((e) => e.toJson()).toList(),
          ),
        );
      }
    } catch (e) {
      developer.log('Error adding favorite: $e');
    }
  }

  Future<List<Product>> getFavorites() async {
    try {
      await initialize();

      final data = _prefs.getString(favoritesKey);

      if (data == null) return [];

      final decoded = jsonDecode(data) as List;

      return decoded.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      developer.log('Error loading favorites: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String productId) async {
    final favorites = await getFavorites();

    return favorites.any(
      (item) => item.id == productId,
    );
  }

  Future<void> removeFromFavorites(
    String productId,
  ) async {
    try {
      final favorites = await getFavorites();

      favorites.removeWhere(
        (item) => item.id == productId,
      );

      await _prefs.setString(
        favoritesKey,
        jsonEncode(
          favorites.map((e) => e.toJson()).toList(),
        ),
      );
    } catch (e) {
      developer.log('Error removing favorite: $e');
    }
  }

  Future<void> clearFavorites() async {
    try {
      await initialize();
      await _prefs.remove(favoritesKey);
    } catch (e) {
      developer.log('Error clearing favorites: $e');
    }
  }

  // ==================== الثيم ====================

  Future<void> setTheme(String theme) async {
    try {
      await initialize();

      await _prefs.setString(
        themeKey,
        theme,
      );
    } catch (e) {
      developer.log('Error saving theme: $e');
    }
  }

  Future<String> getTheme() async {
    try {
      await initialize();

      return _prefs.getString(themeKey) ?? 'light';
    } catch (e) {
      developer.log('Error loading theme: $e');
      return 'light';
    }
  }
}

final databaseService = DatabaseService();

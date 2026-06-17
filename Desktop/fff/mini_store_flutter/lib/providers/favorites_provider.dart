import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseService _databaseService =
      databaseService;

  List<Product> _favorites = [];

  bool _initialized = false;
  bool _isLoading = false;

  List<Product> get favorites => _favorites;

  bool get isLoading => _isLoading;

  int get favoritesCount =>
      _favorites.length;

  // ============================
  // تهيئة المفضلة (مرة واحدة)
  // ============================
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _initialized = true;

      _isLoading = true;

      await _databaseService.initialize();

      _favorites =
          await _databaseService
              .getFavorites();
    } catch (e) {
      developer.log(
        'Favorites init error',
        error: e,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================
  // إضافة للمفضلة
  // ============================
  Future<void> addToFavorites(
    Product product,
  ) async {
    try {
      await _databaseService
          .addToFavorites(product);

      _favorites =
          await _databaseService
              .getFavorites();

      notifyListeners();
    } catch (e) {
      developer.log(
        'Add favorite error',
        error: e,
      );
    }
  }

  // ============================
  // حذف من المفضلة
  // ============================
  Future<void> removeFromFavorites(
    String productId,
  ) async {
    try {
      await _databaseService
          .removeFromFavorites(
        productId,
      );

      _favorites =
          await _databaseService
              .getFavorites();

      notifyListeners();
    } catch (e) {
      developer.log(
        'Remove favorite error',
        error: e,
      );
    }
  }

  // ============================
  // هل المنتج مفضل؟
  // ============================
  Future<bool> isFavorite(
    String productId,
  ) async {
    try {
      return await _databaseService
          .isFavorite(
        productId,
      );
    } catch (e) {
      developer.log(
        'Check favorite error',
        error: e,
      );

      return false;
    }
  }

  // ============================
  // تبديل المفضلة
  // ============================
  Future<void> toggleFavorite(
    Product product,
  ) async {
    try {
      final exists =
          await isFavorite(
        product.id,
      );

      if (exists) {
        await removeFromFavorites(
          product.id,
        );
      } else {
        await addToFavorites(
          product,
        );
      }
    } catch (e) {
      developer.log(
        'Toggle favorite error',
        error: e,
      );
    }
  }

  // ============================
  // مسح المفضلة
  // ============================
Future<void> clearFavorites() async {
  try {
    await _databaseService.clearFavorites();

    _favorites = [];

    if (hasListeners) {
      notifyListeners();
    }
  } catch (e) {
    developer.log(
      'Clear favorite error',
      error: e,
    );
  }
}
}
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';

import '../models/user.dart' as my_user;

class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _initialized = false;

  // ==========================
  // تهيئة الخدمة
  // ==========================
  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;

    if (kIsWeb) {
      return;
    }
  }

  // ==========================
  // هل المستخدم مسجل؟
  // ==========================
  Future<bool> isLoggedIn() async {
    await _auth.currentUser?.reload();

    return _auth.currentUser != null;
  }

  // ==========================
  // جلب المستخدم الحالي
  // ==========================
  Future<my_user.User?> getCurrentUser() async {
    try {
      await _auth.currentUser?.reload();

      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      try {
        final doc = await _db
            .collection(
              'users',
            )
            .doc(
              firebaseUser.uid,
            )
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;

          return my_user.User(
            id: firebaseUser.uid,
            name: data['name'] ?? firebaseUser.displayName ?? 'مستخدم',
            email: data['email'] ?? firebaseUser.email ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      } catch (_) {}

      return my_user.User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'مستخدم',
        email: firebaseUser.email ?? '',
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        updatedAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
      );
    } catch (e) {
      developer.log(
        'GetCurrentUser Error',
        error: e,
      );

      return null;
    }
  }

  // ==========================
  // تسجيل الدخول
  // ==========================
  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.reload();

      return credential.user != null;
    } catch (e) {
      developer.log(
        'Login Error',
        error: e,
      );

      return false;
    }
  }

  // ==========================
  // إنشاء حساب
  // ==========================
  Future<bool> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return false;
      }

      await user.updateDisplayName(
        name,
      );

      await user.reload();

      try {
        await _db
            .collection(
              'users',
            )
            .doc(
              user.uid,
            )
            .set({
          'name': name,
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        developer.log(
          'Firestore Save Error',
          error: e,
        );
      }

      return true;
    } catch (e) {
      developer.log(
        'Register Error',
        error: e,
      );

      return false;
    }
  }

  // ==========================
  // تسجيل الخروج
  // ==========================
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      developer.log(
        'Logout Error',
        error: e,
      );
    }
  }
}

final authService = AuthService();

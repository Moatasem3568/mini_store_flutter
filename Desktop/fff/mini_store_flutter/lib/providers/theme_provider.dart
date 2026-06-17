import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // جلب شرط فحص الويب
import '../services/database_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final DatabaseService _databaseService = databaseService;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    if (_isDarkMode) {
      final base = ThemeData.dark();
      return base.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardColor: const Color(0xFF1E1E1E),
      );
    } else {
      final base = ThemeData.light();
      return base.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardColor: Colors.grey[50],
      );
    }
  }

  /// تهيئة الثيم من قاعدة البيانات بطريقة متوافقة مع الويب والهاتف
  Future<void> initialize() async {
    try {
      // إذا كان التطبيق يعمل على المتصفح (الويب)، نتخطى تهيئة قاعدة البيانات المحلية لتجنب التجميد
      if (kIsWeb) {
        _isDarkMode = false; // الوضع الافتراضي المستقر للويب (فاتح)
        notifyListeners();
        return; // إنهاء الدالة فوراً بنجاح
      }

      // كود الهاتف الافتراضي (يعمل فقط على بيئة الأندرويد أو iOS)
      await _databaseService.initialize();
      final theme = await _databaseService.getTheme();
      _isDarkMode = theme == 'dark';
      notifyListeners();
    } catch (e) {
      // حماية التدوير: في حال حدوث أي خطأ في التخزين، يتم تفعيل الوضع الفاتح فوراً لفتح التطبيق
      developer.log('Error initializing theme, falling back to light mode',
          error: e);
      _isDarkMode = false;
      notifyListeners();
    }
  }

  /// تبديل الوضع الليلي/النهاري بأمان
  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      notifyListeners();

      // الحفظ في قاعدة البيانات يتم فقط إذا كنا لا نعمل على الويب
      if (!kIsWeb) {
        await _databaseService.setTheme(_isDarkMode ? 'dark' : 'light');
      }
    } catch (e) {
      developer.log('Error toggling theme', error: e);
    }
  }

  /// تعيين الوضع الليلي بأمان
  Future<void> setDarkMode(bool isDark) async {
    try {
      _isDarkMode = isDark;
      notifyListeners();

      // الحفظ في قاعدة البيانات يتم فقط إذا كنا لا نعمل على الويب
      if (!kIsWeb) {
        await _databaseService.setTheme(isDark ? 'dark' : 'light');
      }
    } catch (e) {
      developer.log('Error setting dark mode', error: e);
    }
  }
}

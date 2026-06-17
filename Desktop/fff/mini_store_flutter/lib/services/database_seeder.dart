import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseSeeder {
  static Future<void> uploadMockProductsToFirestore() async {
    final CollectionReference productsRef =
        FirebaseFirestore.instance.collection('products');

    // نتحقق أولاً إذا كانت قاعدة البيانات تحتوي على منتجات لمنع التكرار
    final existingProducts = await productsRef.limit(1).get();
    if (existingProducts.docs.isNotEmpty) {
      if (kDebugMode) {
        print("Products already exist in Firestore. Skipping seeding.");
      }
      return;
    }

    // المنتجات مجهزة ومطابقة للحقول: name و image و الأرقام والتواريخ المتوقعة
    List<Map<String, dynamic>> mockProducts = [
      {
        'id': 'prod_001',
        'name': 'سماعة رأس لاسلكية سوني CH720N',
        'price': 120.0,
        'category': 'إلكترونيات',
        'image':
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
        'description':
            'سماعة رأس لاسلكية فوق الأذن مع ميزة إلغاء الضوضاء وعمر بطارية يصل إلى 35 ساعة.',
        'rating': 4.5,
        'reviews': 128,
        'stock': 15,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod_002',
        'name': 'ساعة يد ذكية Apple Watch S9',
        'price': 399.0,
        'category': 'إلكترونيات',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80',
        'description':
            'ساعة ذكية متطورة لمتابعة الأنشطة الرياضية، قياس نبضات القلب، وشاشة Retina دائمًا تعمل.',
        'rating': 4.8,
        'reviews': 340,
        'stock': 8,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod_003',
        'name': 'حذاء ركض رياضي فائق الخفة',
        'price': 85.0,
        'category': 'أحذية وملابس',
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&q=80',
        'description':
            'حذاء مريح جداً مخصص للجري والتمارين الرياضية بنعل مرن ومقاوم للصدمات.',
        'rating': 4.2,
        'reviews': 95,
        'stock': 25,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod_004',
        'name': 'نظارة شمسية كلاسيكية كاريرا',
        'price': 150.0,
        'category': 'إكسسوارات',
        'image':
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&q=80',
        'description':
            'نظارة شمسية عصرية بتصميم كلاسيكي يوفر حماية 100% من الأشعة فوق البنفسجية.',
        'rating': 4.0,
        'reviews': 42,
        'stock': 12,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod_005',
        'name': 'حقيبة ظهر مقاومة للماء لرجال الأعمال',
        'price': 65.0,
        'category': 'إكسسوارات',
        'image':
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80',
        'description':
            'حقيبة ظهر ذكية تحتوي على منفذ شحن USB ومساحة مخصصة لجهاز اللاب توب مقاس 15.6 إنش.',
        'rating': 4.6,
        'reviews': 180,
        'stock': 20,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod_006',
        'name': 'مطرة ماء رياضية حافظة للحرارة',
        'price': 25.0,
        'category': 'أدوات رياضية',
        'image':
            'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=500&q=80',
        'description':
            'زجاجة ماء من الفولاذ المقاوم للصدأ تحفظ برودة السوائل لمدة 24 ساعة والحرارة لمدة 12 ساعة.',
        'rating': 4.4,
        'reviews': 60,
        'stock': 50,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      }
    ];

    try {
      if (kDebugMode) {
        print("Starting to seed compatible products to Firestore...");
      }
      for (var product in mockProducts) {
        // نستخدم معرف المنتج المكتوب ليكون هو نفسه عنوان الـ document في الفايربيس منعا للتعارض
        await productsRef.doc(product['id']).set(product);
      }
      if (kDebugMode) {
        print("All compatible products seeded successfully!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error seeding products: $e");
      }
    }
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_store/services/database_seeder.dart';
import 'package:provider/provider.dart';

import 'providers/index.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCyB208pNr7gcak2VRpuQjxAUeAGWai2nU",
        appId: "1:200360245569:web:4daeda2b7e608410ae49c0",
        messagingSenderId: "200360245569",
        projectId: "mini-store-web-18e52",
        authDomain: "mini-store-web-18e52.firebaseapp.com",
        storageBucket: "mini-store-web-18e52.firebasestorage.app",
        measurementId: "G-0KQ12027EX",
      ),
    );
  } catch (_) {}

  await DatabaseSeeder.uploadMockProductsToFirestore();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final p = AuthProvider();

            p.initialize();

            return p;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final p = CartProvider();

            p.initialize();

            return p;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final p = FavoritesProvider();

            p.initialize();

            return p;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final p = ThemeProvider();

            p.initialize();

            return p;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (
          context,
          theme,
          _,
        ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mini Store',
            theme: theme.themeData,
            home: const AppLauncher(),
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/home': (_) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class AppLauncher extends StatelessWidget {
  const AppLauncher({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<AuthProvider>(
      builder: (
        context,
        auth,
        _,
      ) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}

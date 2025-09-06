// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/reels_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/settings_screen.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instanova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.purple,
          secondary: Colors.pink,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Instagram-like font
      ),
      home: const SplashScreen(), // Show splash first
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/search': (_) => const SearchScreen(),
        '/reels': (_) => const ReelsScreen(),
        '/messages': (_) => const MessagesScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}

// Permission Utility
class AppPermissions {
  static Future<void> requestAllPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.photos,
    ];
    for (var permission in permissions) {
      if (!(await permission.isGranted)) {
        await permission.request();
      }
    }
  }
}

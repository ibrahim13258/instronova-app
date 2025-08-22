// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/reels_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';

void main() {
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

  // Method to check and request necessary permissions
  Future<void> _checkPermissions() async {
    // List of permissions needed for the app
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.photos,
      Permission.notifications,
    ];

    // Check and request each permission
    for (var permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        await permission.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check permissions when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissions();
    });

    return MaterialApp(
      title: 'Instanova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Instagram',
      ),
      home: const PermissionWrapper(child: LoginScreen()),
      routes: {
        '/login': (context) => const PermissionWrapper(child: LoginScreen()),
        '/signup': (context) => const PermissionWrapper(child: SignupScreen()),
        '/home': (context) => const PermissionWrapper(child: HomeScreen()),
        '/profile': (context) => const PermissionWrapper(child: ProfileScreen()),
        '/search': (context) => const PermissionWrapper(child: SearchScreen()),
        '/reels': (context) => const PermissionWrapper(child: ReelsScreen()),
        '/messages': (context) => const PermissionWrapper(child: MessagesScreen()),
        '/settings': (context) => const PermissionWrapper(child: SettingsScreen()),
      },
    );
  }
}

// Permission wrapper widget to handle permission requests
class PermissionWrapper extends StatefulWidget {
  final Widget child;

  const PermissionWrapper({super.key, required this.child});

  @override
  State<PermissionWrapper> createState() => _PermissionWrapperState();
}

class _PermissionWrapperState extends State<PermissionWrapper> {
  bool _permissionsGranted = false;
  bool _showPermissionDialog = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ];

    bool allGranted = true;
    
    for (var permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        allGranted = false;
        break;
      }
    }

    if (!allGranted && !_showPermissionDialog) {
      setState(() {
        _showPermissionDialog = true;
      });
      
      // Show permission request dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPermissionRequestDialog();
      });
    } else {
      setState(() {
        _permissionsGranted = true;
      });
    }
  }

  void _showPermissionRequestDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text(
            'Instanova needs access to your camera, microphone, and storage to function properly. '
            'Please grant these permissions to use all features of the app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermissions();
              },
              child: const Text('Grant Permissions'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.photos,
    ];

    final results = await permissions.request();

    // Check if all required permissions are granted
    final allGranted = results.values.every((status) => status.isGranted);

    setState(() {
      _permissionsGranted = allGranted;
      _showPermissionDialog = false;
    });

    if (!allGranted) {
      // Show message if permissions are not granted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Some features may not work without permissions'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _permissionsGranted
        ? widget.child
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text('Checking permissions...'),
                  const SizedBox(height: 20),
                  if (!_permissionsGranted && !_showPermissionDialog)
                    ElevatedButton(
                      onPressed: _requestPermissions,
                      child: const Text('Request Permissions Again'),
                    ),
                ],
              ),
            ),
          );
  }
}

// Permission utility class for easy permission checking throughout the app
class AppPermissions {
  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  static Future<bool> checkPhotosPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  static Future<Map<String, bool>> checkAllPermissions() async {
    final permissions = {
      'camera': await checkCameraPermission(),
      'microphone': await checkMicrophonePermission(),
      'storage': await checkStoragePermission(),
      'photos': await checkPhotosPermission(),
    };

    return permissions;
  }

  static Future<void> requestCameraPermission() async {
    await Permission.camera.request();
  }

  static Future<void> requestMicrophonePermission() async {
    await Permission.microphone.request();
  }

  static Future<void> requestStoragePermission() async {
    await Permission.storage.request();
  }

  static Future<void> requestPhotosPermission() async {
    await Permission.photos.request();
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
} 

 import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../constants/app_routes.dart';

class DeepLinkHandler {
  DeepLinkHandler._privateConstructor();
  static final DeepLinkHandler instance = DeepLinkHandler._privateConstructor();

  StreamSubscription? _sub;

  /// Initialize deep link listener
  void init() {
    // For app already running
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      debugPrint("Deep link error: $err");
    });

    // For app launched via deep link
    _checkInitialLink();
  }

  /// Check if app was launched via deep link
  Future<void> _checkInitialLink() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint("Initial deep link error: $e");
    }
  }

  /// Handle deep link URI and navigate
  void _handleDeepLink(Uri uri) {
    debugPrint("Handling deep link: $uri");

    final path = uri.path;

    // Example: myapp://profile/123
    if (path.startsWith('/profile/')) {
      final userId = path.replaceFirst('/profile/', '');
      Get.toNamed(AppRoutes.profile, arguments: {'userId': userId});
    } else if (path == '/home') {
      Get.toNamed(AppRoutes.home);
    } else if (path == '/login') {
      Get.toNamed(AppRoutes.login);
    } else {
      debugPrint("Unhandled deep link: $uri");
    }
  }

  /// Dispose subscription when not needed
  void dispose() {
    _sub?.cancel();
  }
}


import 'package:flutter/material.dart';
// TODO: Removed GetX import

class NavigationHelper {
  /// Push to new screen
  static void push(Widget page) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.to(() => page);  }

  /// Replace current screen with new screen
  static void pushReplacement(Widget page) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.off(() => page);  }

  /// Remove all previous screens and go to new screen
  static void pushAndRemoveUntil(Widget page) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.offAll(() => page);  }

  /// Pop current screen
  static void pop([dynamic result]) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: if (Get.isOverlaysOpen || Get.canPop()) {// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.back(result: result);    }
  }

  /// Pop until specific route name
  static void popUntil(String routeName) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.until((route) => route.settings.name == routeName);  }

  /// Navigate to named route with optional arguments
  static void navigateTo(String routeName, {dynamic arguments}) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.toNamed(routeName, arguments: arguments);  }

  /// Replace with named route
  static void navigateReplacement(String routeName, {dynamic arguments}) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.offNamed(routeName, arguments: arguments);  }

  /// Remove all previous routes and go to named route
  static void navigateAndRemoveUntil(String routeName, {dynamic arguments}) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: // TODO: Replace GetX navigation: Get.offAllNamed(routeName, arguments: arguments);  }
}
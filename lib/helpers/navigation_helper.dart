import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationHelper {
  /// Push to new screen
  static void push(Widget page) {
    Get.to(() => page);
  }

  /// Replace current screen with new screen
  static void pushReplacement(Widget page) {
    Get.off(() => page);
  }

  /// Remove all previous screens and go to new screen
  static void pushAndRemoveUntil(Widget page) {
    Get.offAll(() => page);
  }

  /// Pop current screen
  static void pop([dynamic result]) {
    if (Get.isOverlaysOpen || Get.canPop()) {
      Get.back(result: result);
    }
  }

  /// Pop until specific route name
  static void popUntil(String routeName) {
    Get.until((route) => route.settings.name == routeName);
  }

  /// Navigate to named route with optional arguments
  static void navigateTo(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }

  /// Replace with named route
  static void navigateReplacement(String routeName, {dynamic arguments}) {
    Get.offNamed(routeName, arguments: arguments);
  }

  /// Remove all previous routes and go to named route
  static void navigateAndRemoveUntil(String routeName, {dynamic arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }
}

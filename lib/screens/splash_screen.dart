import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // ⏳ Delay and navigate
    Timer(const Duration(seconds: 3), () {
      // TODO: Replace with auth check (if user logged in -> home, else login)
      Get.offAllNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            AppAssets.logo,
            height: 120,
            width: 120,
          ),
        ),
      ),
    );
  }
}

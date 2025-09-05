import 'package:flutter/material.dart';

class AppConstants {
  // App Name
  static const String appName = "InstaClone";

  // API Endpoints
  static const String baseUrl = "https://api.instronova.in";
  static const String loginEndpoint = "/auth/login";
  static const String signupEndpoint = "/auth/signup";
  static const String userProfileEndpoint = "/user/profile";
  static const String feedEndpoint = "/feed";
  static const String storiesEndpoint = "/stories";

  // Route Names
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String searchRoute = '/search';
  static const String notificationsRoute = '/notifications';
  static const String chatRoute = '/chat';

  // Colors
  static const Color primaryColor = Color(0xFF405DE6); // Instagram blue
  static const Color secondaryColor = Color(0xFFF56040); // Instagram orange
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColorPrimary = Color(0xFF000000);
  static const Color textColorSecondary = Color(0xFF8E8E8E);
  static const Color borderColor = Color(0xFFE6E6E6);

  // Font Sizes
  static const double headingSize = 24.0;
  static const double subHeadingSize = 18.0;
  static const double bodyTextSize = 14.0;

  // Misc
  static const int feedPageSize = 20;
  static const int storiesCount = 10;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Image URLs
  static const String placeholderAvatar = "assets/images/avatar_placeholder.png";
  static const String placeholderPost = "assets/images/post_placeholder.png";
}

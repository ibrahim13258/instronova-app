import '../config/app_config.dart';
import 'package:flutter/foundation.dart';
// TODO: Removed GetX import
import 'package:dio/dio.dart';

// Model for settings
class SettingsModel {
  String username;
  String email;
  bool isPrivate;
  bool twoFactorEnabled;

  SettingsModel({
    required this.username,
    required this.email,
    required this.isPrivate,
    required this.twoFactorEnabled,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isPrivate: json['isPrivate'] ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'isPrivate': isPrivate,
        'twoFactorEnabled': twoFactorEnabled,
      };
}

class SettingsService extends GetxService {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// TODO: GetX usage commented out
// // OLD: // TODO: Replace GetX navigation: static SettingsService get to => Get.find();
  final Dio _dio = Dio();
  final Rx<SettingsModel> _settings = SettingsModel(
    username: '',
    email: '',
    isPrivate: false,
    twoFactorEnabled: false,
  ).obs;

  // Getter for UI
  SettingsModel get settings => _settings.value;

  // Fetch settings from API
  Future<void> fetchSettings() async {
    try {
      final response = await _dio.get('AppConfig.baseUrl/settings');
      _settings.value = SettingsModel.fromJson(response.data);
    } catch (e) {
      debugPrint('Error fetching settings: $e');
    }
  }

  // Update Account settings
  Future<void> updateAccount({required String username, required String email}) async {
    try {
      final response = await _dio.put(
        'AppConfig.baseUrl/settings/account',
        data: {'username': username, 'email': email},
      );
      _settings.update((val) {
        if (val != null) {
          val.username = username;
          val.email = email;
        }
      });
    } catch (e) {
      debugPrint('Error updating account: $e');
    }
  }

  // Update Privacy settings
  Future<void> updatePrivacy({required bool isPrivate}) async {
    try {
      final response = await _dio.put(
        'AppConfig.baseUrl/settings/privacy',
        data: {'isPrivate': isPrivate},
      );
      _settings.update((val) {
        if (val != null) val.isPrivate = isPrivate;
      });
    } catch (e) {
      debugPrint('Error updating privacy: $e');
    }
  }

  // Update Security settings
  Future<void> updateSecurity({required bool twoFactorEnabled}) async {
    try {
      final response = await _dio.put(
        'AppConfig.baseUrl/settings/security',
        data: {'twoFactorEnabled': twoFactorEnabled},
      );
      _settings.update((val) {
        if (val != null) val.twoFactorEnabled = twoFactorEnabled;
      });
    } catch (e) {
      debugPrint('Error updating security: $e');
    }
  }
}
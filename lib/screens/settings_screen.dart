// File: screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'account_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'security_settings_screen.dart';
import 'help_center_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget _buildSettingTile(BuildContext context, String title, Widget screen) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSettingTile(context, 'Account', const AccountSettingsScreen()),
          _buildSettingTile(context, 'Privacy', const PrivacySettingsScreen()),
          _buildSettingTile(context, 'Security', const SecuritySettingsScreen()),
          const Divider(),
          _buildSettingTile(context, 'Help Center', const HelpCenterScreen()),
          _buildSettingTile(context, 'About', const AboutScreen()),
        ],
      ),
    );
  }
}

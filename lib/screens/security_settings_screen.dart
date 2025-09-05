// File: screens/security_settings_screen.dart
import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  Widget _buildSettingTile(String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool savedLoginInfo = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
      ),
      body: ListView(
        children: [
          _buildSettingTile('Change Password', onTap: () {
            // Navigate to change password screen
          }),
          SwitchListTile(
            title: const Text('Save Login Info'),
            value: savedLoginInfo,
            onChanged: (val) {
              // Update saved login info
              savedLoginInfo = val;
            },
          ),
          _buildSettingTile('Two-Factor Authentication', onTap: () {
            // Navigate to 2FA setup
          }),
          _buildSettingTile('Login Activity', onTap: () {
            // Show login activity logs
          }),
          _buildSettingTile('Apps and Websites', onTap: () {
            // Show connected apps and permissions
          }),
          _buildSettingTile('Emails from Instagram', onTap: () {
            // Show Instagram security emails
          }),
        ],
      ),
    );
  }
}

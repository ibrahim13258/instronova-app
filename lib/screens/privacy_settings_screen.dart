// File: screens/privacy_settings_screen.dart
import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  Widget _buildSettingTile(String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool activityStatus = true;
    bool storySharing = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show Activity Status'),
            value: activityStatus,
            onChanged: (val) {
              // Update activity status logic
              activityStatus = val;
            },
          ),
          SwitchListTile(
            title: const Text('Allow Story Sharing'),
            value: storySharing,
            onChanged: (val) {
              // Update story sharing logic
              storySharing = val;
            },
          ),
          _buildSettingTile('Blocked Users', onTap: () {
            // Navigate to blocked users screen
          }),
          _buildSettingTile('Restricted Accounts', onTap: () {
            // Navigate to restricted accounts screen
          }),
          _buildSettingTile('Comment Controls', onTap: () {
            // Navigate to comment control settings
          }),
          _buildSettingTile('Muted Accounts', onTap: () {
            // Navigate to muted accounts screen
          }),
        ],
      ),
    );
  }
}

// screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Settings
            _buildSectionHeader('Account'),
            _buildSettingsTile('Edit Profile', Icons.person),
            _buildSettingsTile('Change Password', Icons.lock),
            _buildSettingsTile('Private Account', Icons.visibility_off, isToggle: true),
            _buildSettingsTile('Show Activity Status', Icons.remove_red_eye, isToggle: true),
            _buildSettingsTile('Allow Message Requests', Icons.mail, isToggle: true),
            
            // Notifications
            _buildSectionHeader('Notifications'),
            _buildSettingsTile('Post/Story/Reel Notifications', Icons.post_add),
            _buildSettingsTile('Likes & Comments', Icons.favorite_border),
            _buildSettingsTile('Follower Requests', Icons.person_add),
            _buildSettingsTile('DM & Call Alerts', Icons.chat),
            
            // General
            _buildSectionHeader('General'),
            _buildSettingsTile('Language', Icons.language),
            _buildSettingsTile('Theme', Icons.color_lens),
            _buildSettingsTile('Linked Accounts', Icons.link),
            _buildSettingsTile('Help & Support', Icons.help),
            
            // Privacy & Security
            _buildSectionHeader('Privacy & Security'),
            _buildSettingsTile('Two-Factor Authentication', Icons.security),
            _buildSettingsTile('Blocked Users List', Icons.block),
            _buildSettingsTile('Restricted Users List', Icons.do_not_disturb_on),
            _buildSettingsTile('Muted Accounts', Icons.volume_off),
            _buildSettingsTile('Login Activity', Icons.history),
            
            // Account Actions
            _buildSectionHeader('Account Actions'),
            _buildSettingsTile('Download My Data', Icons.download),
            _buildSettingsTile('Deactivate Account', Icons.pause_circle_outline),
            _buildSettingsTile('Reactivate Account', Icons.play_circle_outline),
            _buildSettingsTile('Permanently Delete Account', Icons.delete, color: Colors.red),
            
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Implement logout
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, {bool isToggle = false, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: isToggle
          ? Switch(value: true, onChanged: (value) {})
          : const Icon(Icons.chevron_right),
      onTap: () {
        // Handle tap
      },
    );
  }
}

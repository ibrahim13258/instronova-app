// File: screens/account_settings_screen.dart
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  Widget _buildSettingTile(String title, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSettingTile('Username', onTap: () {
            // Navigate to username edit page
          }),
          _buildSettingTile('Email', onTap: () {
            // Navigate to email edit page
          }),
          _buildSettingTile('Phone', onTap: () {
            // Navigate to phone edit page
          }),
          _buildSettingTile('Connected Accounts', onTap: () {
            // Navigate to connected accounts page
          }),
          const Divider(),
          _buildSettingTile('Delete Account', onTap: () {
            // Show confirmation dialog for deleting account
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Account'),
                content: const Text('Are you sure you want to delete your account?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle delete account logic
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// File: screens/help_center_screen.dart
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _helpTopics = [
    'Account Management',
    'Privacy and Security',
    'Report a Problem',
    'Managing Notifications',
    'Using Instagram Features',
  ];
  List<String> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _filteredTopics = _helpTopics;
  }

  void _filterTopics(String query) {
    setState(() {
      _filteredTopics = _helpTopics
          .where((topic) => topic.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildHelpTile(String title, {VoidCallback? onTap}) {
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
        title: const Text('Help Center'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Help',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterTopics,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTopics.length,
              itemBuilder: (context, index) {
                return _buildHelpTile(_filteredTopics[index], onTap: () {
                  // Navigate to detailed help article or support chat
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: const Text('Contact Support'),
              onPressed: () {
                // Open support chat
              },
            ),
          ),
        ],
      ),
    );
  }
}

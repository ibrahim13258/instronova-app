// File: screens/likes_screen.dart
import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  List<Map<String, dynamic>> likes = [
    {
      'username': 'emma_watson',
      'postImage': 'https://via.placeholder.com/100',
      'time': '2h ago'
    },
    {
      'username': 'chris_evans',
      'postImage': 'https://via.placeholder.com/100/FF5733',
      'time': '5h ago'
    },
    {
      'username': 'scarlett_j',
      'postImage': 'https://via.placeholder.com/100/33FF57',
      'time': '1d ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Likes'),
      ),
      body: likes.isEmpty
          ? const Center(child: Text('No likes yet'))
          : ListView.builder(
              itemCount: likes.length,
              itemBuilder: (context, index) {
                final like = likes[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(like['postImage']),
                    radius: 25,
                  ),
                  title: Text('${like['username']} liked your post'),
                  subtitle: Text(like['time']),
                  onTap: () {
                    // Navigate to post detail
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening post of ${like['username']}')),
                    );
                  },
                );
              },
            ),
    );
  }
}

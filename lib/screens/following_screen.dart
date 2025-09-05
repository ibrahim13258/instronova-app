// File: screens/following_screen.dart
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<Map<String, dynamic>> following = [
    {'username': 'emma_watson', 'image': 'https://via.placeholder.com/150', 'isFollowing': true},
    {'username': 'chris_evans', 'image': 'https://via.placeholder.com/150/FF5733', 'isFollowing': true},
    {'username': 'scarlett_j', 'image': 'https://via.placeholder.com/150/33FF57', 'isFollowing': true},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredFollowing = following
        .where((f) => f['username'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search following',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredFollowing.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
                    itemCount: filteredFollowing.length,
                    itemBuilder: (context, index) {
                      final user = filteredFollowing[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['image']),
                        ),
                        title: Text(user['username']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              user['isFollowing'] = !user['isFollowing'];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: user['isFollowing'] ? Colors.grey : Colors.blue,
                          ),
                          child: Text(user['isFollowing'] ? 'Following' : 'Follow'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

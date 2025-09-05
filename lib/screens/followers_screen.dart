// File: screens/followers_screen.dart
import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<Map<String, dynamic>> followers = [
    {'username': 'john_doe', 'image': 'https://via.placeholder.com/150', 'isFollowing': true},
    {'username': 'jane_smith', 'image': 'https://via.placeholder.com/150/FF0000', 'isFollowing': false},
    {'username': 'alex_99', 'image': 'https://via.placeholder.com/150/00FF00', 'isFollowing': true},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredFollowers = followers
        .where((f) => f['username'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search followers',
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
            child: filteredFollowers.isEmpty
                ? const Center(child: Text('No followers found'))
                : ListView.builder(
                    itemCount: filteredFollowers.length,
                    itemBuilder: (context, index) {
                      final follower = filteredFollowers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(follower['image']),
                        ),
                        title: Text(follower['username']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              follower['isFollowing'] = !follower['isFollowing'];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: follower['isFollowing'] ? Colors.grey : Colors.blue,
                          ),
                          child: Text(follower['isFollowing'] ? 'Following' : 'Follow'),
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

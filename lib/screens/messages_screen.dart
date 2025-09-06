// File: screens/messages_screen.dart
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> chatUsers = List.generate(
    15,
    (index) => {
      "username": "user_$index",
      "lastMessage": "Last message from user_$index",
      "time": "${index + 1}:${(index * 3) % 60} PM",
      "profileImage": "https://i.pravatar.cc/150?img=$index",
      "isOnline": index % 3 == 0,
    },
  );

  Widget _buildChatTile(Map<String, dynamic> user) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(user['profileImage']),
          ),
          if (user['isOnline'])
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        user['username'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user['lastMessage']),
      trailing: Text(
        user['time'],
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () {
        // Navigate to chat detail screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit,
                color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              // Compose new message
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: chatUsers.length,
        separatorBuilder: (context, index) => const Divider(
          height: 0,
          indent: 70,
        ),
        itemBuilder: (context, index) => _buildChatTile(chatUsers[index]),
      ),
    );
  }
}

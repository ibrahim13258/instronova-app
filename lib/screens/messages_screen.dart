// File: screens/messages_screen.dart
import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, String>> chats = List.generate(
    10,
    (index) => {
      "username": "user_$index",
      "profileImage": "https://i.pravatar.cc/150?img=$index",
      "lastMessage": "Last message from user_$index",
    },
  );

  MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(
          "Messages",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat["profileImage"]!),
            ),
            title: Text(
              chat["username"]!,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              chat["lastMessage"]!,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    username: chat["username"]!,
                    userProfile: chat["profileImage"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

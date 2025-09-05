// File: screens/chat_list_screen.dart
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> chats = [
    {'user': 'Alice', 'lastMessage': 'Hey! How are you?', 'time': '2m', 'unread': true, 'online': true},
    {'user': 'Bob', 'lastMessage': 'Let\'s catch up later', 'time': '10m', 'unread': false, 'online': false},
    {'user': 'Charlie', 'lastMessage': 'Check this out!', 'time': '1h', 'unread': true, 'online': true},
    {'user': 'Diana', 'lastMessage': 'Thanks!', 'time': '3h', 'unread': false, 'online': false},
  ];

  void _deleteChat(int index) {
    setState(() {
      chats.removeAt(index);
    });
  }

  Widget _buildChatItem(Map<String, dynamic> chat, int index) {
    return Dismissible(
      key: Key(index.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteChat(index),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              child: Text(chat['user'][0].toUpperCase()),
            ),
            if (chat['online'])
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
        title: Text(chat['user']),
        subtitle: Text(chat['lastMessage']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chat['time']),
            if (chat['unread'])
              const SizedBox(height: 5),
            if (chat['unread'])
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          // Navigate to chat_screen with user details
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: chats.isEmpty
          ? const Center(child: Text('No chats available'))
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) => _buildChatItem(chats[index], index),
            ),
    );
  }
}

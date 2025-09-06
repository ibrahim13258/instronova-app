// File: screens/chat_detail_screen.dart
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String username;
  final String userProfile;

  const ChatDetailScreen({
    Key? key,
    required this.username,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {"text": "Hi!", "isMe": false},
    {"text": "Hello, how are you?", "isMe": true},
    {"text": "I am good. What about you?", "isMe": false},
  ];

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"text": text, "isMe": true});
    });
    _messageController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isMe = message["isMe"];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          message["text"],
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userProfile),
            ),
            const SizedBox(width: 8),
            Text(
              widget.username,
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline,
                      color: isDark ? Colors.white : Colors.black54),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,
                      color: isDark ? Colors.blueAccent : Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// screens/messages_screen.dart
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/user.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<User> _users = [
    User(
      id: '1',
      name: 'John Doe',
      username: 'johndoe',
      email: 'john@example.com',
      profileImageUrl: 'https://example.com/avatar1.jpg',
      joinedDate: DateTime.now(),
    ),
    User(
      id: '2',
      name: 'Jane Smith',
      username: 'janesmith',
      email: 'jane@example.com',
      profileImageUrl: 'https://example.com/avatar2.jpg',
      joinedDate: DateTime.now(),
    ),
  ];

  final List<Message> _messages = [
    Message(
      id: '1',
      senderId: '1',
      receiverId: '2',
      text: 'Hey, how are you?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    Message(
      id: '2',
      senderId: '2',
      receiverId: '1',
      text: 'I\'m good, thanks! How about you?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Implement new message functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search username...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          // Chat list
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final lastMessage = _messages.firstWhere(
                  (msg) => msg.senderId == user.id || msg.receiverId == user.id,
                  orElse: () => Message(
                    id: '0',
                    senderId: '0',
                    receiverId: '0',
                    text: 'No messages yet',
                    timestamp: DateTime.now(),
                    isRead: true,
                  ),
                );
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl),
                  ),
                  title: Text(user.username),
                  subtitle: Text(
                    lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(lastMessage.timestamp),
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (!lastMessage.isRead)
                        const CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.blue,
                        ),
                    ],
                  ),
                  onTap: () => _openChat(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays > 0) {
      return '${time.day}/${time.month}';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _openChat(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(user: user, messages: _messages),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final User user;
  final List<Message> messages;

  const ChatScreen({
    super.key,
    required this.user,
    required this.messages,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.user.profileImageUrl),
            ),
            const SizedBox(width: 8),
            Text(widget.user.username),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final message = widget.messages[index];
                final isMe = message.senderId == '1'; // Current user ID
                
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.purple : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Message input
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      widget.messages.insert(0, Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: '1', // Current user ID
        receiverId: widget.user.id,
        text: _messageController.text.trim(),
        timestamp: DateTime.now(),
        isRead: false,
      ));
      _messageController.clear();
    });
    
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

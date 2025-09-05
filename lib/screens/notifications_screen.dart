// File: screens/notifications_screen.dart
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {'type': 'like', 'user': 'user_1', 'post': 'Post 1', 'time': '2h ago'},
    {'type': 'comment', 'user': 'user_2', 'post': 'Post 3', 'time': '3h ago'},
    {'type': 'follow', 'user': 'user_3', 'time': '5h ago'},
    {'type': 'like', 'user': 'user_4', 'post': 'Post 5', 'time': '6h ago'},
    {'type': 'comment', 'user': 'user_5', 'post': 'Post 2', 'time': '8h ago'},
  ];

  void _markAsRead(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, int index) {
    IconData icon;
    String text;

    switch (notification['type']) {
      case 'like':
        icon = Icons.favorite;
        text = '${notification['user']} liked your post "${notification['post']}"';
        break;
      case 'comment':
        icon = Icons.comment;
        text = '${notification['user']} commented on your post "${notification['post']}"';
        break;
      case 'follow':
        icon = Icons.person_add;
        text = '${notification['user']} started following you';
        break;
      default:
        icon = Icons.notifications;
        text = '';
    }

    return Dismissible(
      key: Key(index.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _markAsRead(index),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.done, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(notification['user'][0].toUpperCase()),
        ),
        title: Text(text),
        subtitle: Text(notification['time']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No new notifications'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) =>
                  _buildNotificationItem(notifications[index], index),
            ),
    );
  }
}

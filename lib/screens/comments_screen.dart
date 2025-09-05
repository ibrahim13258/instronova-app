// File: screens/comments_screen.dart
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Map<String, dynamic>> comments = [
    {
      'username': 'john_doe',
      'profilePic': 'https://via.placeholder.com/50',
      'comment': 'Awesome post!',
      'time': '1h ago',
      'liked': false,
    },
    {
      'username': 'jane_smith',
      'profilePic': 'https://via.placeholder.com/50/FF5733',
      'comment': 'Loved this!',
      'time': '2h ago',
      'liked': true,
    },
    {
      'username': 'alex_99',
      'profilePic': 'https://via.placeholder.com/50/33FF57',
      'comment': 'Great content!',
      'time': '3h ago',
      'liked': false,
    },
  ];

  void toggleLike(int index) {
    setState(() {
      comments[index]['liked'] = !comments[index]['liked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment['profilePic']),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: comment['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: comment['comment'],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(comment['time']),
                  trailing: IconButton(
                    icon: Icon(
                      comment['liked'] ? Icons.favorite : Icons.favorite_border,
                      color: comment['liked'] ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => toggleLike(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

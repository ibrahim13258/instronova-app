import 'package:flutter/material.dart';

class MultiAccountTile extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final bool isCurrentAccount;
  final VoidCallback onTap;

  const MultiAccountTile({
    Key? key,
    required this.username,
    required this.profileImageUrl,
    this.isCurrentAccount = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          if (isCurrentAccount)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                width: 12,
                height: 12,
              ),
            ),
        ],
      ),
      title: Text(
        username,
        style: TextStyle(
          fontWeight: isCurrentAccount ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isCurrentAccount
          ? const Icon(Icons.check, color: Colors.blueAccent)
          : null,
    );
  }
}

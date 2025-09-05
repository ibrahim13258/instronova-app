// File: screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/story_list.dart';
import '../widgets/feed_post_item.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../screens/reels_screen.dart';
import '../screens/search_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    FeedScreen(), // Feed Screen showing posts
    ReelsScreen(), // Reels
    SearchScreen(), // Search
    NotificationsScreen(), // Notifications
    ProfileScreen(), // User Profile
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram HVp',
          style: TextStyle(fontFamily: 'Billabong', fontSize: 28),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => Get.toNamed('/add_post'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Get.toNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => Get.toNamed('/chat_list'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// FeedScreen widget (can also be a separate file for modularity)
class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> dummyPosts = List.generate(
    10,
    (index) => {
      "username": "user$index",
      "profileImage": "https://i.pravatar.cc/150?img=$index",
      "postImage": "https://picsum.photos/500/500?random=$index",
      "likes": 10 + index,
      "caption": "This is post $index",
    },
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StoryList(), // Top stories carousel
          const Divider(),
          ...dummyPosts.map((post) => FeedPostItem(post: post)).toList(),
        ],
      ),
    );
  }
}

// File: screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _posts = List.generate(12, (index) => 'Post $index');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Profile picture
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 50),
          ),
          const SizedBox(width: 16),
          // Stats
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _ProfileStat(count: 34, label: 'Posts'),
                    _ProfileStat(count: 1200, label: 'Followers'),
                    _ProfileStat(count: 250, label: 'Following'),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('This is my bio. I love sharing photos and videos!'),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(icon: Icon(Icons.grid_on)),
        Tab(icon: Icon(Icons.video_collection)),
        Tab(icon: Icon(Icons.bookmark_border)),
      ],
    );
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: 400, // Adjust height as needed
      child: TabBarView(
        controller: _tabController,
        children: [
          // Posts grid
          GridView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: _posts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[300],
                child: Center(child: Text(_posts[index])),
              );
            },
          ),
          // Reels placeholder
          Center(child: Text('Reels will appear here')),
          // Saved posts placeholder
          Center(child: Text('Saved posts will appear here')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 8),
            _buildBio(),
            const SizedBox(height: 8),
            _buildTabBar(),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final int count;
  final String label;

  const _ProfileStat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

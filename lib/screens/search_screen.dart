// File: screens/search_screen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allUsers = List.generate(20, (index) => 'user_$index');
  List<String> filteredUsers = [];
  List<String> trendingTags = ['#travel', '#food', '#fashion', '#nature', '#art'];

  @override
  void initState() {
    super.initState();
    filteredUsers = allUsers;
    _searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((user) => user.contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildTrendingTags() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingTags.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ActionChip(
              label: Text(trendingTags[index],
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                _searchController.text = trendingTags[index].replaceAll('#', '');
                _filterUsers();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserResult(String username) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blue.shade100,
        child: Text(username[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Bio of $username', style: TextStyle(color: Colors.grey.shade600)),
      onTap: () {},
    );
  }

  Widget _buildPostGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text('Post ${index + 1}')),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildTrendingTags(),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) => _buildUserResult(filteredUsers[index]),
            ),
            const SizedBox(height: 8),
            _buildPostGrid(),
          ],
        ),
      ),
    );
  }
}

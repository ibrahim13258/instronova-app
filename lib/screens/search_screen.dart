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
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingTags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Chip(
              label: Text(trendingTags[index]),
              backgroundColor: Colors.blue.shade100,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserResult(String username) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(username[0].toUpperCase()),
      ),
      title: Text(username),
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
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey.shade300,
          child: Center(child: Text('Post ${index + 1}')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildTrendingTags(),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) => _buildUserResult(filteredUsers[index]),
            ),
            const Divider(),
            _buildPostGrid(),
          ],
        ),
      ),
    );
  }
}

// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../widgets/post_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Provider.of<PostProvider>(context, listen: false).fetchTrendingPosts();
  }

  @override
  Widget build(BuildContext context) {
    final trendingPosts = Provider.of<PostProvider>(context).trendingPosts;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() => _isSearching = value.isNotEmpty);
          },
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _isSearching = false);
              },
            ),
        ],
      ),
      body: _isSearching
          ? const Center(child: Text('Search results will appear here'))
          : DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Trending'),
                      Tab(text: 'Users'),
                      Tab(text: 'Tags'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        PostGrid(posts: trendingPosts),
                        const Center(child: Text('Users will appear here')),
                        const Center(child: Text('Tags will appear here')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

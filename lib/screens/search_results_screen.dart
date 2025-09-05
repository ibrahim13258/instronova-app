// File: screens/search_results_screen.dart
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Map<String, String>> users = [
    {'username': 'john_doe', 'profilePic': 'https://via.placeholder.com/50'},
    {'username': 'jane_smith', 'profilePic': 'https://via.placeholder.com/50/FF5733'},
    {'username': 'alex_99', 'profilePic': 'https://via.placeholder.com/50/33FF57'},
  ];

  List<String> posts = List.generate(12, (index) => 'https://via.placeholder.com/150');

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Users result
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Users', style: Theme.of(context).textTheme.headline6),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user['profilePic']!),
                        ),
                        const SizedBox(height: 5),
                        Text(user['username']!),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            // Posts grid
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Posts', style: Theme.of(context).textTheme.headline6),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                return Image.network(posts[index], fit: BoxFit.cover);
              },
            ),
          ],
        ),
      ),
    );
  }
}

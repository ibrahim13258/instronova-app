// File: screens/add_post_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _mediaFile;
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _location = '';
  List<String> _taggedUsers = [];

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final pickedFile = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
      });
    }
  }

  void _postContent() {
    if (_mediaFile != null && _captionController.text.isNotEmpty) {
      // Upload post logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add media and caption')),
      );
    }
  }

  void _tagUser(String username) {
    setState(() {
      if (!_taggedUsers.contains(username)) {
        _taggedUsers.add(username);
      }
    });
  }

  void _setLocation(String location) {
    setState(() {
      _location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        actions: [
          TextButton(
            onPressed: _postContent,
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickMedia(ImageSource.gallery),
              child: _mediaFile == null
                  ? Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Tap to select media')),
                    )
                  : Image.file(_mediaFile!, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onSubmitted: _tagUser,
              decoration: const InputDecoration(
                hintText: 'Tag people (@username)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onSubmitted: _setLocation,
              decoration: const InputDecoration(
                hintText: 'Add location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_taggedUsers.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _taggedUsers.map((u) => Chip(label: Text(u))).toList(),
              ),
            if (_location.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(_location),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// screens/reels_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  late List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    final reels = Provider.of<PostProvider>(context, listen: false).reels;
    _videoControllers = reels.map((reel) {
      final controller = VideoPlayerController.network(reel.imageUrl)
        ..initialize().then((_) {
          setState(() {});
          controller.play();
        });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reels = Provider.of<PostProvider>(context).reels;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Video Player
              _videoControllers[index].value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoControllers[index].value.aspectRatio,
                      child: VideoPlayer(_videoControllers[index]),
                    )
                  : const Center(child: CircularProgressIndicator()),
              
              // Video Overlay
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Right side buttons
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        const Text('12.5k', style: TextStyle(color: Colors.white)),
                        
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.white),
                          onPressed: () {},
                        ),
                        const Text('1.2k', style: TextStyle(color: Colors.white)),
                        
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {},
                        ),
                        
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {},
                        ),
                        
                        const SizedBox(height: 16),
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                        ),
                      ],
                    ),
                    
                    // Bottom section
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${reels[index].username}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reels[index].caption,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.music_note, color: Colors.white, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Original Sound',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

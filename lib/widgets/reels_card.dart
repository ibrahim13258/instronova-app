import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsCard extends StatefulWidget {
  final String videoUrl;
  final String username;
  final String caption;
  final int likes;
  final int comments;

  const ReelsCard({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    required this.comments,
  });

  @override
  State<ReelsCard> createState() => _ReelsCardState();
}

class _ReelsCardState extends State<ReelsCard> {
  late VideoPlayerController _controller;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              // Video player
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                child: VideoPlayer(_controller),
              ),
              // Gradient overlay for text visibility
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Bottom controls
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Username + Caption
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '@${widget.username}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.caption,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: toggleLike,
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                            size: 30,
                          ),
                        ),
                        Text(
                          widget.likes.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.comment, color: Colors.white, size: 30),
                        ),
                        Text(
                          widget.comments.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}

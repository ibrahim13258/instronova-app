// File: screens/story_viewer_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<String> stories; // List of image URLs
  final String userName;
  final String userAvatar;

  const StoryViewerScreen({
    Key? key,
    required this.stories,
    required this.userName,
    required this.userAvatar,
  }) : super(key: key);

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  int currentIndex = 0;
  double progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.01;
        if (progress >= 1.0) {
          progress = 0.0;
          currentIndex++;
          if (currentIndex >= widget.stories.length) {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    _timer?.cancel();
  }

  void _onTapUp(TapUpDetails details) {
    _startTimer();
  }

  void _nextStory() {
    setState(() {
      progress = 0.0;
      currentIndex = (currentIndex + 1) % widget.stories.length;
    });
  }

  void _prevStory() {
    setState(() {
      progress = 0.0;
      currentIndex = (currentIndex - 1).clamp(0, widget.stories.length - 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _nextStory();
        } else if (details.primaryVelocity! > 0) {
          _prevStory();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.stories[currentIndex],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white38,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.userAvatar),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.userName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

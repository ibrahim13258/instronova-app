// File: screens/reels_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> reelVideos = List.generate(
      5, (index) => "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_$index.mp4");

  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeVideo(_currentIndex);
  }

  void _initializeVideo(int index) {
    if (!_videoControllers.containsKey(index)) {
      final controller = VideoPlayerController.network(reelVideos[index])
        ..initialize().then((_) {
          setState(() {});
          controller.play();
        });
      controller.setLooping(true);
      _videoControllers[index] = controller;
    } else {
      _videoControllers[index]!.play();
    }
  }

  void _pauseVideo(int index) {
    if (_videoControllers.containsKey(index)) {
      _videoControllers[index]!.pause();
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemCount: reelVideos.length,
      onPageChanged: (index) {
        _pauseVideo(_currentIndex);
        _currentIndex = index;
        _initializeVideo(_currentIndex);
      },
      itemBuilder: (context, index) {
        final controller = _videoControllers[index];
        return controller != null && controller.value.isInitialized
            ? Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 32,
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 32),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: LinearProgressIndicator(
                      value: controller.value.position.inSeconds /
                          controller.value.duration.inSeconds,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}

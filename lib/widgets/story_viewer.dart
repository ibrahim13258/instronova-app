import 'dart:async';
import 'package:flutter/material.dart';

class StoryViewer extends StatefulWidget {
  final List<String> stories; // URLs or local paths
  final int initialIndex;

  const StoryViewer({
    Key? key,
    required this.stories,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late PageController _pageController;
  late Timer _timer;
  int _currentIndex = 0;
  double _progress = 0.0;
  final int _storyDuration = 5; // seconds

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.05 / _storyDuration;
        if (_progress >= 1.0) {
          _progress = 0.0;
          _nextStory();
        }
      });
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _currentIndex++;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop(); // Close viewer at last story
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progress = 0.0;
    }
  }

  void _pauseStory() => _timer.cancel();

  void _resumeStory() => _startTimer();

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pauseStory(),
      onTapUp: (_) => _resumeStory(),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _nextStory();
        } else if (details.primaryVelocity! > 0) {
          _previousStory();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.stories[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Row(
                children: widget.stories
                    .asMap()
                    .map((i, e) {
                      return MapEntry(
                        i,
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 2,
                            decoration: BoxDecoration(
                              color: i < _currentIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: i == _currentIndex
                                ? FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _progress,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

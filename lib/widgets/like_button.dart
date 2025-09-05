import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class LikeButton extends StatefulWidget {
  final bool isLikedInitial;
  final int likeCountInitial;
  final Function(bool isLiked)? onLikeChanged;

  const LikeButton({
    Key? key,
    this.isLikedInitial = false,
    this.likeCountInitial = 0,
    this.onLikeChanged,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late bool isLiked;
  late int likeCount;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLikedInitial;
    likeCount = widget.likeCountInitial;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
        _controller.forward();
      }
      isLiked = !isLiked;
      if (widget.onLikeChanged != null) {
        widget.onLikeChanged!(isLiked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 28,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            '$likeCount',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

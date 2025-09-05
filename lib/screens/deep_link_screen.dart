// File: screens/deep_link_screen.dart
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class DeepLinkScreen extends StatefulWidget {
  const DeepLinkScreen({Key? key}) : super(key: key);

  @override
  State<DeepLinkScreen> createState() => _DeepLinkScreenState();
}

class _DeepLinkScreenState extends State<DeepLinkScreen> {
  String? _linkMessage;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    // Initial link handling
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        setState(() {
          _linkMessage = "Opened via link: $initialLink";
        });
        handleLink(initialLink);
      }
    } catch (e) {
      setState(() {
        _linkMessage = "Failed to get initial link.";
      });
    }

    // Listen for incoming links
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        setState(() {
          _linkMessage = "Received deep link: $uri";
        });
        handleLink(uri.toString());
      }
    }, onError: (err) {
      setState(() {
        _linkMessage = "Error receiving deep link.";
      });
    });
  }

  void handleLink(String link) {
    // Instagram-style navigation logic
    if (link.contains("/post/")) {
      final postId = link.split("/post/").last;
      Navigator.pushNamed(context, '/post_detail', arguments: postId);
    } else if (link.contains("/profile/")) {
      final userId = link.split("/profile/").last;
      Navigator.pushNamed(context, '/profile', arguments: userId);
    } else {
      // Default fallback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link not recognized: $link")),
      );
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep Link Handler')),
      body: Center(
        child: _linkMessage == null
            ? const Text('Waiting for deep link...')
            : Text(
                _linkMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}

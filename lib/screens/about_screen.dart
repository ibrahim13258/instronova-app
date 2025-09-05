// File: screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  final String _appVersion = "v1.0.0";
  final String _developerName = "Your Company Name";
  final String _websiteUrl = "https://www.yourwebsite.com";

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildListTile(String title, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _developerName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('Version: $_appVersion'),
                ],
              ),
            ),
            const Divider(height: 30),
            _buildListTile('Terms of Service', onTap: () {
              _launchURL('https://www.yourwebsite.com/terms');
            }),
            _buildListTile('Privacy Policy', onTap: () {
              _launchURL('https://www.yourwebsite.com/privacy');
            }),
            _buildListTile('Visit Our Website', onTap: () {
              _launchURL(_websiteUrl);
            }),
            _buildListTile('Follow us on Instagram', onTap: () {
              _launchURL('https://www.instagram.com/yourcompany');
            }),
            _buildListTile('Follow us on Twitter', onTap: () {
              _launchURL('https://www.twitter.com/yourcompany');
            }),
            _buildListTile('Follow us on Facebook', onTap: () {
              _launchURL('https://www.facebook.com/yourcompany');
            }),
          ],
        ),
      ),
    );
  }
}

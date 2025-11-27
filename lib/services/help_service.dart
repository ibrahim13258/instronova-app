import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HelpService extends GetxService {
// TODO: Replace GetX navigation: static HelpService get to => Get.find();

  // Observables for state
  var isLoading = false.obs;
  var helpTopics = <HelpTopic>[].obs;
  var aboutInfo = Rxn<AboutInfo>();
  var errorMessage = ''.obs;

  // Fetch Help Center Topics
  Future<void> fetchHelpTopics() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await http.get(Uri.parse('https://api.example.com/help'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        helpTopics.value = data.map((e) => HelpTopic.fromJson(e)).toList();
      } else {
        errorMessage.value = 'Failed to load help topics';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch About Information
  Future<void> fetchAboutInfo() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await http.get(Uri.parse('https://api.example.com/about'));
      if (response.statusCode == 200) {
        aboutInfo.value = AboutInfo.fromJson(json.decode(response.body));
      } else {
        errorMessage.value = 'Failed to load about info';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

// Help Topic Model
class HelpTopic {
  final String id;
  final String title;
  final String description;

  HelpTopic({
    required this.id,
    required this.title,
    required this.description,
  });

  factory HelpTopic.fromJson(Map<String, dynamic> json) {
    return HelpTopic(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// About Info Model
class AboutInfo {
  final String appName;
  final String version;
  final String description;

  AboutInfo({
    required this.appName,
    required this.version,
    required this.description,
  });

  factory AboutInfo.fromJson(Map<String, dynamic> json) {
    return AboutInfo(
      appName: json['app_name'] ?? '',
      version: json['version'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
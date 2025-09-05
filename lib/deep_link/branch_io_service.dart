import 'package:branch_sdk/branch_sdk.dart';

class BranchIOService {
  BranchIOService._privateConstructor();
  static final BranchIOService instance = BranchIOService._privateConstructor();

  // Initialize Branch SDK
  Future<void> initBranch() async {
    BranchSdk.init();
    BranchSdk.listen((map) {
      // Handle deep link payload
      if (map.containsKey('+clicked_branch_link') && map['+clicked_branch_link'] == true) {
        _handleBranchLink(map);
      }
    });
  }

  // Generate Branch deep link with optional data
  Future<String> generateLink({
    required String channel,
    required String feature,
    Map<String, dynamic>? data,
  }) async {
    final linkData = BranchLinkData(
      channel: channel,
      feature: feature,
      data: data ?? {},
    );
    final uri = await BranchSdk.createLink(linkData);
    return uri.toString();
  }

  // Handle incoming deep link
  void _handleBranchLink(Map<dynamic, dynamic> linkData) {
    // Example: navigate to profile or post
    if (linkData.containsKey('screen')) {
      switch (linkData['screen']) {
        case 'profile':
          String userId = linkData['userId'] ?? '';
          // Navigate to profile screen
          // NavigationHelper.pushToProfile(userId); (use your navigation helper)
          break;
        case 'post':
          String postId = linkData['postId'] ?? '';
          // Navigate to post detail screen
          // NavigationHelper.pushToPost(postId);
          break;
        default:
          break;
      }
    }
  }
}

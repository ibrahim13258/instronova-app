class NotificationConstants {
  // Notification types
  static const String like = 'LIKE';
  static const String comment = 'COMMENT';
  static const String follow = 'FOLLOW';
  static const String mention = 'MENTION';
  static const String directMessage = 'DIRECT_MESSAGE';
  static const String postShare = 'POST_SHARE';
  static const String storyView = 'STORY_VIEW';
  static const String friendRequest = 'FRIEND_REQUEST';
  static const String systemAlert = 'SYSTEM_ALERT';

  // Notification messages templates
  static const String likedYourPost = 'liked your post';
  static const String commentedOnPost = 'commented on your post';
  static const String startedFollowingYou = 'started following you';
  static const String mentionedYou = 'mentioned you';
  static const String sentYouMessage = 'sent you a message';
  static const String sharedYourPost = 'shared your post';
  static const String viewedYourStory = 'viewed your story';
  static const String sentFriendRequest = 'sent you a friend request';
  static const String systemAlertMessage = 'Important system notification';

  // Helper to generate full notification message
  static String generateNotificationMessage(String userName, String type) {
    switch (type) {
      case like:
        return '$userName $likedYourPost';
      case comment:
        return '$userName $commentedOnPost';
      case follow:
        return '$userName $startedFollowingYou';
      case mention:
        return '$userName $mentionedYou';
      case directMessage:
        return '$userName $sentYouMessage';
      case postShare:
        return '$userName $sharedYourPost';
      case storyView:
        return '$userName $viewedYourStory';
      case friendRequest:
        return '$userName $sentFriendRequest';
      case systemAlert:
        return '$systemAlertMessage';
      default:
        return 'You have a new notification';
    }
  }
}

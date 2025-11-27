// GetX removed for Provider consistency
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends GetxController {
  // List of notifications
  var notifications = <NotificationModel>[].obs;

  // Unread notifications count
  var unreadCount = 0.obs;

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifications from API/service
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      var fetchedNotifications = await NotificationService.getNotifications();
      notifications.assignAll(fetchedNotifications);
      unreadCount.value =
          notifications.where((notif) => !notif.isRead).length;
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Mark single notification as read
  void markAsRead(String notificationId) {
    var index =
        notifications.indexWhere((notif) => notif.id == notificationId);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh();
      unreadCount.value =
          notifications.where((notif) => !notif.isRead).length;
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notif in notifications) {
      notif.isRead = true;
    }
    notifications.refresh();
    unreadCount.value = 0;
  }

  // Add a new notification (e.g., from push)
  void addNotification(NotificationModel newNotif) {
    notifications.insert(0, newNotif);
    unreadCount.value =
        notifications.where((notif) => !notif.isRead).length;
  }
}

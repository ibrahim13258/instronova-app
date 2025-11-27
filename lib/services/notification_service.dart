// GetX removed for Provider consistency
import 'package:dio/dio.dart';
import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final Dio _dio = Dio();
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;

  // Getter
  List<NotificationModel> get notifications => _notifications;

  // Fetch all notifications for a user
  Future<void> fetchNotifications(String userId) async {
    try {
      Response response = await _dio.get('https://api.example.com/users/$userId/notifications');
      _notifications.value = (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  // Mark a single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.put('https://api.example.com/notifications/$notificationId/read');
      int index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index].isRead = true;
        _notifications.refresh();
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      await _dio.put('https://api.example.com/users/$userId/notifications/read_all');
      for (var notification in _notifications) {
        notification.isRead = true;
      }
      _notifications.refresh();
    } catch (e) {
      print("Error marking all notifications as read: $e");
    }
  }

  // Optional: Real-time update simulation using polling (or websocket in real app)
  void startNotificationPolling(String userId, {Duration interval = const Duration(seconds: 30)}) {
    Future.delayed(interval, () async {
      await fetchNotifications(userId);
      startNotificationPolling(userId, interval: interval);
    });
  }
}

import 'package:intl/intl.dart';

class DateTimeHelper {
  /// Format a DateTime to a readable string
  /// Example: "Aug 5, 2025", "05 Aug 2025", "05/08/2025"
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return date.toString();
    }
  }

  /// Format time to 12h or 24h
  /// Example: "02:30 PM" or "14:30"
  static String formatTime(DateTime date, {String format = 'hh:mm a'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return date.toString();
    }
  }

  /// Get relative time string
  /// Example: "2 hours ago", "5 minutes ago", "Yesterday"
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(date);
    }
  }

  /// Convert Unix timestamp (seconds) to DateTime
  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  /// Convert DateTime to Unix timestamp (seconds)
  static int toTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch ~/ 1000;
  }
}

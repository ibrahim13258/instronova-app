import 'package:intl/intl.dart';

class DateUtilsHelper {
  // Convert DateTime to formatted string (e.g., "12 Aug 2025")
  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(date);
    } catch (e) {
      return date.toString();
    }
  }

  // Parse string to DateTime
  static DateTime? parseDate(String dateString, {String pattern = 'yyyy-MM-dd'}) {
    try {
      final formatter = DateFormat(pattern);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Calculate "time ago" string (e.g., "5 minutes ago", "2 days ago")
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date); // Show formatted date if older than a week
    }
  }

  // Example: Convert timestamp to DateTime and then to "time ago"
  static String timeAgoFromString(String dateString, {String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    final date = parseDate(dateString, pattern: pattern);
    if (date == null) return dateString;
    return timeAgo(date);
  }
}

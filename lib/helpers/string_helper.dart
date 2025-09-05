class StringHelper {
  StringHelper._privateConstructor();
  static final StringHelper instance = StringHelper._privateConstructor();

  /// Capitalize the first letter of a string
  String capitalize(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  /// Capitalize each word in a sentence
  String capitalizeWords(String input) {
    if (input.isEmpty) return '';
    return input
        .split(' ')
        .map((word) => word.isNotEmpty ? capitalize(word) : '')
        .join(' ');
  }

  /// Truncate string to a given length and add ellipsis
  String truncate(String input, {int maxLength = 50, String ellipsis = '...'}) {
    if (input.length <= maxLength) return input;
    return input.substring(0, maxLength) + ellipsis;
  }

  /// Format number to K, M, B format (e.g., 1500 → 1.5K)
  String formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  /// Remove extra whitespaces
  String removeExtraSpaces(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

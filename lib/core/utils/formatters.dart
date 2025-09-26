import 'package:intl/intl.dart';

class Formatters {
  // Date formatters
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatDateTime(DateTime dateTime, {String pattern = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }

  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(time);
  }

  static String formatDateRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Currency formatters
  static String formatCurrency(double amount, {String symbol = '\$', int decimalPlaces = 2}) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    ).format(amount);
  }

  static String formatPrice(double price) {
    if (price % 1 == 0) {
      return '\$${price.toStringAsFixed(0)}';
    } else {
      return '\$${price.toStringAsFixed(2)}';
    }
  }

  // Number formatters
  static String formatNumber(num number, {int decimalPlaces = 0}) {
    return NumberFormat('#,##0.${'0' * decimalPlaces}').format(number);
  }

  static String formatCompactNumber(num number) {
    return NumberFormat.compact().format(number);
  }

  static String formatPercentage(double percentage, {int decimalPlaces = 1}) {
    return NumberFormat.percentPattern().format(percentage / 100);
  }

  // Phone number formatter
  static String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11 && phoneNumber.startsWith('1')) {
      return '+1 (${phoneNumber.substring(1, 4)}) ${phoneNumber.substring(4, 7)}-${phoneNumber.substring(7)}';
    }
    
    return phoneNumber;
  }

  // Text formatters
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map(capitalizeFirst).join(' ');
  }

  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  // File size formatter
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${suffixes[i]}';
  }
}

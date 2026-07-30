class DateFormatter {
  static String formatPersianDate(String date) {
    try {
      if (date.isEmpty) return '';

      final parts = date.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '$year/$month/$day';
      }
      return date;
    } catch (_) {
      return date;
    }
  }

  static String formatUnixTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).toLocal();

    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  static String toPersianDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  static String calculateReadTime(String content) {
    if (content.isEmpty) return 'زمان مطالعه: کمتر از ۱ دقیقه';

    final cleanContent = _stripHtmlTags(content);

    final wordCount = _countWords(cleanContent);

    const readingSpeed = 200;
    final minutes = (wordCount / readingSpeed).ceil();

    if (minutes == 0) {
      return 'زمان مطالعه: کمتر از ۱ دقیقه';
    } else if (minutes == 1) {
      return 'زمان مطالعه: ۱ دقیقه';
    } else {
      return 'زمان مطالعه: $minutes دقیقه';
    }
  }

  static String _stripHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), ' ').trim();
  }

  static int _countWords(String text) {
    if (text.isEmpty) return 0;

    final cleanText = text.replaceAll(RegExp(r'[،\n\r\t]'), ' ');

    final words = cleanText
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    return words.length;
  }

  static String getReadTimeFromContent(String content) {
    return calculateReadTime(content);
  }
}

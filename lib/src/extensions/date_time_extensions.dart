/// Ergonomic convenience extensions on [DateTime].
extension DateTimeExtensions on DateTime {
  /// Formats date to `YYYY-MM-DD`.
  String toIsoDateString() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Formats date to `MMM DD, YYYY` (e.g. `Aug 24, 2026`).
  String toReadableDate() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[month - 1]} $day, $year';
  }

  /// Calculates human-readable relative time (e.g. `2 hours ago`, `Just now`).
  String toTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return toReadableDate();
    }
    if (difference.inSeconds < 45) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return toReadableDate();
    }
  }

  /// Whether this DateTime represents today's date.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

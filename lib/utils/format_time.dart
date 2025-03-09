class FormatTime {
  static String formatTime(DateTime? time) {
    if (time == null) {
      return '';
    }
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) {
      return '';
    }
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
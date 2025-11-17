String formatChatDate(DateTime t) {
  final hour = t.hour.toString().padLeft(2, '0');
  final minute = t.minute.toString().padLeft(2, '0');
  final day = t.day.toString().padLeft(2, '0');
  final month = t.month.toString().padLeft(2, '0');
  final year = t.year;

  return "$hour:$minute • $day/$month/$year";
}

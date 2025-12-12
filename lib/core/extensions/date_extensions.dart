extension TimeAgoExtension on DateTime {
  String timeAgoDaysOnly() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays >= 1) {
      return '${difference.inDays}';
    } else {
      return '0';
    }
  }
}

extension StringExtension on String {
  bool get isArabic {
    if (trim().isEmpty) return false;
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    final englishRegex = RegExp(r'[A-Za-z]');
    int arabicCount = arabicRegex.allMatches(this).length;
    int englishCount = englishRegex.allMatches(this).length;
    return arabicCount > englishCount;
  }

  /// Returns `null` when this string is empty or blank; otherwise returns `this`.
  String? get nullIfEmpty => trim().isEmpty ? null : this;
}


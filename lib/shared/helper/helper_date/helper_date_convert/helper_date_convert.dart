import 'package:intl/intl.dart';

class HelperDateConvert {
  static const String _uiPatternWithMinute = 'yyyy-MM-dd HH:mm:ss';
  static const String _uiPatternDateOnly = 'yyyy-MM-dd';

  static DateTime toDateTime(dynamic dateRaw) {
    if (dateRaw is DateTime) return dateRaw;
    if (dateRaw == null || dateRaw.toString().isEmpty) return DateTime.now();

    final parsedIso = DateTime.tryParse(dateRaw.toString());
    if (parsedIso != null) return parsedIso;

    try {
      return DateFormat(_uiPatternWithMinute).parse(dateRaw.toString());
    } catch (_) {
      try {
        return DateFormat(_uiPatternDateOnly).parse(dateRaw.toString());
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  static String toDisplayUI({DateTime? date, bool withMinute = false}) {
    final safeDate = date ?? DateTime.now();
    final pattern = withMinute ? _uiPatternWithMinute : _uiPatternDateOnly;
    return DateFormat(pattern).format(safeDate);
  }

  static String toJsonISO(DateTime? date) {
    final safeDate = date ?? DateTime.now();
    return safeDate.toIso8601String();
  }
}

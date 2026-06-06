DateTime dateYMDEndBLOC(DateTime? dateTime) {
  return dateTime != null
      ? DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999)
      : dateNowYMDBLOC(statusEnd: true);
}

DateTime dateYMDStartBLOC(DateTime? dateTime) {
  return dateTime != null
      ? DateTime(dateTime.year, dateTime.month, dateTime.day, 00, 00, 00, 000)
      : dateNowYMDBLOC();
}

DateTime dateNowYMDBLOC({bool? statusEnd}) {
  final end = statusEnd ?? false;
  final now = DateTime.now();
  return end
      ? DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
      : DateTime(now.year, now.month, now.day, 00, 00, 00, 000);
}

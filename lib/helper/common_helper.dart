import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String formatPriceRp(double nominal) {
  final nominalfinal = formatQtyOrPrice(nominal)
      .replaceAll("R", "")
      .replaceAll(".", "")
      .replaceAll(",", "")
      .replaceAll("R", "");
  final format = NumberFormat.currency(
    locale: 'id',
    decimalDigits: 2,
    symbol: 'Rp',
  );
  final convertnominal = double.tryParse(nominalfinal);
  return format.format(convertnominal);
}

String formatQtyOrPrice(double qty) {
  final format = NumberFormat("##.##");
  return format.format(qty);
}

String formatDisc(int disc) {
  return "(-$disc%)";
}

// class UserSession {
//   static DataUserRepositoryCache? repo;
//   static String uid_owner = "";
//   static bool? fifo;
//   static StockMode? selectedStockMode;

//   static Future<void> init() async {
//     final pref = await SharedPreferences.getInstance();
//     uid_owner = pref.getString("uid_owner")!;
//     fifo = pref.getBool("fifo") ?? false;
//     selectedStockMode = StockModeX.fromString(
//       pref.getString("stockMode") ?? StockMode.FIFO.name,
//     )!;
//   }

//   static String getUidOwner() {
//     return uid_owner;
//   }

//   static StockMode getSelectedStockMode() {
//     return selectedStockMode!;
//   }

//   static bool getStatusFifo() {
//     return fifo!;
//   }
// }

String generateInvoice({
  required String idOP,
  String? branchId,
  int? queue,
  bool? saved,
}) {
  final branch = branchId!.substring(0, 4);
  final uuid = saved != null ? "Saved" : Uuid().v4().substring(0, 4);
  final operator = idOP.substring(0, 4);
  devLog("Log Function: GenerateInvoice: $queue");
  return "$operator-$branch-$queue-$uuid";
}

String formatDate({required DateTime date, bool? minute}) {
  final useMinute = minute ?? true;
  final pattern = useMinute ? 'dd-MM-yyyy HH:mm:ss' : 'dd-MM-yyyy';
  return DateFormat(pattern).format(date);
}

DateTime parseDate({dynamic date, bool minute = true}) {
  if (date is DateTime) return date;

  final pattern = minute ? 'dd-MM-yyyy HH:mm:ss' : 'dd-MM-yyyy';
  return DateFormat(pattern).parse(date);
}

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

void devLog(String message) {
  assert(() {
    debugPrint(message);
    return true;
  }());
}

import 'package:flutter/material.dart';

class AppPropertyColor {
  static const Color primary = Color.fromARGB(249, 110, 161, 111);
  static const Color primaryLight1 = Color.fromARGB(248, 208, 255, 208);
  static const Color primaryLight2 = Color.fromARGB(248, 173, 255, 173);
  static const Color primaryLight3 = Color.fromARGB(248, 227, 255, 227);
  static const Color primaryMoreLight = Color.fromARGB(248, 243, 255, 243);
  static const Color red = Color.fromARGB(248, 245, 51, 51);
  static const Color secondPrimary = Color.fromARGB(255, 255, 154, 72);
  static const Color secondPrimaryLight = Color.fromARGB(255, 255, 223, 196);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color blackLight = Color.fromARGB(66, 0, 0, 0);
  static const Color greyLight = Color.fromARGB(255, 226, 226, 226);
  static const Color grey = Color.fromARGB(255, 117, 117, 117);
  static const Color transparent = Color.fromARGB(0, 0, 0, 0);
  static const Color green = Color.fromARGB(225, 76, 1775, 80);
}

class AppPropertyText {
  static const String appName = "Ringkas Task Manager";
  static const String manualDelete =
      "Panduan: Geser ke kiri untuk hapus data yang diinginkan.";
}

// extension AppThemeExtension on BuildContext {
//   Color getDynamicColor<T extends BlocBase<Object?>>(
//     bool Function(Object? state) selector,
//   ) {
//     final bool condition = select<T, bool>((bloc) => selector(bloc.state));

//     return condition
//         ? AppPropertyColor.primary
//         : AppPropertyColor.secondPrimary;
//   }

//   Color get colorHistAdjustment => getDynamicColor<HistoryAdjustmentBloc>(
//     (state) => state is HistoryAdjustmentLoaded && state.isAdjustmentIn,
//   );

//   Color get colorTrans => getDynamicColor<TransactionBloc>(
//     (state) => state is TransactionLoaded && state.isSell,
//   );

//   Color get colorAdjustment => getDynamicColor<AdjustmentBloc>(
//     (state) => state is AdjustmentLoaded && state.isAdjustIn,
//   );

//   Color get colorTransFinance => getDynamicColor<TransFinancialBloc>(
//     (state) => state is TransFinancialLoaded ? state.isIncome : true,
//   );

//   Color get colorFinance => getDynamicColor<FinancialBloc>(
//     (state) => state is FinancialLoaded ? state.isIncome : true,
//   );

//   Color get colorPartner => getDynamicColor<PartnerBloc>(
//     (state) => state is PartnerLoaded ? state.isCustomer : true,
//   );

//   Color get colorHist => getDynamicColor<HistoryTransactionBloc>(
//     (state) => state is HistoryTransactionLoaded ? state.isSell : true,
//   );
//   Color get colorHistFinance => getDynamicColor<HistoryFinancialBloc>(
//     (state) => state is HistoryFinancialLoaded ? state.isIncome : true,
//   );

//   Color get colorReport => getDynamicColor<ReportBloc>(
//     (state) => state is ReportLoaded ? state.isSell : true,
//   );
// }

class AppPropertyBorderRadius {
  static final rounded10 = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static final buttonShape = WidgetStatePropertyAll<OutlinedBorder>(rounded10);
}

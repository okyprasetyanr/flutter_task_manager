import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';

Future<void> customDatePicker({
  required bool dateEnd,
  required String text,
  required BuildContext context,
  required DateTime selectedDate,
  required Function(DateTime) picked,
}) async {
  DateTime? pick = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    helpText: text,
    cancelText: "Batal",
    confirmText: "Selesai",
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            confirmButtonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(AppPropertyColor.primary),
            ),
            cancelButtonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(AppPropertyColor.red),
            ),
            headerHelpStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
            ),
            dayStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: AppPropertyColor.white,
            ),
            yearStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: AppPropertyColor.primary,
            ),
          ),
          dialogTheme: DialogThemeData(backgroundColor: AppPropertyColor.black),
          colorScheme: ColorScheme.light(
            primary: AppPropertyColor.primary,
            onPrimary: AppPropertyColor.white,
            onSurface: AppPropertyColor.black,
            surface: AppPropertyColor.white,
          ),
        ),
        child: child!,
      );
    },
  );
  if (pick != null) {
    picked(pick);
  }
}

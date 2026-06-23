import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void customSnackBar(BuildContext context, String text, {bool top = false}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  top
      ? showTopSnackBar(
          Overlay.of(context),
          Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppPropertyColor.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                text,
                style: lv05TextStyleWhite,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      : ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text, style: lv05TextStyleWhite),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppPropertyColor.primary,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 32),
          ),
        );
}

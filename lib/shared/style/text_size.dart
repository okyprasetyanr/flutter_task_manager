import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';

final labelTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w500,
  fontSize: 11,
);

final hintTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w100,
  fontSize: 10,
);

final titleTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w900,
  fontSize: 17,
);

final subTitleTextStyleBold = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

final titleTextStyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w600,
  fontSize: 15,
);

final subTitleTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w900,
  fontSize: 15,
);

final transactionSuccessTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w700,
  fontSize: 20,
  shadows: [
    Shadow(
      offset: Offset(2, 2),
      blurRadius: 4,
      color: AppPropertyColor.black.withValues(alpha: 0.2),
    ),
  ],
);

final transactionSuccessPaidTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w600,
  fontSize: 12,
  shadows: [
    Shadow(
      offset: Offset(2, 2),
      blurRadius: 4,
      color: AppPropertyColor.primary.withValues(alpha: 0.4),
    ),
  ],
);

final buttonTextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w600,
  fontSize: 17,
);

final lv05TextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 10,
);

final lv05TextStyleDisable = GoogleFonts.poppins(
  color: const Color.fromARGB(255, 117, 117, 117),
  fontWeight: FontWeight.w300,
  fontSize: 10,
);

final lv05TextStyleOrderedItem = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w400,
  fontSize: 10,
);

final lv05TextStyleItalic = GoogleFonts.poppins(
  fontStyle: FontStyle.italic,
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 9,
);

final lv05TextStyleRed = GoogleFonts.poppins(
  color: AppPropertyColor.red,
  fontWeight: FontWeight.w300,
  fontSize: 10,
);

final lv05TextStyleRedPrice = GoogleFonts.poppins(
  color: AppPropertyColor.red,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv05TextStyleBoldRed = GoogleFonts.poppins(
  color: AppPropertyColor.red,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv05TextStylePrimary = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w400,
  fontSize: 10,
);

final lv05TextStyleBoldPrimary = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv05TextStyleBold = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv05TextStyleBoldWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv1TextStylePrimaryPrice = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w800,
  fontSize: 12,
);

final lv05TextStyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w300,
  fontSize: 10,
);

final textStyleItemCondiment = GoogleFonts.poppins(
  textStyle: TextStyle(
    backgroundColor: AppPropertyColor.grey,
    color: AppPropertyColor.white,
    fontWeight: FontWeight.w400,
    fontSize: 10,
  ),
);

final textStyleItemNormal = GoogleFonts.poppins(
  textStyle: const TextStyle(
    backgroundColor: AppPropertyColor.primary,
    color: AppPropertyColor.white,
    fontWeight: FontWeight.w400,
    fontSize: 10,
  ),
);

final lv1TextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 12,
);

final lv1TextStylePrimary = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w300,
  fontSize: 12,
);

final lv1TextStyleRed = GoogleFonts.poppins(
  color: AppPropertyColor.red,
  fontWeight: FontWeight.w300,
  fontSize: 12,
);

final lv1TextStyleBold = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

final lv1TextStyleBoldItalic = GoogleFonts.poppins(
  fontStyle: FontStyle.italic,
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

final lv05textStylePrice = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv05textStylePriceCondiment = GoogleFonts.poppins(
  color: AppPropertyColor.secondPrimary,
  fontWeight: FontWeight.w600,
  fontSize: 10,
);

final lv1TextStyleDisable = GoogleFonts.poppins(
  color: const Color.fromARGB(255, 117, 117, 117),
  fontWeight: FontWeight.w300,
  fontSize: 12,
);

final lv1TextStyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w300,
  fontSize: 12,
);

final lv1TextStyleWhiteBold = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w600,
  fontSize: 12,
);

final lv0TextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 10,
);

final lv0TextStyleRED = GoogleFonts.poppins(
  color: const Color.fromARGB(255, 255, 0, 0),
  fontWeight: FontWeight.w300,
  fontSize: 11,
);

final lv2TextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 16,
);

final lv2TextStyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w500,
  fontSize: 16,
);

final lv2textStylePrice = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w900,
  fontSize: 12,
);

final lv3TextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 16,
);

final lv3TextStyleWhiteBold = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w500,
  fontSize: 16,
);

final lv4TextStyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final lv4TextStylePrimary = GoogleFonts.poppins(
  color: AppPropertyColor.primary,
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final lv4TextStyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final lvMediumstyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w300,
  fontSize: 20,
);

final lvMediumstyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 20,
);

final lvLargestyle = GoogleFonts.poppins(
  color: AppPropertyColor.black,
  fontWeight: FontWeight.w300,
  fontSize: 30,
);

final lvLargeststyleWhite = GoogleFonts.poppins(
  color: AppPropertyColor.white,
  fontWeight: FontWeight.w300,
  fontSize: 30,
);

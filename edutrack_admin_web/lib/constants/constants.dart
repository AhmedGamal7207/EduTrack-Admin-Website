import 'package:flutter/material.dart';

class Constants {
  // Colors
  static const Color primaryColor = Color(0xFF379EAB);
  static const Color bgColor = Color(0xFFE6EBEE);
  static const Color menuSelectionColor = Color(0x26FFFFFF);
  static const Color tableHeaderColor = Color(0x1A379EAB);
  static const Color cardBackgroundColor = Color(0xFF379EAB);
  static const Color separatorColor = Color(0x4D8F8F8F);

  static const Color orangeColor = Color(0xFFFB7D5B);
  static const Color yellowColor = Color(0xFFFCC43E);
  static const Color blueColor = Color(0xFF574AE2);
  static const Color greenColor = Color(0xFF14AE5C);
  static const Color redColor = Color(0xFFEC221F);
  static const Color greyColor = Color(0xFFE3E3E3);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Colors.black;

  // Font Weights
  static const FontWeight poppinsLight = FontWeight.w100;
  static const FontWeight poppinsRegular = FontWeight.w400;
  static const FontWeight poppinsMedium = FontWeight.w500;
  static const FontWeight poppinsBold = FontWeight.w700;

  // Text Styles
  static TextStyle poppinsFont(
    FontWeight poppinsWeight,
    double size,
    Color color, [
    FontStyle? style,
    double? letterSpacing,
  ]) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: poppinsWeight,
    fontSize: size,
    color: color,
    fontStyle: style,
    letterSpacing: letterSpacing,
  );

  static TextStyle mainHeading = Constants.poppinsFont(
    Constants.poppinsBold,
    26,
    Constants.primaryColor,
  );

  static TextStyle subHeading = Constants.poppinsFont(
    Constants.poppinsBold,
    20,
    Constants.primaryColor,
  );

  static const double internalSpacing = 40;
  static const double pagePadding = 40;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restauran_submission_1/style/colors.dart';

class RestaurantTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: CustomColors.green.color,
      brightness: Brightness.light,
      textTheme: GoogleFonts.quicksandTextTheme(Typography.blackHelsinki),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: CustomColors.green.color,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.quicksandTextTheme(Typography.whiteHelsinki),
      useMaterial3: true,
    );
  }
}

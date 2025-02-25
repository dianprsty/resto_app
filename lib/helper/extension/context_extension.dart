import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
    required String message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(
        snackBar(
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
        ),
      );
}

SnackBar snackBar({
  String message = '',
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
}) {
  return SnackBar(
    duration: Durations.medium4,
    backgroundColor: backgroundColor,
    content: Text(
      message,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}

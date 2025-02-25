import 'package:flutter/material.dart';

enum CustomColors {
  green("Green", Colors.green);

  const CustomColors(this.name, this.color);

  final String name;
  final Color color;
}

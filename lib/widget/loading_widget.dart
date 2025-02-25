import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final double iconSize;
  final double textSize;
  const Loading({
    super.key,
    this.iconSize = 75,
    this.textSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Lottie.asset('assets/lotties/rocket.json',
            width: iconSize, height: iconSize),
        Text(
          "Loading...",
          style: TextStyle(fontSize: textSize),
        ),
      ],
    );
  }
}

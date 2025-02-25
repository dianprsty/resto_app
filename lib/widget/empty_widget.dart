import 'package:flutter/material.dart';

class EmptyIndicator extends StatelessWidget {
  final String message;
  final double imageSize;
  final double textSize;
  final bool canRefresh;
  final VoidCallback? onPressed;

  const EmptyIndicator({
    super.key,
    this.message = "Restaurants Not Found",
    this.imageSize = 250,
    this.textSize = 16,
    this.canRefresh = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/search.png",
          width: imageSize,
          height: imageSize,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 10, 8),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        canRefresh
            ? ElevatedButton(
                onPressed: onPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(Icons.refresh),
                    const Text("Refresh"),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

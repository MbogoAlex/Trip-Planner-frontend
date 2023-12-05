import 'package:flutter/material.dart';
import 'package:orchestrator/utils/dimensions.dart';

class HeadingText extends StatelessWidget {
  final String text;
  const HeadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenHeight(24),
      ),
    );
  }
}

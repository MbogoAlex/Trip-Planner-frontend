import 'package:flutter/material.dart';
import 'package:orchestrator/utils/dimensions.dart';

class NormalText extends StatelessWidget {
  final String text;
  const NormalText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: screenHeight(14),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

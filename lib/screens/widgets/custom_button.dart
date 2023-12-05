import 'package:flutter/material.dart';
import 'package:orchestrator/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderSize;
  final Color borderColor;
  const CustomButton(
      {super.key,
      required this.width,
      required this.height,
      required this.text,
      required this.onPressed,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.borderSize,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(
            foregroundColor,
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(
            backgroundColor,
          ),
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStateProperty.all<OutlinedBorder?>(
            RoundedRectangleBorder(
              side: BorderSide(
                width: borderSize,
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenHeight(16),
          ),
        ),
      ),
    );
  }
}

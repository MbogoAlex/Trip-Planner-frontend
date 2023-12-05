import 'package:flutter/material.dart';
import 'package:orchestrator/utils/dimensions.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String inputHeading;
  final String hintText;
  final int? maxLines;
  final double formHeight;
  final bool centered;
  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.inputHeading,
    required this.hintText,
    required this.maxLines,
    required this.formHeight,
    required this.centered,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputHeading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenHeight(18),
          ),
        ),
        SizedBox(
          height: screenHeight(10),
        ),
        Container(
          height: widget.formHeight,
          width: double.infinity,
          padding: EdgeInsets.only(left: screenWidth(10)),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: screenWidth(1)),
              top: BorderSide(width: screenWidth(1)),
              right: BorderSide(width: screenWidth(1)),
              bottom: BorderSide(width: screenWidth(1)),
            ),
          ),
          child: widget.centered
              ? Center(
                  child: TextField(
                    controller: widget.controller,
                    maxLines: widget.maxLines,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                    ),
                  ),
                )
              : TextField(
                  controller: widget.controller,
                  maxLines: widget.maxLines,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                  ),
                ),
        ),
      ],
    );
  }
}

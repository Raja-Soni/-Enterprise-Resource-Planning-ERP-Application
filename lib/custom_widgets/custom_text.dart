import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double textSize;
  final FontWeight textBoldness;
  final TextAlign? alignment;

  const CustomText({
    super.key,
    required this.text,
    this.textColor,
    this.textSize = 18.0,
    this.alignment,
    this.textBoldness = FontWeight.normal,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: alignment,
      text,
      style: TextStyle(
        color: textColor,
        fontSize: textSize,
        fontWeight: textBoldness,
      ),
    );
  }
}

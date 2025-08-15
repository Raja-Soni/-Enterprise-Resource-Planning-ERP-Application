import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color focusColor;
  final Color splashColor;
  final double borderRadius;
  final String buttonText;
  final Color textColor;
  final FontWeight textBoldness;
  final VoidCallback callback;
  final String? givenHeroTag;
  final double? height;
  final double? width;
  final double buttonTextSize;

  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.backgroundColor = Colors.blue,
    this.focusColor = Colors.yellow,
    this.splashColor = Colors.green,
    this.borderRadius = 20.0,
    required this.buttonText,
    required this.callback,
    this.textColor = Colors.white,
    this.textBoldness = FontWeight.bold,
    this.buttonTextSize = 20,
    this.givenHeroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FloatingActionButton(
        heroTag: givenHeroTag,
        onPressed: () {
          callback();
        },
        backgroundColor: backgroundColor,
        splashColor: splashColor,
        focusColor: focusColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CustomText(
          text: buttonText,
          textColor: textColor,
          textBoldness: textBoldness,
          textSize: buttonTextSize,
        ),
      ),
    );
  }
}

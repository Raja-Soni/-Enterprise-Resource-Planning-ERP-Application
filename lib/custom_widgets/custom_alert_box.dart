import 'package:erp_mini_app/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAlertBox extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color? buttonTextColor;

  const CustomAlertBox({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = "OK",
    this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomText(text: title, textBoldness: FontWeight.bold),
      content: CustomText(text: message, textSize: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: CustomText(text: confirmText, textColor: buttonTextColor),
        ),
      ],
    );
  }
}

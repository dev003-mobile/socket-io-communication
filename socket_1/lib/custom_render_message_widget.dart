import 'package:flutter/material.dart';

class CustomRenderMessageInfo {
  static render({
    required BuildContext context, 
    Color? color,
    Duration? duration,
    required String message
  }) {
    Size size = MediaQuery.sizeOf(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color ?? Colors.red,
      dismissDirection: DismissDirection.horizontal,
      duration: duration ?? const Duration(seconds: 3),
      content: Text(
        message,  
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size.height * .02,
          color: Colors.white,
          fontWeight: FontWeight.w600
        )
      )
    ));
  }
}
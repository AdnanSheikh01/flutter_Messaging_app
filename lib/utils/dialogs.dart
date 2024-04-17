import 'package:flutter/material.dart';

class dialogs {
  static void showSnackBar(
      BuildContext context, String msg, Color color, EdgeInsets margins) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: margins,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )));
  }
}

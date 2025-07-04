import 'package:flutter/material.dart';

class CustomLoader {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          icon: CircularProgressIndicator(),
          title: Text("Loading..."),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}

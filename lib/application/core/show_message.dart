import 'dart:developer';

import 'package:flutter/material.dart';

class ShowMessage {
  static void show(BuildContext context, String message) {
    log(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

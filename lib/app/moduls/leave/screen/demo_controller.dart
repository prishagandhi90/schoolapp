import 'package:flutter/material.dart';

class DemoController {
  // TextEditingController to manage the TextFormField input
  final TextEditingController textController = TextEditingController();

  // Method to validate input
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  // Method to save input value
  String? getInputValue() {
    return textController.text;
  }
}

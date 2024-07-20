import 'package:flutter/material.dart';

class CustomContainerview extends StatelessWidget {
  final String text;
  final String text1;
  const CustomContainerview({super.key, required this.text, required this.text1});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      const Divider(),
      Text(text1)
    ]);
  }
}

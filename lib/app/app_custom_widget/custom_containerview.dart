import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:flutter/material.dart';

class CustomContainerview extends StatelessWidget {
  final String text;
  final String text1;
  const CustomContainerview({super.key, required this.text, required this.text1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12, //15
            fontWeight: FontWeight.w600,
            fontFamily: CommonFontStyle.plusJakartaSans,
          ),
        ),
        const Divider(color: Color.fromARGB(255, 230, 229, 229),),
        Text(
          text1,
          style: TextStyle(
            fontFamily: CommonFontStyle.plusJakartaSans,
          ),
        )
      ]),
    );
  }
}

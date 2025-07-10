import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
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
          textAlign: TextAlign.center,
          style: TextStyle(
            // fontSize: 12, //15
            fontSize: getDynamicHeight(size: 0.014),
            fontWeight: FontWeight.w600,
            fontFamily: CommonFontStyle.plusJakartaSans,
          ),
        ),
        Divider(color: AppColor.lightwhite),
        Text(
          text1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: CommonFontStyle.plusJakartaSans,
          ),
        )
      ]),
    );
  }
}

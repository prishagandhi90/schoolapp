import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';

class AppStyle {
  static TextStyle plus16w600 = TextStyle(
    // fontSize: 16, //25
    fontSize: getDynamicHeight(size: 0.018),
    fontWeight: FontWeight.w600,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plus17w600 = TextStyle(
    // fontSize: 17, //25
    fontSize: getDynamicHeight(size: 0.019),
    fontWeight: FontWeight.w600,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle w50018 = TextStyle(
    // fontSize: 18,
    fontSize: getDynamicHeight(size: 0.020),
    fontWeight: FontWeight.w500,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle fontfamilyplus = TextStyle(
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle blackplus16 = TextStyle(
    // fontSize: 16, //18
    fontSize: getDynamicHeight(size: 0.018),
    color: AppColor.black1,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plus16 = TextStyle(
    // fontSize: 16, //18
    fontSize: getDynamicHeight(size: 0.018),
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plus10 = TextStyle(
    // fontSize: 10, //18
    fontSize: getDynamicHeight(size: 0.012),
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plus14w500 = TextStyle(
    // fontSize: 14, //18
    fontSize: getDynamicHeight(size: 0.016),
    fontWeight: FontWeight.w500,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plus12 = TextStyle(
    // fontSize: 12.0,
    fontSize: getDynamicHeight(size: 0.014),
    overflow: TextOverflow.ellipsis,
    fontFamily: CommonFontStyle.plusJakartaSans,
    fontWeight: FontWeight.w500,
  );
  static TextStyle redfontfamilyplus = TextStyle(
    fontFamily: CommonFontStyle.plusJakartaSans,
    color: AppColor.red,
  );
  static TextStyle plus500 = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle primaryplusw700 = TextStyle(
    color: AppColor.primaryColor,
    fontWeight: FontWeight.w700,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle white = TextStyle(
    fontSize: getDynamicHeight(size: 0.016),
    color: AppColor.white,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle black = TextStyle(
    fontSize: getDynamicHeight(size: 0.016),
    color: AppColor.black,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plusgrey = TextStyle(
    color: AppColor.lightgrey1,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle plusbold16 = TextStyle(
    // fontSize: 16,
    fontSize: getDynamicHeight(size: 0.017),
    fontWeight: FontWeight.bold, // Bold style for heading
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
  static TextStyle blackbold = TextStyle(
    color: AppColor.black,
    fontWeight: FontWeight.bold,
  );
  static TextStyle plusblack20w700 = TextStyle(
    color: AppColor.black,
    // fontSize: 20,
    fontSize: getDynamicHeight(size: 0.022),
    fontWeight: FontWeight.w700,
    fontFamily: CommonFontStyle.plusJakartaSans,
  );
}

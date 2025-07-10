import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/app_custom_widget/common_text.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isDelete;
  final VoidCallback? onPressed;
  final double? radius;
  final Color? bgColor;
  final List<Color>? gradientColors;
  final Color textColor;
  final FontWeight fontWeight;
  final double? fontSize;
  final double? fontLetterSpacing;
  final bool? isLoading;

  AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.radius,
    this.isDelete = false,
    this.bgColor,
    this.gradientColors,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w400,
    this.fontSize,
    this.fontLetterSpacing,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDelete != true ? bgColor ?? AppColor.teal1 : AppColor.red1, // Set transparent color
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(radius ?? 5.0),
        ),
      ),
      child: Container(
        decoration: isDelete != true
            ? BoxDecoration(
                border: Border.all(color: bgColor ?? AppColor.teal1),
                // image: DecorationImage(
                //     image: AssetImage(ConstAsset.gradientButtonImage),
                //     fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(radius ?? 5.0),
              )
            : BoxDecoration(
                border: Border.all(color: AppColor.red1),
                // image: DecorationImage(
                //     image: AssetImage(ConstAsset.gradientDeleteButtonImage),
                //     fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(radius ?? 5.0),
              ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: Sizes.crossLength * .088,
            minHeight: Sizes.crossLength * .050,
          ),
          alignment: Alignment.center,
          child: (isLoading ?? false)
              ? Transform.scale(
                  scale: 0.6,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.white,
                    ),
                  ),
                )
              : AppText(
                  text: text,
                  fontColor: textColor,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? Sizes.px16,
                  letterSpacing: fontLetterSpacing ?? 0,
                  amalfiFontFamily: CommonFontStyle.plusJakartaSans,
                ),
        ),
      ),
    );
  }
}

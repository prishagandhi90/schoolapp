import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/custom_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      this.controller,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.contentPadding,
      this.validator,
      this.keyboardType,
      this.maxLines = 1,
      this.onChanged,
      this.onTap,
      this.isReadOnly = false,
      this.textInputAction = TextInputAction.next,
      this.fillColor,
      this.maxLength,
      this.textCapitalization = TextCapitalization.none,
      this.textInputFormatter,
      this.labelText,
      this.obscureText,
      this.fontSize,
      this.hintFontWeight,
      this.fontColor,
      this.isMandatory = true,
      this.borderColor,
      this.hintFontColor,
      this.borderWidth,
      this.focusNode,
      this.enabled = true,
      this.dividerEnabled = false,
      this.changeDividerColor = false,
      this.textFieldTextAlign,
      this.onEditingComplete,
      this.onTapOutside,
      this.errorBorderColors,
      this.onFieldSubmitted,
      this.autovalidate = false,
      this.borderLineHeight});

  final TextEditingController? controller;

  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;
  final String? hintText;

  final Widget? prefixIcon;
  final bool changeDividerColor;

  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  final EdgeInsetsGeometry? contentPadding;

  final Color? fontColor;
  final Color? hintFontColor;

  final int? maxLines;

  final bool isReadOnly;
  final bool enabled;
  final bool dividerEnabled;

  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;

  final Color? fillColor;

  final int? maxLength;

  final TextCapitalization textCapitalization;

  final List<TextInputFormatter>? textInputFormatter;

  final String? labelText;

  final bool? obscureText;

  final bool isMandatory;

  final double? fontSize;
  final double? borderLineHeight;

  final Color? borderColor;
  final Color? errorBorderColors;
  final ValueChanged<String>? onFieldSubmitted;
  final FontWeight? hintFontWeight;
  final TextAlign? textFieldTextAlign;

  final double? borderWidth;
  final FocusNode? focusNode;
  final Function()? onTap;
  final bool autovalidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      onTap: onTap,
      style: TextStyle(
          fontFamily: CommonFontStyle.plusJakartaSans, color: ConstColor.boldBlackColor, fontSize: Sizes.px14, fontWeight: FontWeight.w400),
      enabled: enabled,
      controller: controller,
      validator: validator,
      autofocus: false,
      maxLines: maxLines,
      onChanged: onChanged,
      readOnly: isReadOnly,
      maxLength: maxLength,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: textCapitalization,
      textAlign: textFieldTextAlign ?? TextAlign.start,
      inputFormatters: textInputFormatter,
      obscureText: obscureText ?? false,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        fillColor: fillColor ?? ConstColor.whiteColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: Sizes.crossLength * 0.010, vertical: Sizes.crossLength * 0.010),
        hintStyle: TextStyle(
          color: hintFontColor ?? ConstColor.hintTextColor,
          fontSize: fontSize ?? Sizes.px14,
          fontWeight: hintFontWeight ?? FontWeight.w400,
          fontFamily: CommonFontStyle.plusJakartaSans,
        ),
        errorMaxLines: 4,
        errorStyle: TextStyle(
          letterSpacing: 1,
          color: ConstColor.errorBorderColor,
          fontSize: fontSize ?? Sizes.px12,
          fontWeight: hintFontWeight ?? FontWeight.w400,
          fontFamily: CommonFontStyle.plusJakartaSans,
        ),
        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(maxHeight: 55, maxWidth: 100, minWidth: 35),

        // prefixIconConstraints: const BoxConstraints.expand(),
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: Get.size.shortestSide < 600
              ? BorderSide(color: borderColor ?? ConstColor.borderColor, width: borderWidth ?? 1)
              : BorderSide(color: borderColor ?? ConstColor.borderColor, width: borderWidth ?? 1),
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.crossLength * 0.010),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: Get.size.shortestSide < 600
              ? BorderSide(color: borderColor ?? ConstColor.borderColor, width: borderWidth ?? 1)
              : BorderSide(color: borderColor ?? ConstColor.borderColor, width: borderWidth ?? 1),
          borderRadius: BorderRadius.all(
            Get.size.shortestSide < 600 ? Radius.circular(Sizes.crossLength * 0.010) : Radius.circular(Sizes.crossLength * 0.010),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: Get.size.shortestSide < 600
              ? BorderSide(color: borderColor ?? ConstColor.borderColor, width: borderWidth ?? 1)
              : BorderSide(color: borderColor ?? ConstColor.borderColor, width: borderWidth ?? 1),
          borderRadius: BorderRadius.all(
            Get.size.shortestSide < 600 ? Radius.circular(Sizes.crossLength * 0.010) : Radius.circular(Sizes.crossLength * 0.010),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: Get.size.shortestSide < 600
              ? BorderSide(color: borderColor ?? ConstColor.errorBorderColor, width: borderWidth ?? 1)
              : BorderSide(color: borderColor ?? ConstColor.errorBorderColor, width: borderWidth ?? 1),
          borderRadius: BorderRadius.all(
            Get.size.shortestSide < 600 ? Radius.circular(Sizes.crossLength * 0.010) : Radius.circular(Sizes.crossLength * 0.010),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: Get.size.shortestSide < 600
              ? BorderSide(color: borderColor ?? ConstColor.errorBorderColor, width: borderWidth ?? 1)
              : BorderSide(color: borderColor ?? ConstColor.errorBorderColor, width: borderWidth ?? 1),
          borderRadius: BorderRadius.all(
            Get.size.shortestSide < 600 ? Radius.circular(Sizes.crossLength * 0.010) : Radius.circular(Sizes.crossLength * 0.010),
          ),
        ),
      ),
      onSaved: (val) {},
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutside,
    );
  }
}

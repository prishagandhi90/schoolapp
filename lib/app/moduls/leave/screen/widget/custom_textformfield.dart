import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool autoFocus;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? showSuffixIcon;
  final Color? fillColor;
  final bool? filled;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? style;
  final ScrollPhysics? scrollPhysics;
  final TextStyle? hintStyle;
  final TapRegionCallback? onTapOutside;

  CustomTextFormField({
    this.label,
    this.hint,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.autoFocus = false,
    this.readOnly = false,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.decoration,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.focusNode,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.showSuffixIcon = false,
    this.fillColor,
    this.filled,
    this.style,
    this.minLines,
    this.scrollPhysics,
    this.hintStyle,
    this.onTapOutside,
    this.focusedBorder,
    this.enabledBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      minLines: minLines, // Use the correct minLines
      maxLines: maxLines, // Set maxLines to null for dynamic height
      autofocus: autoFocus,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      maxLength: maxLength,
      focusNode: focusNode,
      enabled: enabled,
      style: style == null
          ? TextStyle(
              // color: AppColor.white,
              fontFamily: CommonFontStyle.plusJakartaSans,
              fontSize: getDynamicHeight(size: 0.016),
            ) // Default style if not provided
          : style,
      scrollPhysics: scrollPhysics,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
            hintStyle: hintStyle,
            filled: filled ?? false,
            fillColor: fillColor,
            focusedBorder: focusedBorder,
            enabledBorder: enabledBorder,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: (showSuffixIcon ?? false) && suffixIcon != null ? Icon(suffixIcon) : null,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(0),
            ),
          ),
      onTapOutside: onTapOutside ??
          (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
    );
  }
}

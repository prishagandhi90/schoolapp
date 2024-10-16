import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final int? maxLines;
  final FocusNode? focusNode;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? showSuffixIcon;
  final Color? fillColor;
  final bool? filled;
  final TextStyle? style;

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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofocus: autoFocus,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      focusNode: focusNode,
      enabled: enabled,
      style: style,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
            filled: filled ?? false,
            fillColor: fillColor,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: (showSuffixIcon ?? false) && suffixIcon != null ? Icon(suffixIcon) : null,
            border: OutlineInputBorder(),
          ),
    );
  }
}

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';

class CustomAutoComplete<T extends SearchserviceModel> extends StatelessWidget {
  final Future<Iterable<T>> Function(TextEditingValue textEditingValue) optionsBuilder;
  final String Function(T option) displayStringForOption;
  final void Function(T selection) onSelected;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool fromAdmittedScreen;
  final VoidCallback? onSuffixIconPressed;
  final VoidCallback? onClearSuggestions;
  final int? minLines;
  final int? maxLines;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isDense;

  const CustomAutoComplete({
    Key? key,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.onSelected,
    required this.controller,
    this.focusNode,
    this.hintText = 'Search',
    this.onSuffixIconPressed,
    this.onClearSuggestions,
    this.minLines,
    this.maxLines,
    this.hintStyle,
    this.contentPadding,
    this.isDense,
    this.fromAdmittedScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      displayStringForOption: displayStringForOption,
      optionsBuilder: optionsBuilder,
      onSelected: (T selection) {
        onSelected(selection);
        if (onClearSuggestions != null) {
          onClearSuggestions!();
        }
      },
      fieldViewBuilder: (context, textEditingController, localFocusNode, onEditingComplete) {
        final effectiveFocusNode = focusNode ?? localFocusNode;

        // // Sync external controller to internal Autocomplete controller
        // if (controller.text.isNotEmpty && textEditingController.text != controller.text) {
        //   textEditingController.text = controller.text;
        //   textEditingController.selection = TextSelection.fromPosition(
        //     TextPosition(offset: textEditingController.text.length),
        //   );
        // }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.text.isNotEmpty && controller.text != textEditingController.text) {
            textEditingController.text = controller.text;
            textEditingController.selection = TextSelection.collapsed(offset: controller.text.length);
          }
        });

        textEditingController.addListener(() {
          if (textEditingController.text != controller.text) {
            controller.text = textEditingController.text;
          }
        });

        return TextFormField(
          controller: textEditingController,
          focusNode: effectiveFocusNode,
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(fontSize: 14),
          enableInteractiveSelection: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            isDense: isDense,
            contentPadding: contentPadding,
            prefixIcon: Icon(Icons.search, color: AppColor.grey),
            suffixIcon: textEditingController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                    onPressed: () {
                      controller.clear();
                      textEditingController.clear();
                      if (onSuffixIconPressed != null) onSuffixIconPressed!();
                      if (onClearSuggestions != null) onClearSuggestions!();
                      effectiveFocusNode.unfocus();
                    },
                  )
                : null,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.8),
            ),
          ),
          onFieldSubmitted: (_) {
            effectiveFocusNode.unfocus();
            onEditingComplete();
          },
          onTapOutside: (_) => effectiveFocusNode.unfocus(),
        );
      },
    );
  }
}

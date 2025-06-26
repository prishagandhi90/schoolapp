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
  final VoidCallback? onSuffixIconPressed;
  final VoidCallback? onClearSuggestions; // Add callback to clear suggestions
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      displayStringForOption: displayStringForOption,
      optionsBuilder: optionsBuilder,
      onSelected: (T selection) {
        onSelected(selection);
        // controller.clear(); // Clear the controller on selection
        if (onClearSuggestions != null) {
          onClearSuggestions!(); // Clear suggestions if provided
        }
      },
      fieldViewBuilder: (context, textEditingController, localFocusNode, onEditingComplete) {
        // Sync the provided controller with the Autocomplete's controller
        // if (controller != textEditingController) {
        //   textEditingController.text = controller.text;
        //   controller.addListener(() {
        //     if (controller.text != textEditingController.text) {
        //       textEditingController.text = controller.text;
        //     }
        //   });
        //   textEditingController.addListener(() {
        //     if (textEditingController.text != controller.text) {
        //       controller.text = textEditingController.text;
        //     }
        //   });
        // }
          textEditingController.text = controller.text; // bas ek baar assign karo
        return Container(
          child: CustomTextFormField(
            controller: textEditingController, // Use Autocomplete's controller
            minLines: minLines,
            maxLines: maxLines,
            focusNode: focusNode ?? localFocusNode, // Use provided or Autocomplete's focus node
            contentPadding: contentPadding,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              isDense: isDense,
              prefixIcon: Icon(Icons.search, color: AppColor.grey),
              suffixIcon: textEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel_outlined, color: AppColor.black),
                      onPressed: () {
                        textEditingController.clear();
                        if (onSuffixIconPressed != null) {
                          onSuffixIconPressed!();
                        }
                        if (onClearSuggestions != null) {
                          onClearSuggestions!(); // Clear suggestions if provided
                        }
                        localFocusNode.unfocus();
                        SchedulerBinding.instance.addPostFrameCallback((_) {});
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.8),
              ),
            ),
            onFieldSubmitted: (_) {
              localFocusNode.unfocus();
              onEditingComplete();
            },
            onTapOutside: (_) => localFocusNode.unfocus(),
          ),
        );
      },
    );
  }
}

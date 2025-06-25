import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomAutoComplete<T extends Object> extends StatelessWidget {
  final Future<Iterable<T>> Function(TextEditingValue textEditingValue) optionsBuilder;
  final String Function(T option) displayStringForOption;
  final void Function(T selection) onSelected;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final VoidCallback? onSuffixIconPressed;

  const CustomAutoComplete({
    Key? key,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.onSelected,
    required this.controller,
    this.focusNode,
    this.hintText = 'Search',
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final node = focusNode ?? FocusNode();

    return Autocomplete<T>(
      displayStringForOption: displayStringForOption,
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      fieldViewBuilder: (context, textEditingController, localFocusNode, onEditingComplete) {
        return TextFormField(
          controller: textEditingController,
          focusNode: node,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.cancel_outlined, color: Colors.black),
                    onPressed: onSuffixIconPressed ??
                        () {
                          node.unfocus();
                          controller.clear();
                          SchedulerBinding.instance.addPostFrameCallback((_) {});
                        },
                  )
                : null,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.8),
            ),
          ),
          onFieldSubmitted: (_) => node.unfocus(),
          onTapOutside: (_) => node.unfocus(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emp_app/app/core/util/app_color.dart';

class FlexibleMonthPicker extends StatelessWidget {
  final int selectedMonthIndex;
  final Function(int) onMonthSelected;
  final ScrollController scrollController;
  final bool useGetX;
  final GetxController? controller;

  const FlexibleMonthPicker({
    Key? key,
    required this.selectedMonthIndex,
    required this.onMonthSelected,
    required this.scrollController,
    this.useGetX = false,
    this.controller,
  }) : super(key: key);

  static const List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth(context);
    });

    Widget monthPickerContent = _buildMonthPickerContent();

    if (useGetX && controller != null) {
      return GetBuilder<GetxController>(
        init: controller,
        builder: (_) => monthPickerContent,
      );
    } else {
      return monthPickerContent;
    }
  }

  Widget _buildMonthPickerContent() {
    return Center(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onMonthSelected(index),
              child: Container(
                width: 100,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: selectedMonthIndex == index ? AppColor.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  months[index],
                  style: TextStyle(
                    color: selectedMonthIndex == index ? Colors.white : Colors.black,
                    fontWeight: selectedMonthIndex == index ? FontWeight.bold : FontWeight.normal,
                    fontSize: selectedMonthIndex == index ? 18 : 15,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _scrollToSelectedMonth(BuildContext context) {
    if (scrollController.hasClients) {
      final itemWidth = 100.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (selectedMonthIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      if ((offset - scrollController.offset).abs() > 1) {
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
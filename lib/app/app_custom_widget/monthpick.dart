import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/PAYROLL_MAIN/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthPicker extends StatelessWidget {
  final AttendenceController controller;
  final ScrollController scrollController;

  const MonthPicker({
    Key? key,
    required this.controller,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            try {
              final index = controller.MonthSel_selIndex;
              final itemWidth = getDynamicHeight(size: 0.12);
              final screenWidth = MediaQuery.of(context).size.width;
              final listWidth = itemWidth * 12; // Total width of the list
              final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

              // Ensure offset stays within valid range
              final validOffset = offset.clamp(0.0, listWidth - screenWidth).toDouble();

              if ((validOffset - scrollController.offset).abs() > 1) {
                scrollController.animateTo(
                  validOffset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            } catch (e) {
              print('Scroll error: $e');
            }
          }
        });
        return Center(
          child: SizedBox(
            height: getDynamicHeight(size: 0.06),
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.upd_MonthSelIndex(index);
                    controller.showHideMsg();
                  },
                  child: Container(
                    width: getDynamicHeight(size: 0.1),
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.006)),
                    decoration: BoxDecoration(
                      color: controller.MonthSel_selIndex == index ? AppColor.primaryColor : AppColor.transparent,
                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.01)),
                    ),
                    child: Text(
                      getMonthName(index),
                      style: TextStyle(
                        color: controller.MonthSel_selIndex == index ? AppColor.white : AppColor.black,
                        fontWeight: controller.MonthSel_selIndex == index ? FontWeight.bold : FontWeight.normal,
                        // fontSize: controller.MonthSel_selIndex == index ? 18 : 15,
                        fontSize: controller.MonthSel_selIndex == index ? getDynamicHeight(size: 0.020) : getDynamicHeight(size: 0.017),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String getMonthName(int index) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[index];
  }
}

import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/mispunch/controller/mispunch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthPicker_mispunch extends StatelessWidget {
  final MispunchController controller;
  final ScrollController scrollController_Mispunch;

  const MonthPicker_mispunch({
    Key? key,
    required this.controller,
    required this.scrollController_Mispunch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize Sizes
    Sizes.init(context);

    return GetBuilder<MispunchController>(
      builder: (controller) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController_Mispunch.hasClients) {
            try {
              final index = controller.MonthSel_selIndex;
              final itemWidth = getDynamicHeight(size: 0.13); // dynamic width
              final screenWidth = MediaQuery.of(context).size.width;
              final listWidth = itemWidth * 12;
              final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
              final validOffset = offset.clamp(0.0, listWidth - screenWidth).toDouble();

              if ((validOffset - scrollController_Mispunch.offset).abs() > 1) {
                scrollController_Mispunch.animateTo(
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
            height: getDynamicHeight(size: 0.06), // dynamic height (approx 50)
            child: ListView.builder(
              controller: scrollController_Mispunch,
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.upd_MonthSelIndex(index);
                    controller.showHideMsg();
                  },
                  child: Container(
                    width: getDynamicHeight(size: 0.1), // dynamic width (approx 100)
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.007)),
                    decoration: BoxDecoration(
                      color: controller.MonthSel_selIndex == index ? AppColor.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.01)),
                    ),
                    child: Text(
                      getMonthName(index),
                      style: TextStyle(
                        color: controller.MonthSel_selIndex == index ? AppColor.white : AppColor.black,
                        fontWeight: controller.MonthSel_selIndex == index ? FontWeight.bold : FontWeight.normal,
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
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[index];
  }
}

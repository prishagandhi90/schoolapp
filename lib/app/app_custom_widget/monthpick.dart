import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthPicker extends StatelessWidget {
  final AttendenceController controller;
  final ScrollController scrollController;

  MonthPicker({required this.controller, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (scrollController.hasClients) {
    //     double itemWidth = 80; // Adjust this based on your item width
    //     double screenWidth = MediaQuery.of(context).size.width;
    //     double screenCenter = screenWidth / 2;
    //     double selectedMonthPosition = controller.MonthSel_selIndex.value * itemWidth;
    //     double targetScrollPosition = selectedMonthPosition - screenCenter + itemWidth / 2;

    //     // Ensure the calculated position is within valid scroll range
    //     double maxScrollExtent = scrollController.position.maxScrollExtent;
    //     double minScrollExtent = scrollController.position.minScrollExtent;
    //     if (targetScrollPosition < minScrollExtent) {
    //       targetScrollPosition = minScrollExtent;
    //     } else if (targetScrollPosition > maxScrollExtent) {
    //       targetScrollPosition = maxScrollExtent;
    //     }

    //     scrollController.animateTo(
    //       targetScrollPosition,
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });
    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          final index = controller.MonthSel_selIndex.value;
          final itemWidth = 100.0;
          final offset = index * itemWidth;
          scrollController.animateTo(
            offset,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
      return Center(
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(12, (index) {
              return GestureDetector(
                onTap: () {
                  controller.upd_MonthSelIndex(index);
                  controller.showHideMsg();
                  // setState(() {
                  //   widget.selectedMonthIndex = index;
                  // });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: controller.MonthSel_selIndex.value == index
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${getMonthName(index)}',
                            style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Text(
                          '${getMonthName(index)}',
                          style: TextStyle(
                            color: AppColor.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  String getMonthName(int index) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[index];
  }
}

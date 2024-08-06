// ignore_for_file: must_be_immutable

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthSelectionScreen extends StatefulWidget {
  MonthSelectionScreen({
    super.key,
    required this.selectedMonthIndex,
    required this.onPressed,
    required this.scrollController,
  });

  final Function(int) onPressed;
  int selectedMonthIndex;
  final ScrollController scrollController;
  // final Function(int) onSelectedValue;

  @override
  State<MonthSelectionScreen> createState() => _MonthSelectionScreenState();
}

class _MonthSelectionScreenState extends State<MonthSelectionScreen> {
  final AttendenceController attendenceController = Get.put(AttendenceController());

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Ensure the selected month is centered
    //   double itemWidth = MediaQuery.of(context).size.width / 3; // Adjust this based on your item width
    //   widget.scrollController.animateTo(
    //     (widget.selectedMonthIndex * itemWidth) - ((MediaQuery.of(context).size.width / 2) + itemWidth / 2),
    //     duration: Duration(milliseconds: 500),
    //     curve: Curves.easeInOut,
    //   );
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        double itemWidth = 80; // Adjust this based on your item width
        double screenWidth = Get.context!.size!.width;
        double screenCenter = screenWidth / 2;
        double selectedMonthPosition = widget.selectedMonthIndex * itemWidth;
        double targetScrollPosition = selectedMonthPosition - screenCenter + itemWidth / 2;

        // Ensure the calculated position is within valid scroll range
        double maxScrollExtent = widget.scrollController.position.maxScrollExtent;
        double minScrollExtent = widget.scrollController.position.minScrollExtent;
        if (targetScrollPosition < minScrollExtent) {
          targetScrollPosition = minScrollExtent;
        } else if (targetScrollPosition > maxScrollExtent) {
          targetScrollPosition = maxScrollExtent;
        }

        widget.scrollController.animateTo(
          targetScrollPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    return Center(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(months.length, (index) {
            return GestureDetector(
              onTap: () {
                widget.onPressed(index);
                setState(() {
                  widget.selectedMonthIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                // child: attendenceController.MonthSel_selIndex.value == index
                child: widget.selectedMonthIndex == index
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          months[index],
                          style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                        ),
                      )
                    : Text(
                        months[index],
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

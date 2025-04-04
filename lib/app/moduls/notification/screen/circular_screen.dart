import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CircularScreen extends StatelessWidget {
  final int index;
  const CircularScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            title: Text(AppString.circularScreen, style: AppStyle.primaryplusw700),
            centerTitle: true,
          ),
          body: controller.isLoading
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.102)),
                  child: Center(child: ProgressWithIcon()), // Loader dikhana hai
                )
              : controller.notificationlist.isNotEmpty
                  ? Column(
                      children: [
                        Divider(color: AppColor.originalgrey, thickness: 1),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(getDynamicHeight(size: 0.010)), //8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.notificationlist[index].sender.toString(),
                                        style: TextStyle(
                                          color: AppColor.black,
                                          // fontSize: 18,
                                          fontSize: getDynamicHeight(size: 0.020),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      ),
                                      Text(
                                        controller.notificationlist[index].createdDate.toString(),
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: getDynamicHeight(size: 0.016),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: getDynamicHeight(size: 0.012)), //10),
                                  Text(
                                    controller.notificationlist[index].messageTitle.toString(),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                                  Divider(color: AppColor.black, thickness: 1),
                                  SizedBox(height: getDynamicHeight(size: 0.012)), //10),
                                  Text(
                                    controller.notificationlist[index].message.toString(),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// ✅ Ye part bottom pe fixed rahega
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25, left: 15),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 150, // Width like your image
                              height: 100, // Height like your image
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10), // Rounded edges
                                border: Border.all(color: Colors.black), // Black border
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0, -2), // Light shadow
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'FFG.pdf',
                                  style: TextStyle(
                                    color: Colors.black,
                                    // fontSize: 16,
                                    fontSize: getDynamicHeight(size: 0.018),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "No Data Available",
                        style: TextStyle(
                          fontSize: getDynamicHeight(size: 0.020),
                          color: AppColor.black,
                        ),
                      ),
                    ),
        );
      },
    );
  }
}


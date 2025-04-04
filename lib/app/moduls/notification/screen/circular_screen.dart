import 'dart:convert';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
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
            title: Text(
              controller.notificationlist[index].notificationType.toString(),
              style: AppStyle.primaryplusw700,
            ),
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
                        controller.filesList.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: controller.filesList.asMap().entries.map((entry) {
                                    int index = entry.key + 1; // Index ko 1 se start karne ke liye
                                    var file = entry.value;
                                    bool isImage = file["contentType"]!.startsWith("image");

                                    return GestureDetector(
                                      onTap: () => controller.openFile(file["fileName"]!, file["content"]!, file["contentType"]!),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            isImage
                                                ? Image.memory(base64Decode(file["content"]!), width: 100, height: 100, fit: BoxFit.cover)
                                                : Icon(Icons.insert_drive_file, size: 100, color: Colors.blue),
                                            SizedBox(height: 5),
                                            Text("File $index", style: TextStyle(fontSize: 12)), // ✅ Fixed name like "File 1", "File 2"
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
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

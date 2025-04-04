import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/moduls/notification/controller/notification_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/circular_screen.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.white,
          drawer: CustomDrawer(),
          appBar: AppBar(
            backgroundColor: AppColor.white,
            title: controller.isSearching
                ? Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 8),
                            ),
                            style: AppStyle.primaryplusw700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.isSearching = false;
                            controller.searchController.clear();
                            controller.update();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.cancel),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    AppString.notificationScreen,
                    style: AppStyle.primaryplusw700,
                  ),
            centerTitle: true,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    AppImage.drawer,
                    width: getDynamicHeight(size: 0.022),
                    color: AppColor.black,
                  ),
                );
              },
            ),
            actions: [
              Row(
                children: [
                  if (!controller.isSearching) // Search icon tabhi dikhe jab search enable na ho

                    IconButton(
                      onPressed: () {
                        controller.isSearching = true;
                        controller.update();
                      },
                      icon: Icon(Icons.search),
                    ),
                  IconButton(
                    onPressed: () {
                      Get.to(FilterScreen());
                    },
                    icon: Image.asset(
                      AppImage.filter1,
                      width: getDynamicHeight(size: 0.022),
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Divider(
                color: AppColor.black,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.notificationlist.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(CircularScreen(
                          index: index,
                        ));
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              controller.notificationlist[index].sender.toString(),
                              style: TextStyle(
                                color: AppColor.black,
                                // fontSize: 18,
                                fontSize: getDynamicHeight(size: 0.020),
                                fontWeight: FontWeight.bold,
                                fontFamily: CommonFontStyle.plusJakartaSans,
                              ),
                            ),
                            subtitle: Text(controller.notificationlist[index].messageTitle.toString(),
                                style: TextStyle(
                                  color: AppColor.black,
                                  // fontSize: 16,
                                  fontSize: getDynamicHeight(size: 0.018),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                )),
                            trailing: Column(
                              children: [
                                SizedBox(height: 5),
                                Text(controller.notificationlist[index].createdDate.toString(),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      // fontSize: 14,
                                      fontSize: getDynamicHeight(size: 0.016),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    )),
                                SizedBox(height: getDynamicHeight(size: 0.005)), //5),
                                if (controller.notificationlist[index].fileYN == "Y") Icon(Icons.attach_file),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColor.black,
                            height: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

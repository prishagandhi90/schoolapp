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
                          child: TextFormField(
                            focusNode: controller.searchFocusNode,
                            cursorColor: AppColor.black,
                            controller: controller.searchController,
                            // autofocus: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.black, width: 1.5), // ✅ Border on focus
                                borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.02)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.2), // ✅ Default border
                                borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.02)),
                              ),
                              suffixIcon: controller.searchController.text.trim().isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        controller.searchController.clear();
                                        controller.fetchNotificationList();
                                        controller.update();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.cancel, color: Colors.black, size: 24), // ✅ Cancel button color
                                      ),
                                    )
                                  : null,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.search, color: AppColor.black, size: 24), // ✅ Search icon color
                              ),
                              hintText: AppString.search,
                              hintStyle: AppStyle.plusgrey.copyWith(fontSize: 14, color: AppColor.lightgrey1), // ✅ Hint text style
                              filled: true,
                              fillColor: AppColor.white, // ✅ Background color
                            ),
                            onTap: () => controller.update(),
                            onChanged: (value) => controller.filterSearchResults(value),
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                              Future.delayed(const Duration(milliseconds: 300));
                              controller.update();
                            },
                            onFieldSubmitted: (v) {
                              if (controller.searchController.text.trim().isNotEmpty) {
                                controller.fetchNotificationList();
                                controller.searchController.clear();
                              }
                              Future.delayed(const Duration(milliseconds: 800));
                              controller.update();
                            },
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
                      FocusScope.of(context).unfocus();
                      controller.selectedTags.clear();
                      controller.filesList.clear();
                      // controller.fetchNotificationList();
                      Get.to(FilterScreen());
                      controller.update();
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchNotificationList();
                  },
                  child: controller.filternotificationlist.isEmpty
                      ? Center(
                          child: Text(
                            'No Data Found',
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.02),
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.filternotificationlist.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await controller.fetchNotificationFile(index);
                                Get.to(CircularScreen(index: index));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      controller.filternotificationlist[index].sender.toString(),
                                      style: TextStyle(
                                        color: AppColor.black,
                                        // fontSize: 18,
                                        fontSize: getDynamicHeight(size: 0.020),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                    subtitle: Text(controller.filternotificationlist[index].messageTitle.toString(),
                                        style: TextStyle(
                                          color: AppColor.black,
                                          // fontSize: 16,
                                          fontSize: getDynamicHeight(size: 0.016),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        )),
                                    trailing: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 5),
                                          Text(controller.filternotificationlist[index].createdDate.toString(),
                                              style: TextStyle(
                                                color: AppColor.black,
                                                // fontSize: 14,
                                                fontSize: getDynamicHeight(size: 0.014),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              )),
                                          SizedBox(height: getDynamicHeight(size: 0.005)), //5),
                                          if (controller.filternotificationlist[index].fileYN == "Y")
                                            Image.asset(
                                              AppImage.attach,
                                              width: getDynamicHeight(size: 0.022),
                                              height: getDynamicHeight(size: 0.022),
                                              color: AppColor.black,
                                            ),
                                        ],
                                      ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/moduls/notification/controller/notification_controller.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_tag_screen.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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
                    height: getDynamicHeight(size: 0.04),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.08)),
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
                                        child: Icon(Icons.cancel,
                                            color: Colors.black, size: getDynamicHeight(size: 0.024)), // ✅ Cancel button color
                                      ),
                                    )
                                  : null,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10),
                                child:
                                    Icon(Icons.search, color: AppColor.black, size: getDynamicHeight(size: 0.024)), // ✅ Search icon color
                              ),
                              hintText: AppString.search,
                              hintStyle: AppStyle.plusgrey
                                  .copyWith(fontSize: getDynamicHeight(size: 0.014), color: AppColor.lightgrey1), // ✅ Hint text style
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
                    AppString.notification,
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
                            AppString.nodatafound,
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.02),
                              fontWeight: FontWeight.w600,
                              color: AppColor.originalgrey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.filternotificationlist.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                Get.dialog(
                                  Center(child: ProgressWithIcon()),
                                  barrierDismissible: false,
                                );
                                await controller.updateNotificationRead(index);
                                // await controller.fetchNotificationFile(index);
                                // Hide loader
                                Get.back();
                                // Get.to(() => FilterTagScreen(index: index));
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: FilterTagScreen(index: index),
                                  withNavBar: false,
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                ).then((value) async {
                                  await controller.fetchNotificationList();
                                });
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
                                        fontWeight:
                                            controller.filternotificationlist[index].boldYN == "Y" ? FontWeight.bold : FontWeight.normal,

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
                                    height: getDynamicHeight(size: 0.001),
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

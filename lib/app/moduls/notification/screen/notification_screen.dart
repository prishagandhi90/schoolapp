import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/moduls/notification/screen/circular_screen.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.white,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text(AppString.notificationScreen, style: AppStyle.primaryplusw700),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Image.asset(
                AppImage.drawer,
                width: getDynamicHeight(size: 0.022),//20,
                color: AppColor.black,
              ),
            );
          },
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.to(NotificationScreen());
                  },
                  icon: Image.asset(
                    AppImage.notification,
                    width: getDynamicHeight(size: 0.022)//20,
                  )),
              IconButton(
                  onPressed: () {
                    Get.to(FilterScreen());
                  },
                  icon: Icon(Icons.filter_list)),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Divider(
            color: AppColor.black,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(CircularScreen());
              },
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Notification $index',
                      style: TextStyle(
                        color: AppColor.black,
                        // fontSize: 18,
                        fontSize: getDynamicHeight(size: 0.020),
                        fontWeight: FontWeight.bold,
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                    ),
                    subtitle: Text('Notification $index',
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
                        Text('12/12/2021',
                            style: TextStyle(
                              color: AppColor.black,
                              // fontSize: 14,
                              fontSize: getDynamicHeight(size: 0.016),
                              fontWeight: FontWeight.w400,
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            )),
                        SizedBox(height: getDynamicHeight(size: 0.005)),//5),
                        Icon(Icons.attach_file),
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
  }
}

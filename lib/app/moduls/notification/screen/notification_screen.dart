import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/moduls/dashboard/screen/custom_drawer.dart';
import 'package:emp_app/app/moduls/notification/screen/circular_screen.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      onDrawerChanged: (isop) {
        // var bottomBarController = Get.put(BottomBarController());
        hideBottomBar.value = isop;
        // bottomBarController.update();
      },
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text(
          'Notification Screen',
          style: TextStyle(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w700,
            fontFamily: CommonFontStyle.plusJakartaSans,
          ),
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
                width: 20,
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
                    width: 20,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                    ),
                    subtitle: Text('Notification $index',
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        )),
                    trailing: Column(
                      children: [
                        SizedBox(height: 5),
                        Text('12/12/2021',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            )),
                        SizedBox(height: 5),
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

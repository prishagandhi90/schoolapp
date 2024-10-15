import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:flutter/material.dart';

class DutyscheduleScreen extends StatelessWidget {
  const DutyscheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Duty Schedule',
            style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w700, fontFamily: CommonFontStyle.plusJakartaSans),
          ),
          actions: [IconButton(onPressed: () {}, icon: Image.asset(AppImage.notification, width: 20))],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                
              ],
            )
          ],
        ));
  }
}

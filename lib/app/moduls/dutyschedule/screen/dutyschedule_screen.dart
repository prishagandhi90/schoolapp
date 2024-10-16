import 'package:emp_app/app/app_custom_widget/custom_stepper.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/moduls/dutyschedule/screen/dutyschedule_dropdown.dart';
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
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: DutyscheduleDropdown(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(199, 255, 255, 255),
                        border: Border.all(color: Colors.grey), // Border add kiya
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Text Here',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CustomStepper()
          ],
        ));
  }
}

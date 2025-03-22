import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabReportScreen extends StatelessWidget {
  LabReportScreen({Key? key}) : super(key: key);
  List<bool> expandedList = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdPatientController>(
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Lab Report',
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: CommonFontStyle.plusJakartaSans,
                ),
              ),
              centerTitle: true,
            ),
            body: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Card ${index + 1}'),
                            trailing: IconButton(
                              icon: Icon(
                                expandedList[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              ),
                              onPressed: () {
                                expandedList[index] = !expandedList[index];
                                controller.update();
                              },
                            ),
                          ),
                          if (expandedList[index]) // Jab expand hoga tab ye dikhega
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Yeh hai additional content for Card ${index + 1}. '
                                'Jab arrow dabayega tab hi dikhega!',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                        ],
                      ));
                }));
      },
    );
  }
}

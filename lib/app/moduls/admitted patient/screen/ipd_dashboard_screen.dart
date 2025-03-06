import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/adpatient_screen.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IpdDashboardScreen extends StatelessWidget {
  const IpdDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AdpatientController());
    return GetBuilder<AdpatientController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(
              'IPD',
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            backgroundColor: AppColor.white,
            centerTitle: true,
          ),
          body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildPatientCard("Admitted Patients", controller.patientsData.length);
            },
          ),
        );
      },
    );
  }

  Widget _buildPatientCard(String title, int count) {
    return GestureDetector(
      onTap: () {
        Get.to(AdpatientScreen());
        // Get.to(LabSummaryScreen());
      },
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.teal, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title, // Dynamic Title
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "$count", // Dynamic Count
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(
                Icons.person, // Icon ko bhi dynamic kar sakte ho agar chaho
                size: 40,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

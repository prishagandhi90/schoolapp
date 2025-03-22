import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/adpatient_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class IpdDashboardScreen extends StatefulWidget {
  const IpdDashboardScreen({Key? key}) : super(key: key);

  @override
  State<IpdDashboardScreen> createState() => _IpdDashboardScreenState();
}

class _IpdDashboardScreenState extends State<IpdDashboardScreen> {
  final adPatientController = Get.put(AdPatientController());

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await adPatientController.fetchDeptwisePatientList();
  }

  @override
  Widget build(BuildContext context) {
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
      body: GetBuilder<AdPatientController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: getDynamicHeight(size: 0.102),
              ),
              child: Center(child: CircularProgressIndicator()),
            ); // 🔹 Jab tak data load ho raha hai
          }
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildPatientCard("Admitted Patients", controller.patientsData.length, context, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(String title, int count, BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: AdpatientScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) async {
          final controller = Get.put(AdPatientController());
          controller.sortBySelected = -1;
          await controller.resetForm();
          await _fetchData();
          final bottomBarController = Get.find<BottomBarController>();
          bottomBarController.currentIndex.value = 0;
          bottomBarController.isAdmittedPatient.value = true;
          hideBottomBar.value = false;
          var dashboardController = Get.put(DashboardController());
          await dashboardController.getDashboardDataUsingToken();
        });
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

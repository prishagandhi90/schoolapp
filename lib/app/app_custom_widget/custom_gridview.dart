import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomGridview extends StatefulWidget {
  const CustomGridview({super.key});

  @override
  State<CustomGridview> createState() => _CustomGridviewState();
}

class _CustomGridviewState extends State<CustomGridview> {
  int selectedIndex = -1;
  List<Container> containers = [];

  static const List<Map<String, dynamic>> gridview = [
    {'image': 'assets/image/HIMS.png', 'label': 'HIMS'},
    {'image': 'assets/image/OPD.png', 'label': 'OPD'},
    {'image': 'assets/image/IPD.png', 'label': 'IPD'},
    {'image': 'assets/image/stores.png', 'label': 'STORE'},
    {'image': 'assets/image/radio.png', 'label': 'RADIOLOGY'},
    {'image': 'assets/image/patho.png', 'label': 'PATHOLOGY'},
    {'image': 'assets/image/pharma.png', 'label': 'PHARMACY'},
    {'image': 'assets/image/payroll.png', 'label': 'PAYROLL'},
    {'image': 'assets/image/OT.png', 'label': 'OT'},
    {'image': 'assets/image/NABH.png', 'label': 'NABH'},
  ];

  @override
  void initState() {
    super.initState();
    _loadContainers();
  }

  Future<void> _loadContainers() async {
    for (int i = 0; i < gridview.length; i++) {
      containers.add(card(i));
    }
    // setState(() {});
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    final DashboardController dashboardController = Get.put(DashboardController());
    if (index == 6 && dashboardController.isPharmacyUser.toUpperCase() != "Y") {
      Get.snackbar(
        AppString.noRights,
        '',
        colorText: AppColor.white,
        backgroundColor: AppColor.black,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    dashboardController.gridOnClk(index, context);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: gridview.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.30,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => onItemTapped(index),
          child: card(index),
        );
      },
    );
  }

  Container card(int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.primaryColor),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColor.grey,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                  blurRadius: 0.0,
                ),
              ]
            : [],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              gridview[index]['image'],
              color: AppColor.primaryColor,
              height: 35, //50
              width: 35, //50
            ),
            Text(
              gridview[index]['label'],
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            const SizedBox(
              height: 10, //5
            )
          ],
        ),
      ),
    );
  }
}

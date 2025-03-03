import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
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
    // dashboardController.update();
    bool hasModuleAccess = dashboardController.empModuleScreenRightsTable.isNotEmpty &&
        dashboardController.empModuleScreenRightsTable
            .any((element) => element.moduleSeq == (index + 1) && element.rightsYN == 'Y');
    if (hasModuleAccess == false) {
      Get.snackbar(
        AppString.noRights,
        '',
        colorText: AppColor.white,
        backgroundColor: AppColor.black,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    // if (index == 6 && dashboardController.isPharmacyUser.toUpperCase() != "Y") {
    //   Get.snackbar(
    //     AppString.noRights,
    //     '',
    //     colorText: AppColor.white,
    //     backgroundColor: AppColor.black,
    //     duration: const Duration(seconds: 2),
    //   );
    //   return;
    // }

    // if (index == 7) {

    //   Get.snackbar(
    //     AppString.noRights,
    //     '',
    //     colorText: AppColor.white,
    //     backgroundColor: AppColor.black,
    //     duration: const Duration(seconds: 2),
    //   );
    //   return;
    // }

    dashboardController.gridOnClk(index, context);
  }

  @override
  Widget build(BuildContext context) {
    Sizes.init(context); // Initialize screen sizes

    // Tablet aur mobile ke liye different aspect ratio
    double aspectRatio = (Sizes.w < 100) ? (Sizes.w / 3) / (Sizes.h * 0.18) : 1.2;

    return GridView.builder(
      padding: EdgeInsets.all(getDynamicHeight(size: 0.017)),
      itemCount: gridview.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Har screen pe 3 hi columns rahenge
        crossAxisSpacing: getDynamicHeight(size: 0.012), // Dynamic spacing
        mainAxisSpacing: getDynamicHeight(size: 0.012), // Dynamic spacing
        childAspectRatio: aspectRatio, // Tablet aur Mobile ke liye adjust
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
        border: Border.all(color: AppColor.primaryColor, width: getDynamicHeight(size: 0.002)),
        borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColor.grey,
                  spreadRadius: getDynamicHeight(size: 0.004),
                  offset: Offset(0, getDynamicHeight(size: 0.006)),
                  blurRadius: getDynamicHeight(size: 0.01),
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
              height: Sizes.w * 0.09, // Image size dynamic
              width: Sizes.w * 0.09, // Image size dynamic
            ),
            Text(
              gridview[index]['label'],
              style: TextStyle(
                fontSize: Sizes.w * 0.035, // Dynamic font size
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/dashboard/controller/dashboard_controller.dart';
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

  static List<Map<String, dynamic>> gridview = [
    {'image': AppImage.HIMS, 'label': 'HIMS'},
    {'image': AppImage.opd, 'label': 'OPD'},
    {'image': AppImage.ipd, 'label': 'IPD'},
    {'image': AppImage.store, 'label': 'STORE'},
    {'image': AppImage.radio, 'label': 'RADIOLOGY'},
    {'image': AppImage.patho, 'label': 'PATHOLOGY'},
    {'image': AppImage.pharma, 'label': 'PHARMACY'},
    {'image': AppImage.payroll, 'label': 'PAYROLL'},
    {'image': AppImage.OT, 'label': 'OT'},
    {'image': AppImage.maintnance, 'label': 'Maintance'},
    {'image': AppImage.nabh, 'label': 'NABH'},
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
        dashboardController.empModuleScreenRightsTable.any((element) => element.moduleSeq == (index + 1) && element.rightsYN == 'Y');
    if (hasModuleAccess == false) {
      // if (hasModuleAccess == false) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageSize = constraints.maxWidth * 0.35; // You can adjust this

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  gridview[index]['image'],
                  color: AppColor.primaryColor,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: getDynamicHeight(size: 0.008)),
                Text(
                  gridview[index]['label'],
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.13, // Text also responsive
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: CommonFontStyle.plusJakartaSans,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

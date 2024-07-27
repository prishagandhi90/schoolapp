import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomGridview extends StatefulWidget {
  const CustomGridview({super.key});

  @override
  State<CustomGridview> createState() => _CustomGridviewState();
}

class _CustomGridviewState extends State<CustomGridview> {
  final DashboardController dashboardController = Get.put(DashboardController());
  int selectedIndex = 1;

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

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    dashboardController.gridOnClk(index, context);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: AppConst.gridview.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 18, //13
        mainAxisSpacing: 18, //13
        childAspectRatio: 1.30, //0.85
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => onItemTapped(index),
          child: FutureBuilder<Container>(
            future: card(index, context),
            builder: (BuildContext context, AsyncSnapshot<Container> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Icon(Icons.error));
              } else {
                return snapshot.data ?? const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  Future<Container> card(int index, BuildContext context) async {
    // Simulate some delay
    await Future.delayed(const Duration(seconds: 1));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: selectedIndex == index
            ? [
                const BoxShadow(
                  color: Color.fromARGB(255, 163, 163, 163),
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

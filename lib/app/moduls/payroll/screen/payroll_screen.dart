import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/payroll/controller/payroll_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final PayrollController payrollcontroller = Get.put(PayrollController());
  final DashboardController dashboardController = Get.put(DashboardController());

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayrollController>(
      init: PayrollController(),
      builder: (controller) {
        return Scaffold(
          onDrawerChanged: (isop) {
            var bottomBarController = Get.put(BottomBarController());
            hideBottomBar.value = isop;
            bottomBarController.update();
          },
          drawer: Drawer(
              backgroundColor: Colors.white,
              child: ListView(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      cursorColor: const Color.fromARGB(255, 168, 168, 168),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 192, 191, 191), width: 1.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 192, 191, 191),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 192, 191, 191)),
                        suffixIcon: const Icon(
                          Icons.cancel_outlined,
                          color: Color.fromARGB(255, 192, 191, 191),
                        ),
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 192, 191, 191),
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        ),
                        filled: true,
                        focusColor: Colors.grey,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    shrinkWrap: true,
                    itemCount: AppConst.payrollgrid.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.payrolListOnClk(index, context);
                        },
                        child: SizedBox(
                          height: 40,
                          child: ListTile(
                            leading: Image.asset(
                              AppConst.payrollgrid[index]['image'],
                              height: 25,
                              width: 25,
                              color: const Color.fromARGB(255, 94, 157, 168),
                            ),
                            title: Text(
                              AppConst.payrollgrid[index]['label'],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: CommonFontStyle.plusJakartaSans,
                              ),
                            ),
                            trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
                          ),
                        ),
                      );
                    },
                  )
                ],
              )),
          appBar: AppBar(
            title: Text(
              'PAYROLL',
              style: TextStyle(
                color: const Color.fromARGB(255, 94, 157, 168),
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    'assets/image/drawer.png',
                    width: 20,
                    color: AppColor.black,
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/image/notification.png',
                    width: 20,
                  ))
            ],
            centerTitle: true,
          ),
          body: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(child: ProgressWithIcon()),
                      )
                    : Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    const Color.fromARGB(192, 198, 238, 243).withOpacity(0.3),
                                    const Color.fromARGB(162, 94, 157, 168).withOpacity(0.4),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Today's Overview",
                                      style: TextStyle(
                                        fontSize: 16, //18
                                        color: const Color.fromARGB(255, 80, 74, 74),
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      controller.formattedDate,
                                      style: TextStyle(
                                        fontSize: 17, //20
                                        fontWeight: FontWeight.w600,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 2.0, // soften the shadow
                                              spreadRadius: 1.0, //extend the shadow
                                              offset: Offset(3.0, 3.0))
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text('Clock In',
                                                  style: TextStyle(
                                                    fontSize: 16, //18
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  )),
                                              if (controller.payrolltable.isNotEmpty)
                                                Text(
                                                  controller.payrolltable[0].inPunchTime.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16, //25
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                )
                                              else
                                                Text('--:-- ',
                                                    style: TextStyle(
                                                      fontSize: 16, //25
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                    )),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(221, 236, 242, 242),
                                                    border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child:
                                                    controller.payrolltable.isNotEmpty && controller.payrolltable[0].inPunchTime.toString().isNotEmpty
                                                        ? Text(
                                                            'Done at ${controller.payrolltable[0].inPunchTime}',
                                                            style: TextStyle(
                                                              fontSize: 10, //12
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          )
                                                        : const Text('Not Yet'),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text('Clock Out',
                                                  style: TextStyle(
                                                    fontSize: 16, //18
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  )),
                                              if (controller.payrolltable.isNotEmpty)
                                                Text(controller.payrolltable[0].outPunchTime.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16, //25
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                    ))
                                              else
                                                Text('--:-- ',
                                                    style: TextStyle(
                                                      fontSize: 16, //16
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                    )),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(221, 236, 242, 242),
                                                    border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: controller.payrolltable.isNotEmpty &&
                                                        controller.payrolltable[0].outPunchTime.toString().isNotEmpty
                                                    ? Text(
                                                        'Done at ${controller.payrolltable[0].outPunchTime}',
                                                        style: TextStyle(
                                                          fontSize: 10, //12
                                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                                        ),
                                                      )
                                                    : const Text('Not Yet'),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2.0, // soften the shadow
                                                spreadRadius: 1.0, //extend the shadow
                                                offset: Offset(3.0, 3.0))
                                          ],
                                          border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'LC/EG MIN',
                                                style: TextStyle(
                                                  fontSize: 14, //18
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                ),
                                              ),
                                              if (controller.payrolltable.isNotEmpty)
                                                Text(controller.payrolltable[0].totLCEGMin.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16, //22
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                    ))
                                              else
                                                Text('-- ',
                                                    style: TextStyle(
                                                      fontSize: 16, //25
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                    )),
                                              // Text(''), //controller.payrolltable[0].totLCEGMin.toString())
                                            ],
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 2.0, // soften the shadow
                                              spreadRadius: 1.0, //extend the shadow
                                              offset: Offset(3.0, 3.0))
                                        ],
                                        border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('LC/EG CNT',
                                                style: TextStyle(
                                                  fontSize: 14, //18
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                )),
                                            if (controller.payrolltable.isNotEmpty)
                                              Text(controller.payrolltable[0].cnt.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16, //22
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ))
                                            else
                                              Text('--',
                                                  style: TextStyle(
                                                    fontSize: 16, //25
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: AttendanceScreen(),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                        ).then((value) {
                                          hideBottomBar.value = false;
                                          // controller.getDashboardData();
                                        });
                                      }, //Get.to(const AttendanceScreen()),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.06, //0.07
                                        width: MediaQuery.of(context).size.width * 0.14, //0.17
                                        margin: const EdgeInsets.only(
                                          top: 15,
                                          left: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(255, 94, 157, 168),
                                            ),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Image.asset(
                                          'assets/image/attendence.png',
                                          // height: 35.0, //50
                                          // width: 35.0, //50
                                          color: const Color.fromARGB(255, 94, 157, 168),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Attendence',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                              Expanded(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: const MispunchScreen(),
                                          withNavBar: true,
                                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                        ).then((value) {
                                          hideBottomBar.value = false;
                                          // controller.getDashboardData();
                                        });
                                      }, //Get.to(MispunchScreen()),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.06, //0.07
                                        width: MediaQuery.of(context).size.width * 0.14, //0.17
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(255, 94, 157, 168),
                                            ),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Image.asset(
                                          'assets/image/mispunch.png',
                                          // height: 35, //50
                                          // width: 35, //50
                                          color: const Color.fromARGB(255, 94, 157, 168),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Mispunch Info',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                              Expanded(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.snackbar('Coming Soon', '', colorText: Colors.white, backgroundColor: Colors.black),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.06, //0.07
                                        width: MediaQuery.of(context).size.width * 0.14, //0.17
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(255, 94, 157, 168),
                                            ),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Image.asset(
                                          'assets/image/leave.png',
                                          // height: 35, //50
                                          // width: 35, //50
                                          color: const Color.fromARGB(255, 94, 157, 168),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Leave Entry',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                              Expanded(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.snackbar('Coming Soon', '', colorText: Colors.white, backgroundColor: Colors.black),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.06, //0.07
                                        width: MediaQuery.of(context).size.width * 0.14, //0.17
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(255, 94, 157, 168),
                                            ),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Image.asset(
                                          'assets/image/overtime.png',
                                          // height: 35, //50
                                          // width: 35, //50
                                          color: const Color.fromARGB(255, 94, 157, 168),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Over Time',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              )),
          // bottomNavigationBar: BottomBarView(),
        );
      },
    );
  }
}

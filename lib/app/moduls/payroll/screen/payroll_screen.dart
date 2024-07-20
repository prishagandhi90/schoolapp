import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/core/util/app_const.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/payroll/controller/payroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                        hintStyle: const TextStyle(color: Color.fromARGB(255, 192, 191, 191)),
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
                      return SizedBox(
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
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
                        ),
                      );
                    },
                  )
                ],
              )),
          appBar: AppBar(
            title: const Text('PAYROLL', style: TextStyle(color: Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w700)),
            actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))],
            // leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios)),
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
                                boxShadow: const [],
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                    const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Today's Overview",
                                      style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 80, 74, 74)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      controller.formattedDate,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                                              blurRadius: 5.0, // soften the shadow
                                              spreadRadius: 3.0, //extend the shadow
                                              offset: Offset(4.0, 4.0))
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
                                              const Text('Clock In', style: TextStyle(fontSize: 18)),
                                              if (controller.payrolltable.isNotEmpty)
                                                Text(controller.payrolltable[0].inPunchTime.toString(),
                                                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600))
                                              else
                                                const Text('--:-- ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
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
                                                            style: const TextStyle(fontSize: 12),
                                                          )
                                                        : const Text('Not Yet'),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Text('Clock Out', style: TextStyle(fontSize: 18)),
                                              if (controller.payrolltable.isNotEmpty)
                                                Text(controller.payrolltable[0].outPunchTime.toString(),
                                                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600))
                                              else
                                                const Text('--:-- ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
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
                                                        style: const TextStyle(fontSize: 12),
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
                                              blurRadius: 5.0, // soften the shadow
                                              spreadRadius: 3.0, //extend the shadow
                                              offset: Offset(4.0, 4.0),
                                            )
                                          ],
                                          border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'LC/EG MIN',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                              ),
                                              if (controller.payrolltable.isNotEmpty)
                                                Text(controller.payrolltable[0].totLCEGMin.toString(),
                                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
                                              else
                                                const Text('-- ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
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
                                            blurRadius: 5.0, // soften the shadow
                                            spreadRadius: 3.0, //extend the shadow
                                            offset: Offset(
                                                4.0, // Move to right 5  horizontally
                                                4.0),
                                          )
                                        ],
                                        border: Border.all(color: const Color.fromARGB(255, 94, 157, 168)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('LC/EG CNT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                            if (controller.payrolltable.isNotEmpty)
                                              Text(controller.payrolltable[0].cnt.toString(),
                                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
                                            else
                                              const Text('--', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          // ListView.builder(
                          //   itemCount: AppConst.payrolllist.length,
                          //   shrinkWrap: true,
                          //   itemBuilder: (context, index) {
                          //     return Row(
                          //       children: [
                          //         Column(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             GestureDetector(
                          //               onTap: () => Get.to(const AttendanceScreen()),
                          //               child: Container(
                          //                 height: MediaQuery.of(context).size.height * 0.07,
                          //                 width: MediaQuery.of(context).size.width * 0.17,
                          //                 margin: const EdgeInsets.only(top: 15, left: 10),
                          //                 decoration: BoxDecoration(
                          //                     border: Border.all(
                          //                       color: const Color.fromARGB(255, 94, 157, 168),
                          //                     ),
                          //                     borderRadius: BorderRadius.circular(10)),
                          //                 child: Image.asset(
                          //                   AppConst.payrolllist[index]['image'],
                          //                   height: 50,
                          //                   width: 50,
                          //                   color: const Color.fromARGB(255, 94, 157, 168),
                          //                 ),
                          //               ),
                          //             ),
                          //             Text(AppConst.payrolllist[index]['label']),
                          //           ],
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // )
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(const AttendanceScreen()),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: MediaQuery.of(context).size.width * 0.17,
                                      margin: const EdgeInsets.only(top: 15, left: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 94, 157, 168),
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Image.asset(
                                        'assets/image/attendence.png',
                                        height: 50,
                                        width: 50,
                                        color: const Color.fromARGB(255, 94, 157, 168),
                                      ),
                                    ),
                                  ),
                                  const Text('Attendence'),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(MispunchScreen()),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: MediaQuery.of(context).size.width * 0.17,
                                      margin: const EdgeInsets.only(top: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 94, 157, 168),
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Image.asset(
                                        'assets/image/mispunch.png',
                                        height: 50,
                                        width: 50,
                                        color: const Color.fromARGB(255, 94, 157, 168),
                                      ),
                                    ),
                                  ),
                                  const Text('Mispunch Info'),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(MispunchScreen()),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: MediaQuery.of(context).size.width * 0.17,
                                      margin: const EdgeInsets.only(top: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 94, 157, 168),
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Image.asset(
                                        'assets/image/leave.png',
                                        height: 50,
                                        width: 50,
                                        color: const Color.fromARGB(255, 94, 157, 168),
                                      ),
                                    ),
                                  ),
                                  const Text('Leave Entry'),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(MispunchScreen()),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.07,
                                      width: MediaQuery.of(context).size.width * 0.17,
                                      margin: const EdgeInsets.only(top: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 94, 157, 168),
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Image.asset(
                                        'assets/image/overtime.png',
                                        height: 50,
                                        width: 50,
                                        color: const Color.fromARGB(255, 94, 157, 168),
                                      ),
                                    ),
                                  ),
                                  const Text('Over Time'),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
              )),
          // bottomNavigationBar: CustomBottomBar(),
        );
      },
    );
  }
}

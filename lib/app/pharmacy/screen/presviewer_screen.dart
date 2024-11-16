import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/pharmacy/controller/pharmacy_controller.dart';
import 'package:emp_app/app/pharmacy/screen/presdetails_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresviewerScreen extends StatelessWidget {
  PresviewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());
    return GetBuilder<PharmacyController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: Text(
                AppString.prescriptionviewer,
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: CommonFontStyle.plusJakartaSans,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.persistentController.value.index = 0; // Set index to Payroll tab
                    bottomBarController.currentIndex.value = 0;
                    hideBottomBar.value = false;
                    Get.back();
                  });
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      AppImage.notification,
                      width: 20,
                    ))
              ],
              centerTitle: true,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Search Bar (60%)
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        cursorColor: AppColor.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: AppColor.black,
                            ),
                          ),
                          prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                          hintText: AppString.searchpatient,
                          hintStyle: TextStyle(
                            color: AppColor.lightgrey1,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                          filled: true,
                          fillColor: AppColor.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 8), // Space between items
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        // height: 50, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.sort, color: AppColor.black),
                          onPressed: () {
                            // Add functionality here
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Space between items
                    Expanded(
                      flex: 1.5.toInt(),
                      child: Container(
                        // height: 50, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.filter_alt, color: AppColor.black),
                          onPressed: () {
                            // Add functionality here
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: controller.presviewerList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColor.lightblue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.presviewerList[index].patientName.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () => Get.to(PresdetailsScreen()),
                                      child: Container(
                                        height: 35, // Small container size
                                        margin: const EdgeInsets.only(bottom: 5), // Moves container a bit left and down
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.shopping_cart, size: 18),
                                          onPressed: () {
                                            Get.to(PresdetailsScreen());
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Print St: ${controller.presviewerList[index].printStatus.toString()}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Priority: ${controller.presviewerList[index].priority.toString()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Last User: ${controller.presviewerList[index].lastUser.toString()}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 'Print St: ${data[index]['priority']}' ko as it is rakha gaya hai
                                    Text(
                                      'IPD No: ${controller.presviewerList[index].ipd.toString()}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),

                                    // Second text ko thoda center align karna hai, isliye use Expanded kiya hai
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'RX Status: ${controller.presviewerList[index].rxStatus.toString()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text('IPD No: ${data[index]['ipdNo']}'),
                              //       Text('RX Status: ${data[index]['rxStatus']}'),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ]));
      },
    );
  }
}

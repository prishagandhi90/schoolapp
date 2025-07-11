// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_const.dart';
import 'package:schoolapp/app/core/util/app_font_name.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/mispunch/controller/mispunch_controller.dart';
import 'package:schoolapp/app/modules/superlogin/screen/superlogin_screen.dart';
import 'package:schoolapp/app/modules/verifyotp/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final DashboardController dashboardController = Get.put(DashboardController());
  final MispunchController mispunchController = Get.put(MispunchController());
  final OtpController otpController = Get.put(OtpController());
  String userName = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).viewPadding.top;
    return Drawer(
      elevation: 0,
      width: Get.width * 0.75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
      ),
      backgroundColor: AppColor.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: topPadding + 15),
                Padding(
                  padding: EdgeInsets.only(
                    left: getDynamicHeight(size: 0.017), //15,
                    top: getDynamicHeight(size: 0.012), // 10,
                    bottom: getDynamicHeight(size: 0.007), //5,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AppColor.darkgery), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: getDynamicHeight(size: 0.017), //15,
                              right: getDynamicHeight(size: 0.017), //15,
                              top: getDynamicHeight(size: 0.032), //30,
                              bottom: getDynamicHeight(size: 0.032), //30,
                            ),
                            child: Image.asset(
                              AppImage.venuspro,
                              scale: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getDynamicHeight(size: 0.017), //15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (dashboardController.employeeName.isNotEmpty)
                              Text(dashboardController.employeeName.toString(),
                                  style: TextStyle(
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                    fontWeight: FontWeight.w600,
                                  ))
                            else
                              Text('-- ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  )),
                            SizedBox(
                              height: Sizes.crossLength * 0.002,
                            ),
                            if (dashboardController.designation.isNotEmpty)
                              Text(dashboardController.designation.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  ))
                            else
                              Text('-- ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  )),
                            SizedBox(
                              height: Sizes.crossLength * 0.002,
                            ),
                            if (dashboardController.mobileNumber.isNotEmpty)
                              Text(dashboardController.mobileNumber.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  ))
                            else
                              Text('-- ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  )),
                            SizedBox(
                              height: Sizes.crossLength * 0.002,
                            ),
                            if (dashboardController.emailAddress.isNotEmpty)
                              Text(
                                dashboardController.emailAddress.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            else
                              Text('-- ', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans)),
                            SizedBox(
                              height: Sizes.crossLength * 0.010,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                  height: getDynamicHeight(size: 0.072), //70,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 94, 157, 168),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          const Color.fromARGB(192, 198, 238, 243).withOpacity(0.3),
                          const Color.fromARGB(162, 94, 157, 168).withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [BoxShadow(color: Colors.white70, blurRadius: 0.0, offset: Offset(0, 4), spreadRadius: 2)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (dashboardController.department.isNotEmpty)
                        Text(dashboardController.department.toString().capitalizeFirst ?? '',
                            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans))
                      else
                        Text('-- ', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans)),
                      if (dashboardController.empCode.isNotEmpty)
                        Text(dashboardController.empCode.toString(),
                            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans))
                      else
                        Text('-- ', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans)),
                      if (dashboardController.empType.isNotEmpty)
                        Text(dashboardController.empType.toString().capitalizeFirst ?? '',
                            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans))
                      else
                        Text('-- ', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: CommonFontStyle.plusJakartaSans)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppConst.listItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        dashboardController.gridOnClk(index, context);
                      },
                      child: SizedBox(
                        height: getDynamicHeight(size: 0.042), //40,
                        child: ListTile(
                          leading: Image.asset(
                            AppConst.listItems[index]['image'],
                            color: AppColor.primaryColor,
                            height: getDynamicHeight(size: 0.027), //25,
                            width: getDynamicHeight(size: 0.027), //25,
                          ),
                          title: Text(
                            AppConst.listItems[index]['label'],
                            style: TextStyle(
                              // fontSize: 16.0,
                              fontSize: getDynamicHeight(size: 0.018),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Sizes.crossLength * 0.010,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Buttons ko opposite side align kare
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logout Button
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: getDynamicHeight(size: 0.122), //120,
                          height: getDynamicHeight(size: 0.042), //40,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(204, 244, 67, 54),
                              ),
                            ),
                            onPressed: () {
                              otpController.showLogoutDialog(context);
                            },
                            child: Text(
                              AppString.logout,
                              style: TextStyle(color: AppColor.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: dashboardController.isSuperAdmin == "Y",
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: getDynamicHeight(size: 0.102), //120,
                          height: getDynamicHeight(size: 0.042), //40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColor.white,
                                ),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  side: BorderSide(color: AppColor.black),
                                  borderRadius: BorderRadius.circular(30),
                                ))),
                            onPressed: () {
                              Get.to(SuperloginScreen(
                                mobileNo: dashboardController.mobileNumber,
                              ));
                            },
                            child: Text(
                              AppString.adminlogin,
                              style: TextStyle(
                                color: AppColor.black,
                                overflow: TextOverflow.clip,
                                fontFamily: CommonFontStyle.plusJakartaSans,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  AppImage.sidemenulogo,
                  scale: 2.5,
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

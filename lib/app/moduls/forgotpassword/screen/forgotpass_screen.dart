// ignore_for_file: deprecated_member_use

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/forgotpassword/controller/forgotpass_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotpassScreen extends GetView<ForgotpassController> {
  final String mobileNumber; // Mobile number jo constructor se pass hota hai

  const ForgotpassScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotpassController());
    return GetBuilder<ForgotpassController>(builder: (controller) {
      return PopScope(
        canPop: false, // User ko back button press karke is screen se bahar jaane se rokne ke liye canPop:false
        // Jab user back button press kare toh LoginScreen pe redirect karein with animation
        onPopInvoked: (v) {
          Get.offAll(const LoginScreen(), duration: const Duration(milliseconds: 700));
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.backgroundcolor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
                // Form widget for validation
                child: Form(
                  key: controller.passFormKey, // Form key from controller for validation
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Image.asset(
                              AppImage.venuslogo,
                              // scale: 2,
                              // width: Sizes.crossLength * 0.260,
                              width: MediaQuery.of(context).size.width * 0.8,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppString.generateotp,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                // fontSize: 22,
                                fontSize: getDynamicHeight(size: 0.024),
                                fontFamily: CommonFontStyle.plusJakartaSans,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getDynamicHeight(size: 0.042),
                          ),
                          TextFormField(
                            controller: controller.numberController..text = mobileNumber,
                            keyboardType: TextInputType.number,
                            // Validation logic for mobile number
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppString.plzentermobileno;
                              }
                              // Regex to check exactly 10 digits
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return AppString.entervalidmobileno;
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontFamily: CommonFontStyle.plusJakartaSans,
                              fontSize: getDynamicHeight(size: 0.016),
                            ),
                            // Input restrictions: digits only and max length 10
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              hintText: AppString.entermobileno,
                              hintStyle: TextStyle(
                                fontFamily: CommonFontStyle.plusJakartaSans,
                                fontSize: getDynamicHeight(size: 0.014),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  width: getDynamicHeight(size: 0.002),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  width: getDynamicHeight(size: 0.002),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.primaryColor,
                                  width: getDynamicHeight(size: 0.002),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: getDynamicHeight(size: 0.01), // Fixed dynamic height
                                horizontal: getDynamicHeight(size: 0.01), // Maintain spacing
                              ),
                            ),
                          ),
                          SizedBox(height: getDynamicHeight(size: 0.057)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.13,
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // controller.isLoadingLogin ? null : controller.requestOTP(context);
                                    FocusScope.of(context).unfocus();
                                    // FocusManager.instance.primaryFocus?.unfocus();
                                    if (controller.passFormKey.currentState!.validate()) {
                                      controller.requestOTP(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.lightgreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: controller.isLoadingLogin
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          AppString.continue1,
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: getDynamicHeight(size: 0.022),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: CommonFontStyle.plusJakartaSans,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.13,
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate back to LoginScreen with animation
                                    Get.offAll(const LoginScreen(), duration: const Duration(milliseconds: 700));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppColor.primaryColor)),
                                  ),
                                  child: Text(
                                    AppString.cancel,
                                    style: TextStyle(
                                      color: AppColor.black,
                                      // fontSize: 20,
                                      fontSize: getDynamicHeight(size: 0.022),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //   },
            // ),
          ),
        ),
      );
    });
  }
}

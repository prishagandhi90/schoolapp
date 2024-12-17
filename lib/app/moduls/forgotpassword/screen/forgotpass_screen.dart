import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/forgotpassword/controller/forgotpass_controller.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotpassScreen extends GetView<ForgotpassController> {
  final String mobileNumber;

  const ForgotpassScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotpassController());
    return GetBuilder<ForgotpassController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.backgroundcolor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
                    child: IntrinsicHeight(
                      child: Form(
                        key: controller.passFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Generate OTP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  controller: controller.numberController..text = mobileNumber,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppString.plzentermobileno;
                                    }
                                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                      return AppString.entervalidmobileno;
                                    }
                                    return null;
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: AppString.entermobileno,
                                    hintStyle: TextStyle(
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.primaryColor),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 55),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.13,
                                  width: MediaQuery.of(context).size.width * 0.40,
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
                                            'Continue',
                                            style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.13,
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Purane controllers ko delete karo
                                      if (Get.isRegistered<ForgotpassController>()) {
                                        Get.delete<ForgotpassController>();
                                      }
                                      if (Get.isRegistered<LoginController>()) {
                                        Get.delete<LoginController>();
                                      }

                                      Get.put(LoginController());
                                      Get.put(ForgotpassController());
                                      // Nayi LoginScreen load karo
                                      Get.offAll(() => const LoginScreen(),
                                          duration: const Duration(milliseconds: 700));
                                      // Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(color: AppColor.primaryColor)),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: AppColor.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            MediaQuery.of(context).viewInsets.bottom > 0
                                ? const Spacer()
                                : Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      'assets/Venus_Hospital_New_Logo-removebg-preview.png',
                                      width: MediaQuery.of(context).size.width * 0.8,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

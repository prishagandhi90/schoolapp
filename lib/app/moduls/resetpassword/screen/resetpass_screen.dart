import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/moduls/forgotpassword/screen/forgotpass_screen.dart';
import 'package:emp_app/app/moduls/resetpassword/controller/resetpass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ResetpassScreen extends GetView<ResetpassController> {
  const ResetpassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ResetpassController());
    return GetBuilder<ResetpassController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.backgroundcolor,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
              child: Form(
                key: controller.resetpassKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/Venus_Hospital_New_Logo-removebg-preview.png',
                            // scale: 2,
                            // width: Sizes.crossLength * 0.260,
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: controller.passwordController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
                            if (value!.trim().isEmpty) {
                              return "Please enter password.";
                            } else if (!passwordRegex.hasMatch(value)) {
                              return 'Password must be a minimum of 8 characters in length and include at least one letter and one number.';
                            } else {
                              return null;
                            }
                          },
                          obscureText: controller.hidePassword,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.deny(
                              RegExp(r'\s'),
                            )
                          ],
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
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
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.hidePassword = !controller.hidePassword;
                                controller.update();
                              },
                              child: Icon(controller.hidePassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.confirmpassController,
                          keyboardType: TextInputType.emailAddress,
                          // textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter confirm password";
                            } else if (value.toString() != controller.passwordController.text.trim()) {
                              return "Password didn't match.";
                            } else {
                              return null;
                            }
                          },
                          obscureText: controller.hideConfirmPassword,
                          inputFormatters: <TextInputFormatter>[
                            // FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: AppString.enterConfirmPassword,
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
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.hideConfirmPassword = !controller.hideConfirmPassword;
                                controller.update();
                              },
                              child: Icon(controller.hideConfirmPassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),
                        const SizedBox(height: 55),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.13,
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (controller.resetpassKey.currentState!.validate()) {
                                await controller.resetPassWordApi();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightgreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              AppString.resetPassword,
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
                              Get.offAll(
                                  ForgotpassScreen(
                                    mobileNumber: controller.mobileNo,
                                  ),
                                  duration: const Duration(milliseconds: 700));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: AppColor.primaryColor)),
                            ),
                            child: Text(
                              AppString.cancel,
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
                    // MediaQuery.of(context).viewInsets.bottom > 0
                    //     ? const Spacer()
                    //     : Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Image.asset(
                    //           'assets/Venus_Hospital_New_Logo-removebg-preview.png',
                    //           width: MediaQuery.of(context).size.width * 0.8,
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

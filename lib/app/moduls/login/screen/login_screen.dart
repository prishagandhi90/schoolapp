import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/forgotpassword/screen/forgotpass_screen.dart';
import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    Get.put(LoginController());
    return GetBuilder<LoginController>(builder: (loginController) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.backgroundcolor,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizes.px40, // Adjusted using Sizes
                horizontal: Sizes.px15,
              ),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Image.asset(
                            AppImage.venuslogo,
                            width: Sizes.w * 0.8, // Dynamic width
                          ),
                        ),
                        SizedBox(height: Sizes.h * 0.04), // Dynamic height
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            AppString.hithere,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Sizes.px22, // Dynamic font size
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            ),
                          ),
                        ),
                        SizedBox(height: Sizes.h * 0.01), // Dynamic height
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            AppString.pleaselogin,
                            style: TextStyle(
                              fontSize: Sizes.px20, // Dynamic font size
                              fontFamily: CommonFontStyle.plusJakartaSans,
                            ),
                          ),
                        ),
                        SizedBox(height: Sizes.px40), // Dynamic height
                        TextFormField(
                          controller: loginController.numberController,
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
                          style: TextStyle(
                            fontFamily: CommonFontStyle.plusJakartaSans,
                            fontSize: getDynamicHeight(size: 0.016),
                          ),
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
                              vertical: getDynamicHeight(size: 0.015), // Fixed dynamic height
                              horizontal: getDynamicHeight(size: 0.015), // Maintain spacing
                            ),
                          ),
                        ),
                        loginController.withPaasword
                            ? SizedBox(height: Sizes.px25) // Dynamic height
                            : SizedBox(),
                        loginController.withPaasword
                            ? TextFormField(
                                controller: loginController.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppString.enterPassword;
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return AppString.entervalidmobileno;
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                  fontSize: getDynamicHeight(size: 0.016),
                                ),
                                obscureText: loginController.hidePassword,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(23),
                                ],
                                decoration: InputDecoration(
                                  hintText: AppString.enterPassword,
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
                                    vertical: getDynamicHeight(size: 0.015), // Fixed dynamic height
                                    horizontal: getDynamicHeight(size: 0.015), // Maintain spacing
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.hidePassword = !controller.hidePassword;
                                      controller.update();
                                    },
                                    child: Icon(controller.hidePassword ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: Sizes.px15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.withPaasword = !controller.withPaasword;
                                controller.update();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom: Sizes.px7, // Dynamic padding
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1.0, // Fixed underline thickness
                                    ),
                                  ),
                                ),
                                child: Text(
                                  controller.withPaasword ? 'With OTP' : 'With Password',
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontSize: Sizes.px14, // Dynamic font size
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.px40),
                        SizedBox(
                          height: Sizes.w * 0.13,
                          width: Sizes.w * 0.40,
                          child: ElevatedButton(
                            onPressed: () async {
                              loginController.isLoadingLogin ? null : await loginController.requestLogin(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightgreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: loginController.isLoadingLogin
                                ? const CircularProgressIndicator()
                                : Text(
                                    AppString.login,
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: Sizes.px20, // Dynamic font size
                                      fontWeight: FontWeight.w700,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: Sizes.px20),
                        controller.withPaasword
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ForgotpassScreen(
                                          mobileNumber: loginController.numberController.text,
                                        ),
                                        duration: const Duration(milliseconds: 700),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        bottom: Sizes.px7, // Dynamic padding
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppColor.primaryColor,
                                            width: 1.0, // Fixed underline thickness
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppString.forgotPassword,
                                        style: TextStyle(
                                          color: AppColor.primaryColor,
                                          fontSize: Sizes.px14, // Dynamic font size
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
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

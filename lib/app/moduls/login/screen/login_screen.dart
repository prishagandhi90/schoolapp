import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
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
    // Initialize Sizes
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
                            'assets/Venus_Hospital_New_Logo-removebg-preview.png',
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
                        loginController.withPaasword
                            ? SizedBox(height: Sizes.px25) // Dynamic height
                            : SizedBox(),
                        loginController.withPaasword
                            ? TextFormField(
                                controller: loginController.passwordController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter password';
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return AppString.entervalidmobileno;
                                  }
                                  return null;
                                },
                                obscureText: loginController.hidePassword,
                                inputFormatters: <TextInputFormatter>[
                                  // FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(23),
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
                                        'Forgot Password?',
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


// class LoginScreen extends GetView<LoginController> {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(LoginController());

//     return GetBuilder<LoginController>(builder: (loginController) {
//       return Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: AppColor.backgroundcolor,
//         body: SafeArea(
//             maintainBottomViewPadding: true,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
//                 // padding: EdgeInsets.only(
//                 //   left: Sizes.crossLength * 0.020,
//                 //   right: Sizes.crossLength * 0.20,
//                 // ),
//                 child: Form(
//                   key: controller.loginFormKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           // SizedBox(
//                           //   height: Sizes.crossLength * 0.10,
//                           // ),
//                           Center(
//                             child: Image.asset(
//                               'assets/Venus_Hospital_New_Logo-removebg-preview.png',
//                               // scale: 2,
//                               // width: Sizes.crossLength * 0.260,
//                               width: MediaQuery.of(context).size.width * 0.8,
//                             ),
//                           ),
//                           // SizedBox(
//                           //   height: Sizes.crossLength * 0.050,
//                           // ),
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//                           Align(
//                             alignment: AlignmentDirectional.center,
//                             child: Text(
//                               AppString.hithere,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 22,
//                                 fontFamily: CommonFontStyle.plusJakartaSans,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                           Align(
//                             alignment: AlignmentDirectional.center,
//                             child: Text(
//                               AppString.pleaselogin,
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontFamily: CommonFontStyle.plusJakartaSans,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 60),
//                           const SizedBox(height: 20),
//                           TextFormField(
//                             controller: loginController.numberController,
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppString.plzentermobileno;
//                               }
//                               if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                                 return AppString.entervalidmobileno;
//                               }
//                               return null;
//                             },
//                             inputFormatters: <TextInputFormatter>[
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(10),
//                             ],
//                             decoration: InputDecoration(
//                               hintText: AppString.entermobileno,
//                               hintStyle: TextStyle(
//                                 fontFamily: CommonFontStyle.plusJakartaSans,
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColor.primaryColor),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColor.primaryColor),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: AppColor.primaryColor),
//                               ),
//                             ),
//                           ),
//                           // const SizedBox(height: 20),
//                           loginController.withPaasword
//                               ? SizedBox(
//                                   height: Sizes.crossLength * 0.025,
//                                 )
//                               : SizedBox(),
//                           loginController.withPaasword
//                               ? TextFormField(
//                                   controller: loginController.passwordController,
//                                   keyboardType: TextInputType.emailAddress,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'enter password';
//                                     }
//                                     if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                                       return AppString.entervalidmobileno;
//                                     }
//                                     return null;
//                                   },
//                                   obscureText: loginController.hidePassword,
//                                   inputFormatters: <TextInputFormatter>[
//                                     // FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(10),
//                                   ],
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter Password',
//                                     hintStyle: TextStyle(
//                                       fontFamily: CommonFontStyle.plusJakartaSans,
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: AppColor.primaryColor),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: AppColor.primaryColor),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(color: AppColor.primaryColor),
//                                     ),
//                                     suffixIcon: GestureDetector(
//                                       onTap: () {
//                                         controller.hidePassword = !controller.hidePassword;
//                                         controller.update();
//                                       },
//                                       child: Icon(controller.hidePassword ? Icons.visibility_off : Icons.visibility),
//                                     ),
//                                   ),
//                                 )
//                               : SizedBox(),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   controller.withPaasword = !controller.withPaasword;
//                                   controller.update();
//                                 },
//                                 child: Container(
//                                     padding: const EdgeInsets.only(
//                                       bottom: 1, // Space between underline and text
//                                     ),
//                                     decoration: BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(
//                                           color: AppColor.primaryColor,
//                                           width: 1.0, // Underline thickness
//                                         ),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       controller.withPaasword ? 'With OTP' : 'With Password',
//                                       style: TextStyle(color: AppColor.primaryColor, fontSize: 14, fontWeight: FontWeight.w700),
//                                     )
//                                     //  AppText(
//                                     //   text: controller.withPaasword ? 'With OTP' : 'With Password',
//                                     //   fontColor: ConstColor.headingTexColor,
//                                     //   fontSize: Sizes.px14,
//                                     //   fontWeight: FontWeight.w700,
//                                     // ),
//                                     ),
//                               )
//                             ],
//                           ),
//                           const SizedBox(height: 40),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.width * 0.13,
//                             width: MediaQuery.of(context).size.width * 0.40,
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 loginController.isLoadingLogin ? null : await loginController.requestLogin(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColor.lightgreen,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: loginController.isLoadingLogin
//                                   ? const CircularProgressIndicator()
//                                   : Text(
//                                       AppString.login,
//                                       style: TextStyle(
//                                         color: AppColor.black,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w700,
//                                         fontFamily: CommonFontStyle.plusJakartaSans,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           controller.withPaasword
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         Get.to(() => ForgotpassScreen(mobileNumber: loginController.numberController.text),
//                                             duration: const Duration(milliseconds: 700));
//                                       },
//                                       child: Container(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 1, // Space between underline and text
//                                           ),
//                                           decoration: BoxDecoration(
//                                             border: Border(
//                                               bottom: BorderSide(
//                                                 color: AppColor.primaryColor,
//                                                 width: 1.0, // Underline thickness
//                                               ),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             'Forgot Password?',
//                                             style: TextStyle(color: AppColor.primaryColor, fontSize: 14, fontWeight: FontWeight.w700),
//                                           )
//                                           // AppText(
//                                           //   text: 'Forgot Password?',
//                                           //   fontColor: ConstColor.headingTexColor,
//                                           //   fontSize: Sizes.px14,
//                                           //   fontWeight: FontWeight.w700,
//                                           // ),
//                                           ),
//                                     )
//                                   ],
//                                 )
//                               : const SizedBox(),
//                         ],
//                       ),
//                       // MediaQuery.of(context).viewInsets.bottom > 0
//                       //     ? const Spacer()
//                       //     : Align(
//                       //         alignment: Alignment.bottomCenter,
//                       //         child: Image.asset(
//                       //           'assets/Venus_Hospital_New_Logo-removebg-preview.png',
//                       //           width: MediaQuery.of(context).size.width * 0.8,
//                       //         ),
//                       //       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//       );
//     });
//   }
// }

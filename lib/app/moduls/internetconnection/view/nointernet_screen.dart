import 'package:schoolapp/app/app_custom_widget/common_elevated_button.dart';
import 'package:schoolapp/app/app_custom_widget/common_text.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetView extends GetView<NoInternetController> {
  const NoInternetView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(NoInternetController());
    Sizes.init(context);
    return GetBuilder(builder: (NoInternetController controller) {
      return Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImage.nointernet,
                          height: 73,
                          width: 156,
                        ),
                        SizedBox(
                          height: Sizes.crossLength * 0.030,
                        ),
                        AppText(
                          text: "Oops!",
                          textAlign: TextAlign.center,
                          fontSize: Sizes.px25,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: Sizes.crossLength * 0.030,
                        ),
                        // const Spacer(),
                        AppText(
                          text: "There is no internet connection \n please check your internet connection.",
                          textAlign: TextAlign.center,
                          fontSize: Sizes.px18,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: Sizes.crossLength * 0.035,
                        ),
                        Center(
                          child: AppButton(
                            radius: 50,
                            // backgroundColor: Colors.transparent,
                            textColor: AppColor.white,
                            // padding: const EdgeInsets.symmetric(vertical: 15),
                            text: "Try Again",
                            onPressed: () {
                              controller.getConnectivityType();
                              // Get.back();
                            },
                          ),
                        ),
                        // const Spacer(),
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
              ],
            ),
          ),
          // ),
        ),
      );
    });
  }
}

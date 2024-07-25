import 'package:emp_app/app/app_custom_widget/common_elevated_button.dart';
import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/core/theme/const_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
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
        backgroundColor: ConstColor.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: Row(
                //     children: [
                //       Flexible(
                //         child: Image.asset(
                //           AssetPngs.tfgLogo, // ConstAsset.tfgLogoPNG,
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Flexible(
                //         flex: 5,
                //         child: AppText(
                //           text: Strings.togetherForGood,
                //           textAlign: TextAlign.center,
                //           fontSize: Responsive.isTablet ? 30 : 20.spMin,
                //           fontWeight: FontWeight.w600,
                //           fontFamily: FontConst.museoSlab,
                //           fontColor: const Color(0xff00313C),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const Spacer(),
                // sizedBox40,
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/notinternet.png",
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
                            textColor: ConstColor.whiteColor,
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

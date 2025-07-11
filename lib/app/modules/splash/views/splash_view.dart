import 'package:schoolapp/app/core/util/app_image.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Sizes.init(context);
    Get.put(SplashController());
    return GetBuilder<SplashController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Color(0xffEEF7F3),
        body: Center(
          child: Image.asset(
            AppImage.venuslogo,
            // scale: 2,
            width: Sizes.crossLength * 0.30,
          ),
        ),
      );
    });
  }
}

import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OvertimeController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  

  final count = 0.obs;

  void increment() => count.value++;
}

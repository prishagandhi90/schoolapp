import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaveController extends GetxController {
  var bottomBarController = Get.put(BottomBarController());
  // var scaffoldKey = GlobalKey<ScaffoldState>();

  final count = 0.obs;

  void increment() => count.value++;

  TextEditingController formDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      update();
    }
  }

  final List<String> nameList = [
    'Privilege Leave',
    'Casual Leave',
    'Sick Leave',
    'Holiday Off',
    'Covid Off',
    'Maternity Leave',
    'Leave Without Pay',
  ];
}

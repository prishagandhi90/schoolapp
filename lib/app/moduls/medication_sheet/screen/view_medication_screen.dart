import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:flutter/material.dart';

class ViewMedicationScreen extends StatelessWidget {
  const ViewMedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text(AppString.viewmedication, style: AppStyle.primaryplusw700),
            backgroundColor: AppColor.white,
            centerTitle: true,
      ),
    );
  }
}

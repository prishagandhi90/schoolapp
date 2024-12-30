import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';

class LvotapprovalScreen extends StatelessWidget {
  const LvotapprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('LV/OT Approval'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildContainer('In-Charge'),
                buildContainer('HOD'),
                buildContainer('HR'),
              ],
            ),
          ],
        ));
  }

  Widget buildContainer(String text) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        color: AppColor.lightwhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

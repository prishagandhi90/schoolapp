import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/model/leaveotlist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LvotapprovalController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  final ApiController apiController = Get.put(ApiController());
  List<LeaveotlistModel> leavelist = [];

  @override
  void onInit() {
    fetchLeaveOTList();
    super.onInit();
  }
  Future<List<LeaveotlistModel>> fetchLeaveOTList() async {
    try {
      update();
      isLoading = true;
      String url = ConstApiUrl.empLeaveOTapprovalList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveOTList responseLeaveOTList = ResponseLeaveOTList.fromJson(jsonDecode(response));

      if (responseLeaveOTList.statusCode == 200) {
        leavelist.clear();
        leavelist.assignAll(responseLeaveOTList.data ?? []);
        isLoading = false;
      } else if (responseLeaveOTList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveOTList.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    return [];
  }

  Future<void> lvotlistbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
        backgroundColor: AppColor.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: Get.context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: AppColor.black),
        ),
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 30),
                const Spacer(),
                Container(
                  width: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: Divider(height: 20, color: AppColor.originalgrey, thickness: 5),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: AppColor.lightblue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    // width: double.infinity,
                    // height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                    child: Container(
                        // height: 100,
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(AppString.otentmin, style: AppStyle.w50018)),
                  ),
                  Container(
                      // height: 100,
                      width: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.center,
                      child:
                          // controller.attendenceDetailTable.length > 0
                          //     ?
                          Text(
                        'abc', //controller.attendenceDetailTable[index].oTENTMIN.toString(),
                        style: AppStyle.fontfamilyplus,
                      )
                      // : Text('--:-- ', style: AppStyle.plus16w600),
                      )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: AppColor.lightblue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    // width: double.infinity,
                    // height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                    child: Container(
                        // height: 100,
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(AppString.otentmin, style: AppStyle.w50018)),
                  ),
                  Container(
                      // height: 100,
                      width: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.center,
                      child:
                          // controller.attendenceDetailTable.length > 0
                          //     ?
                          Text(
                        'abc', //controller.attendenceDetailTable[index].oTENTMIN.toString(),
                        style: AppStyle.fontfamilyplus,
                      )
                      // : Text('--:-- ', style: AppStyle.plus16w600),
                      )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: AppColor.lightblue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    // width: double.infinity,
                    // height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                    child: Container(
                        // height: 100,
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(AppString.otentmin, style: AppStyle.w50018)),
                  ),
                  Container(
                      // height: 100,
                      width: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.center,
                      child:
                          // controller.attendenceDetailTable.length > 0
                          //     ?
                          Text(
                        'abc', //controller.attendenceDetailTable[index].oTENTMIN.toString(),
                        style: AppStyle.fontfamilyplus,
                      )
                      // : Text('--:-- ', style: AppStyle.plus16w600),
                      )
                ],
              ),
            )
          ]);
        });
  }
}

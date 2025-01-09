import 'dart:convert';
import 'dart:ffi';

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

class LvotapprovalController extends GetxController with SingleGetTickerProviderMixin {
  final TextEditingController searchController = TextEditingController();
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  final ApiController apiController = Get.put(ApiController());
  List<LeaveotlistModel> leavelist = [];
  List<LeaveotlistModel> filteredList = [];
  var isLoader = false.obs;
  late TabController tabController_Lv;
  var initialIndex = 0.obs;
  RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    // fetchLeaveOTList("InCharge", "LV");
    super.onInit();
    tabController_Lv = TabController(length: 2, vsync: this);
    tabController_Lv.addListener(_handleTabSelection);
  }

  void _handleTabSelection() async {
    if (tabController_Lv.indexIsChanging) {
      initialIndex.value = tabController_Lv.index;
      if (tabController_Lv.index == 1) {
        // await fetchLeaveEntryList("LV");
      }
      update();
    }
  }

  changeTab(int index) async {
    tabController_Lv.animateTo(index);
    currentTabIndex.value = index;
    if (index == 1 && leavelist.isEmpty) {
      // await fetchLeaveEntryList("LV"); // Fetch list only if not already fetched
    }
    update();
  }

  String selectedRole = ''; // Default selected role

  // selectRole(String role) async {
  //   selectedRole = role;
  //   update(); // Notify GetBuilder to rebuild
  // }

  Future<List<LeaveotlistModel>> updateFilteredList(String role, String leaveType) async {
    filteredList = leavelist.where((item) => item.typeValue == leaveType).toList();
    return [];
  }

  Future<List<LeaveotlistModel>> fetchLeaveOTList(String role, String leaveType) async {
    try {
      selectedRole = role;
      changeTab(0);
      update();
      isLoading = true;
      String url = ConstApiUrl.empLeaveOTapprovalList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      var jsonbodyObj;

      if (role.isEmpty) {
        jsonbodyObj = {"loginId": loginId, "empId": empId};
      } else {
        jsonbodyObj = {"loginId": loginId, "empId": empId, "role": role, "flag": leaveType};
      }
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveOTList responseLeaveOTList = ResponseLeaveOTList.fromJson(jsonDecode(response));

      if (responseLeaveOTList.statusCode == 200) {
        leavelist.clear();
        leavelist.assignAll(responseLeaveOTList.data ?? []);
        if (leavelist.isNotEmpty && leaveType.isNotEmpty) {
          if (role.isEmpty) {
            role = selectedRole;
          }
          filteredList = leavelist.where((item) => item.typeValue == leaveType).toList();
        } else {
          leavelist = [];
          filteredList = [];
        }
        isLoading = false;
      } else if (responseLeaveOTList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveOTList.statusCode == 400) {
        leavelist = [];
        filteredList = [];
        isLoading = false;
      } else {
        leavelist = [];
        filteredList = [];
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

  Future<void> lvlistbottomsheet(BuildContext context, int index) async {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Container(
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
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.centerLeft,
                          child: Text(AppString.reliever, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                    ),
                    Container(
                      // height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.centerLeft,
                      child: leavelist.length > 0
                          ? Text(
                              leavelist[index].relieverEmpName.toString(),
                              style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                            )
                          : Text('--:-- ', style: AppStyle.plus16w600),
                    )
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Container(
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
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.centerLeft,
                          child: Text(AppString.reason, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                    ),
                    Container(
                      // height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.centerLeft,
                      child: leavelist.length > 0
                          ? Text(
                              leavelist[index].reason.toString(),
                              style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                            )
                          : Text('--:-- ', style: AppStyle.plus16w600),
                    )
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Container(
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
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.centerLeft,
                          child: Text(AppString.leavetype, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                    ),
                    Container(
                      // height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.centerLeft,
                      child: leavelist.length > 0
                          ? Text(
                              leavelist[index].leaveShortName.toString(),
                              style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                            )
                          : Text('--:-- ', style: AppStyle.plus16w600),
                    )
                  ],
                ),
              ),
            )
          ]);
        });
  }

  Future<void> otlistbottomsheet(BuildContext context, int index) async {
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                    child: Container(
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(AppString.reliever, style: AppStyle.w50018)),
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

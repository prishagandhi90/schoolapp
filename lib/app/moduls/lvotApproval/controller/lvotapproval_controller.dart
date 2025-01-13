// ignore_for_file: deprecated_member_use

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

class LvotapprovalController extends GetxController with SingleGetTickerProviderMixin {
  final TextEditingController searchController = TextEditingController();
  String tokenNo = '', loginId = '', empId = '';
  // bool isLoading = false;
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

  bool isSearchActive = false;

  void activateSearch(bool isActive) {
    isSearchActive = isActive;
    update();
  }

  void clearSearch() {
    searchController.clear();
    update();
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
    // selectedLeaveType = index == 0 ? "LV" : "OT";
    tabController_Lv.animateTo(index);
    currentTabIndex.value = index;
    if (index == 1 && leavelist.isEmpty) {
      // await fetchLeaveEntryList("LV"); // Fetch list only if not already fetched
    }
    update();
  }

  void approveLeave(int index) {
    // Approve leave logic
    print("Leave approved for: ${filteredList[index].employeeCodeName}");
    Get.snackbar("Leave Approved", "Leave approved for ${filteredList[index].employeeCodeName}");
  }

  void rejectLeave(int index) {
    // Reject leave logic
    print("Leave rejected for: ${filteredList[index].employeeCodeName}");
    Get.snackbar("Leave Rejected", "Leave rejected for ${filteredList[index].employeeCodeName}");
  }

  void showApproveDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure you want to approve this record?",
                  style: TextStyle(color: AppColor.black, fontWeight: FontWeight.w600, fontSize: 20)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      approveLeave(index); // Approve action
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightgreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Approve", style: TextStyle(color: AppColor.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightred,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Close", style: TextStyle(color: AppColor.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showRejectDialog(BuildContext context, int index) {
    String selectedReason = ""; // Dropdown selection value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to reject this record?",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Dropdown for rejection reasons
              DropdownButtonFormField<String>(
                value: selectedReason.isEmpty ? null : selectedReason,
                items: [
                  "Reason 1",
                  "Reason 2",
                  "Reason 3",
                ].map((reason) {
                  return DropdownMenuItem(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedReason = value!;
                },
                decoration: const InputDecoration(
                  labelText: "Select Reason",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Row with Reject and Close buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // if (selectedReason.isEmpty) {
                  //     //   Get.snackbar(
                  //     //     "Error",
                  //     //     "Please select a reason before rejecting",
                  //     //     backgroundColor: Colors.red,
                  //     //     colorText: Colors.white,
                  //     //   );
                  //     // } else {
                  //     //   rejectLeave(index, selectedReason); // Perform rejection
                  //     //   Navigator.pop(context);
                  //     // }
                  //   },
                  //   child: const Text("Reject"),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightgreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Reject", style: TextStyle(color: AppColor.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightred,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Close", style: TextStyle(color: AppColor.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //  void showApproveDialog(BuildContext context, int index) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // title: const Text("Confirm Approval"),
  //         content: Text(
  //           "Are you sure you want to approve this record?",
  //           style: TextStyle(color: AppColor.black,fontWeight: FontWeight.w600,fontSize: 20),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               // Cancel action
  //               Navigator.pop(context);
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Approve action
  //               approveLeave(index);
  //               Navigator.pop(context);
  //             },
  //             child: const Text("Approve"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  String selectedRole = '', selectedLeaveType = ''; // Default selected role

  Future<List<LeaveotlistModel>> updateFilteredList(String role, String leaveType) async {
    isLoader.value = true;
    update();
    await changeTab(leaveType == "LV" ? 0 : 1);
    selectedLeaveType = leaveType;
    filteredList = leavelist.where((item) => item.typeValue == leaveType).toList();
    isLoader.value = false;
    update();
    return [];
  }

  void filterSearchResults(String query, String leaveType) {
    if (query.isEmpty) {
      filteredList = leavelist; // Show all data if search is empty
    } else {
      filteredList = leavelist.where((item) => item.typeValue == leaveType).toList();
      filteredList = filteredList.where((item) {
        final patientName = (item.employeeCodeName ?? "").toLowerCase();
        final employeecode = (item.employeeCodeValue ?? "").toLowerCase();

        return patientName.contains(query.toLowerCase()) || employeecode.contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  Future<List<LeaveotlistModel>> fetchLeaveOTList(String role, String leaveType) async {
    try {
      isLoader.value = true;
      selectedRole = role;
      selectedLeaveType = leaveType;
      // update();
      await changeTab(0);
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
          isLoader.value = false;
          filteredList = leavelist.where((item) => item.typeValue == leaveType).toList();
          update();
          return filteredList;
        } else {
          leavelist = [];
          filteredList = [];
        }
      } else if (responseLeaveOTList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveOTList.statusCode == 400) {
        leavelist = [];
        filteredList = [];
      } else {
        leavelist = [];
        filteredList = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoader.value = false;
      update();
    }
    isLoader.value = false;
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
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.centerLeft,
                        child: Text(AppString.reason, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                  ),
                  Container(
                    // height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        // height: 100,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.centerLeft,
                        child: Text(AppString.shiftTime, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                  ),
                  Container(
                    // height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.centerLeft,
                    child: leavelist.length > 0
                        ? Text(
                            leavelist[index].shiftTime.toString(),
                            style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                          )
                        : Text('--:-- ', style: AppStyle.plus16w600),
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
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.centerLeft,
                        child: Text(AppString.punchTime, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                  ),
                  Container(
                    // height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.centerLeft,
                    child: leavelist.length > 0
                        ? Text(
                            leavelist[index].punchTime.toString(),
                            style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                          )
                        : Text('--:-- ', style: AppStyle.plus16w600),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.centerLeft,
                        child: Text(AppString.employeenote, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600))),
                  ),
                  Container(
                    // height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.centerLeft,
                    child: leavelist.length > 0
                        ? Text(
                            leavelist[index].punchTime.toString(),
                            style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                          )
                        : Text('--:-- ', style: AppStyle.plus16w600),
                  )
                ],
              ),
            )
          ]);
        });
  }
}

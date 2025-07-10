// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:schoolapp/app/app_custom_widget/custom_dropdown.dart';
import 'package:schoolapp/app/core/service/api_service.dart';
import 'package:schoolapp/app/core/util/api_error_handler.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/const_api_url.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/leave/screen/widget/custom_textformfield.dart';
import 'package:schoolapp/app/moduls/login/screen/login_screen.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/lvotApproval/model/leaveapprejlist_model.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/lvotApproval/model/leaveotlist_model.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/lvotApproval/model/otreason_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LvotapprovalController extends GetxController with SingleGetTickerProviderMixin {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController reasonnameController = TextEditingController();
  final TextEditingController reasonvalueController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  final ApiController apiController = Get.put(ApiController());
  List<LeaveotlistModel> leavelist = [];
  final ScrollController lvappScrollController = ScrollController();
  List<LeaveotlistModel> filteredList = [];
  List<ResponseLeaveOTList> responseLeaveOTList = [];
  List<LeaveotlistModel> selectedItems = [];
  List<SaveAppRejLeaveList> saveAppRejLeaveList = [];
  List<ReasonList> reasonList = [];
  var isLoader = false.obs;
  late TabController tabController_Lv;
  var initialIndex = 0.obs;
  RxInt currentTabIndex = 0.obs;
  RxBool InchargeYN_c = false.obs;
  RxBool HODYN_c = false.obs;
  RxBool HRYN_c = false.obs;
  bool isSearchActive = false;
  var isSelectionMode = false.obs;
  var isAllSelected = false.obs;
  RxBool hideBottomBar = false.obs;
  final bottomBarController = Get.put(BottomBarController());
  String selectedRole = '', selectedLeaveType = ''; // Default selected role
  Map<String, String> roleStatus = {}; // Stores role statuses: "Y" or "N"
  bool byPassApprove = false;
  final FocusNode notesFocusNode = FocusNode();
  bool showShortButton = true;

  @override
  void onInit() {
    // fetchLeaveOTList("InCharge", "LV");
    super.onInit();
    tabController_Lv = TabController(length: 2, vsync: this);
    tabController_Lv.addListener(_handleTabSelection);
    fetchOTReason();

    lvappScrollController.addListener(() {
      if (lvappScrollController.position.userScrollDirection == ScrollDirection.forward) {
        print("Scrolling up");
        if (hideBottomBar.value) {
          hideBottomBar.value = false;
          bottomBarController.update();
        }
      } else if (lvappScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        print("Scrolling down");
        if (!hideBottomBar.value) {
          hideBottomBar.value = true;
          bottomBarController.update();
        }
      }
    });
  }

  @override
  void dispose() {
    // Custom back button action for Android hardware button
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    super.dispose();
  }

  enterSelectionMode(int index) async {
    isSelectionMode.value = true;
    selectedItems.add(filteredList[index]);
    update();
  }

  exitSelectionMode() async {
    isSelectionMode.value = false;
    isAllSelected.value = false;
    selectedItems.clear();
    update();
  }

  toggleSelection(int index, bool value) async {
    if (value) {
      selectedItems.add(filteredList[index]);
    } else {
      selectedItems.remove(filteredList[index]);
    }
    isAllSelected.value = selectedItems.length == filteredList.length;
    update();
  }

  toggleSelectAll(bool value) async {
    if (value) {
      selectedItems = List.from(filteredList);
    } else {
      selectedItems.clear();
    }
    isAllSelected.value = value;
    update();
  }

  activateSearch(bool isActive) async {
    isSearchActive = isActive;
    update();
  }

  clearSearch() async {
    searchController.clear();
    filteredList = leavelist.where((item) => item.typeValue == selectedLeaveType).toList(); // Search bar clear karo
    filteredList = List.from(filteredList); // Original list wapas set karo
    update(); // UI update karo
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

  Future<List<LeaveotlistModel>> updateFilteredList(String role, String leaveType) async {
    isLoader.value = true;
    update();
    // await changeTab(leaveType == "LV" ? 0 : 1);
    selectedLeaveType = leaveType;
    filteredList = leavelist.where((item) => item.typeValue == leaveType).toList();
    isLoader.value = false;
    update();
    return [];
  }

  void filterSearchResults(String query, String leaveType) {
    if (query.isEmpty) {
      clearSearch(); // Directly clearSearch() call kar do
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

  bool getRoleStatus(String role) {
    return roleStatus[role] == 'Y';
  }

  rejectreasonChangeMethod(Map<String, String>? value) async {
    reasonvalueController.text = value!['text'] ?? '';
    reasonnameController.text = value['text'] ?? '';
    update();
  }

  Future<List<LeaveotlistModel>> fetchLeaveOTList(String role, String leaveType) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoader.value = true;
      selectedRole = role;
      selectedLeaveType = leaveType;
      update();
      // await changeTab(0);
      String url = ConstApiUrl.empLeaveOTapprovalList;
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
      update_roles(responseLeaveOTList);
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
      ApiErrorHandler.handleError(
        screenName: "LV/OTApprovalScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoader.value = false;
    return [];
  }

  void update_roles(ResponseLeaveOTList responseLeaveOTList) {
    selectedRole = selectedRole == '' ? (responseLeaveOTList.defaultRole ?? '') : selectedRole;
    InchargeYN_c.value = responseLeaveOTList.inchargeYN == 'Y';
    HODYN_c.value = responseLeaveOTList.hodyn == 'Y';
    HRYN_c.value = responseLeaveOTList.hryn == 'Y';
  }

  Future<List<SaveAppRejLeaveList>> fetchLeave_app_rej_List(String action, int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String UpdFlag = "";
      if (selectedRole.toString().toLowerCase() == "incharge") {
        UpdFlag = "INC"; // Incharge
      } else if (selectedRole.toString().toLowerCase() == "hr") {
        UpdFlag = "HR"; // HR
      } else if (selectedRole.toString().toLowerCase() == "hod") {
        UpdFlag = "HOD"; // Admin
      }
      isLoader.value = true;
      update();
      String url = ConstApiUrl.empLeaveAppRejListData;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "flag": UpdFlag,
        "leaveDetailId": filteredList[index].leaveId.toString(),
        "action": action, // "Approved" or "Rejected"
        "reason": "",
        "userName": "",
        "note": noteController.text
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveAppRejList responseLeaveAppRejList = ResponseLeaveAppRejList.fromJson(jsonDecode(response));

      if (responseLeaveAppRejList.statusCode == 200) {
        if (responseLeaveAppRejList.data![0].savedYN == "Y") {
          filteredList.removeAt(index);
          filteredList = leavelist.where((item) => item.typeValue == selectedLeaveType).toList();
          await fetchLeaveOTList(selectedRole, selectedLeaveType);
          Get.rawSnackbar(
              message: action.toLowerCase() == "approved"
                  ? "Leave approved successfully!"
                  : (action.toLowerCase() == "rejected" ? "Leave rejected successfully!" : "Note saved successfully!"));
        } else {
          Get.rawSnackbar(message: "Action failed: ${responseLeaveAppRejList.data![0].savedYN}");
        }
      } else if (responseLeaveAppRejList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      Get.rawSnackbar(message: "An error occurred");
      ApiErrorHandler.handleError(
        screenName: "LV/OTApprovalScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoader.value = false;
    noteController.text = "";
    update();
    return [];
  }

  Future<List<SaveAppRejLeaveList>> SelectAll_Leave_app_rej_List() async {
    try {
      isLoader.value = true;
      update();

      String url = ConstApiUrl.empAppRejLeaveOTEntryList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      var jsonbodyObj = {"loginId": loginId, "list_Resp_LV_OT_Roles": selectedItems};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveOTList responseLeaveAppRejList = ResponseLeaveOTList.fromJson(jsonDecode(response));

      if (responseLeaveAppRejList.statusCode == 200) {
        if (responseLeaveAppRejList.message == "Y") {
          // leavelist.removeAt(index);
          // filteredList = leavelist.where((item) => item.typeValue == selectedLeaveType).toList();
          await fetchLeaveOTList(selectedRole, selectedLeaveType);
          await exitSelectionMode();
          Get.rawSnackbar(message: "Leave approved successfully!");
        } else {
          Get.rawSnackbar(message: "Action failed");
        }
      } else if (responseLeaveAppRejList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      Get.rawSnackbar(message: "An error occurred");
    }
    isLoader.value = false;
    return [];
  }

  Future<List<ReasonList>> fetchOTReason() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empGetLeaveRejectReason;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponseLVRejReason rsponseLVRejReason = RsponseLVRejReason.fromJson(jsonDecode(response));

      if (rsponseLVRejReason.statusCode == 200) {
        reasonList.clear();
        reasonList.assignAll(rsponseLVRejReason.data ?? []);
        isLoading = false;
      } else if (rsponseLVRejReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLVRejReason.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "LV/OTApprovalScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return reasonList.toList();
  }

  void showByPassApproveDialog(BuildContext context) {
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
              Text("You are going to approve rejected leave or overtime. Are you sure you want to accept this record?",
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    // fontSize: 20,
                    fontSize: getDynamicHeight(size: 0.022),
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await SelectAll_Leave_app_rej_List();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightgreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Yes", style: TextStyle(color: AppColor.black)),
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
                    child: Text("No", style: TextStyle(color: AppColor.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showApproveAllDialog(BuildContext context) {
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
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    // fontSize: 20,
                    fontSize: getDynamicHeight(size: 0.022),
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await SelectAll_Leave_app_rej_List();
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
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w600,
                    // fontSize: 20,
                    fontSize: getDynamicHeight(size: 0.022),
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await fetchLeave_app_rej_List("Approved", index);
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
    showDialog(
        context: context,
        builder: (context) {
          return GetBuilder<LvotapprovalController>(
            // Wrap with GetBuilder
            builder: (controller) {
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
                        onPressed: () async {
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
                    CustomDropdown(
                      text: AppString.reason,
                      controller: reasonnameController,
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.black),
                          borderRadius: BorderRadius.circular(0),
                          color: AppColor.white,
                        ),
                      ),
                      onChanged: (value) async {
                        await rejectreasonChangeMethod(value);
                        update();
                      },
                      width: double.infinity,
                      items: reasonList
                          .map((ReasonList item) => DropdownMenuItem<Map<String, String>>(
                                value: {
                                  'value': item.name ?? '', // Use the value as the item value
                                  'text': item.name ?? '', // Display the name in the dropdown
                                },
                                child: Text(
                                  item.name ?? '', // Display the name in the dropdown
                                  style: AppStyle.black.copyWith(
                                    // fontSize: 14,
                                    fontSize: getDynamicHeight(size: 0.016),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await fetchLeave_app_rej_List("Rejected", index);
                            Navigator.pop(context);
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
                          onPressed: () async {
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
        });
  }

  void showNoteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<LvotapprovalController>(
          builder: (controller) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.all(16.0),
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
                mainAxisSize: MainAxisSize.min, // ✅ Wrap content according to size
                children: [
                  CustomTextFormField(
                    hint: AppString.note,
                    hintStyle: AppStyle.black.copyWith(
                      fontSize: getDynamicHeight(size: 0.016),
                    ),
                    minLines: 3,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: controller.noteController,
                    focusNode: controller.notesFocusNode,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppString.notesisrequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 🔹 Cancel Button
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.10,
                        width: MediaQuery.of(context).size.width * 0.27,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.lightred,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Close",
                            style: AppStyle.black.copyWith(
                              fontSize: getDynamicHeight(size: 0.018),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.10,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: ElevatedButton(
                          onPressed: () async {
                            await fetchLeave_app_rej_List("CALL_EMP", index);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.lightgreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppString.save,
                            style: AppStyle.black.copyWith(
                              fontSize: getDynamicHeight(size: 0.018),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.90,
          width: Get.width,
          child: GetBuilder<LvotapprovalController>(
              // Wrap with GetBuilder
              builder: (controller) {
            final isIncharge = selectedRole == "InCharge" ? true : false;
            final isHOD = selectedRole == "HOD" ? true : false;
            final isHR = selectedRole == "HR" ? true : false;

            List<Widget> content = [];
            List<Widget> InchargeParameters = [
              parameterWidget(
                title: AppString.reliever,
                value: filteredList[index].relieverEmpName?.toString() ?? '--:--',
              ),
              parameterWidget(
                title: AppString.reason,
                value: filteredList[index].reason?.toString() ?? '--:--',
              ),
              // parameterWidget(
              //   title: AppString.leavetype,
              //   value: filteredList[index].leaveShortName?.toString() ?? '--:--',
              // ),
              parameterWidget(
                title: AppString.inChargeNotes,
                value: filteredList[index].inchargeNote?.toString() ?? '--:--',
              ),
              parameterWidget(
                title: AppString.hodNotes,
                value: filteredList[index].hoDNote?.toString() ?? '--:--',
              ),
              parameterWidget(
                title: AppString.hrnotes,
                value: filteredList[index].hrNote?.toString() ?? '--:--',
              ),
            ];

            List<Widget> HODParameters = [
              parameterWidget(
                title: AppString.inchargestatus,
                value: filteredList[index].inchargeAction?.toString() ?? '--:--',
              ),
            ];

            if (isIncharge) {
              content.addAll(InchargeParameters);
            }

            if (isHOD || isHR) {
              content.addAll(InchargeParameters);
              content.addAll(HODParameters);
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        const SizedBox(width: 30),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                    ...content,
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget parameterWidget({required String title, required String value}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.30,
              ),
              decoration: BoxDecoration(
                color: AppColor.lightblue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.primaryColor,
                    ),
                    child: Row(
                      children: [
                        Text(title, style: AppStyle.w50018.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: AppStyle.fontfamilyplus.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> otlistbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: Get.context!,
      // context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: AppColor.black),
      ),
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.90,
          width: Get.width,
          child: GetBuilder<LvotapprovalController>(
            builder: (controller) {
              final isIncharge = selectedRole == "InCharge" ? true : false;
              final isHOD = selectedRole == "HOD" ? true : false;
              final isHR = selectedRole == "HR" ? true : false;

              List<Widget> content = [];
              List<Widget> InchargeParameters = [
                parameterWidget(
                  title: AppString.reason,
                  value: filteredList[index].reason?.toString() ?? '--:--',
                ),
                parameterWidget(
                  title: AppString.shiftTime,
                  value: filteredList[index].shiftTime?.toString() ?? '--:--',
                ),
                parameterWidget(
                  title: AppString.punchTime,
                  value: filteredList[index].punchTime?.toString() ?? '--:--',
                ),
                parameterWidget(
                  title: AppString.employeenote,
                  value: filteredList[index].note?.toString() ?? '--:--',
                ),
                parameterWidget(
                  title: AppString.inChargeNotes,
                  value: filteredList[index].inchargeNote?.toString() ?? '--:--',
                ),
                parameterWidget(
                  title: AppString.hodNotes,
                  value: filteredList[index].hoDNote?.toString() ?? '--:--',
                ),
                parameterWidget(
                  title: AppString.hrnotes,
                  value: filteredList[index].hrNote?.toString() ?? '--:--',
                ),
              ];

              if (isIncharge) {
                content.addAll(InchargeParameters);
              }

              if (isHOD || isHR) {
                content.addAll([
                  parameterWidget(
                    title: AppString.reason,
                    value: filteredList[index].reason?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.inchargestatus,
                    value: filteredList[index].inchargeAction?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.shiftTime,
                    value: filteredList[index].shiftTime?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.punchTime,
                    value: filteredList[index].punchTime?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.employeenote,
                    value: filteredList[index].note?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.inChargeNotes,
                    value: filteredList[index].inchargeNote?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.hodNotes,
                    value: filteredList[index].hoDNote?.toString() ?? '--:--',
                  ),
                  parameterWidget(
                    title: AppString.hrnotes,
                    value: filteredList[index].hrNote?.toString() ?? '--:--',
                  ),
                ]);
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          const SizedBox(width: 30),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                      ...content,
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  resetForm() async {
    Get.back();
    // await changeTab(0);
    tabController_Lv.animateTo(0);
    await exitSelectionMode();
    await clearSearch();
    leavelist.clear();
    filteredList.clear();
    selectedRole = "";
    selectedLeaveType = "";
    searchController.clear();
    reasonnameController.clear();
    reasonvalueController.clear();
    noteController.clear();
    reasonList.clear();
    initialIndex = 0.obs;
    currentTabIndex = 0.obs;
    InchargeYN_c = false.obs;
    HODYN_c = false.obs;
    HRYN_c = false.obs;
    isSearchActive = false;
    roleStatus.clear();
    update();
  }
}

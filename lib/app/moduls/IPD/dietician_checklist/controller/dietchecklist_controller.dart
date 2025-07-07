import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/model/dieticianfilter_model.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/model/dieticianfilterwardnm_model.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/model/dieticianlist_model.dart';
import 'package:emp_app/app/moduls/PAYROLL_MAIN/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietchecklistController extends GetxController {
  @override
  void onInit() {
    fetchDieticianList();
    fetchDieticianfilterwardNM();
    super.onInit();
  }

  final TextEditingController searchController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController relativeFoodRemarkController = TextEditingController();
  final ScrollController dieticianScrollController = ScrollController();
  final AdPatientController adPatientController = Get.put(AdPatientController());
  String selectedTabLabel = 'ALL';
  bool isLoading = false;
  List<DieticianlistModel> dieticianList = [];
  List<DieticianlistModel> filterdieticianList = [];
  String tokenNo = '', loginId = '', empId = '';
  final bottomBarController = Get.put(BottomBarController());
  final ApiController apiController = Get.put(ApiController());
  List<Wards> wards = [];
  List<Floors> floors = [];
  List<Beds> beds = [];
  List<String> selectedWardList = [];
  List<String> selectedFloorList = [];
  List<String> selectedBedList = [];
  bool callFilterAPi = false;
  int? sortBySelected;
  List<String> tempWardList = [];
  List<String> tempFloorsList = [];
  List<String> tempBedList = [];
  List<DieticianfilterwardnmModel> allTabs = [];
  List<DieticianfilterwardnmModel> otherTabs = [];
  bool isTemplateVisible = true;

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filterdieticianList = dieticianList; // Show all data if search is empty
    } else {
      filterdieticianList = dieticianList.where((item) {
        final patientName = (item.patientName ?? "").toLowerCase();
        final ipdNo = (item.ipdNo ?? "").toUpperCase();
        final uhid = (item.uhidNo ?? "").toUpperCase();

        // Check if query matches either patientName or ipdNo
        return patientName.contains(query.toLowerCase()) || ipdNo.contains(query.toUpperCase()) || uhid.contains(query.toUpperCase());
      }).toList();
    }
    update();
  }

  void updateSelectedTab(String shortWardNameLabel) {
    selectedTabLabel = shortWardNameLabel;

    if (shortWardNameLabel.toLowerCase() == 'all') {
      selectedWardList = []; // 'ALL' tab clicked
    } else {
      // 🔁 Find the actual wardName from shortWardName
      String? actualWardName = allTabs
          .followedBy(otherTabs)
          .firstWhere(
            (e) => e.shortWardName == shortWardNameLabel,
            orElse: () => DieticianfilterwardnmModel(wardName: ''),
          )
          .wardName;

      selectedWardList = [actualWardName ?? '']; // ✅ Actual filtering value
    }

    fetchDieticianList(); // ⬅️ Call list fetch API
    update();
  }

  Future<List<DieticianlistModel>> fetchDieticianList({String? searchPrefix}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empDieticianChecklistListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "prefixText": searchPrefix ?? '',
        "wards": selectedWardList,
        "floors": selectedFloorList,
        "beds": selectedBedList,
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDieticianListData responseDieticianListData = ResponseDieticianListData.fromJson(jsonDecode(response));

      dieticianList.clear();
      if (responseDieticianListData.statusCode == 200) {
        dieticianList.assignAll(responseDieticianListData.data ?? []);
        if (responseDieticianListData.data != null && responseDieticianListData.data!.isNotEmpty) {
          filterdieticianList = responseDieticianListData.data!;
        } else {
          filterdieticianList = [];
        }
        isLoading = false;
      } else if (responseDieticianListData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseDieticianListData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "DieticianListScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return dieticianList.toList();
  }

  Future<void> fetchDieticianfilterwardNM() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empDieticianFilterWardNameAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDietWardName responseDietWardName = ResponseDietWardName.fromJson(jsonDecode(response));

      if (responseDietWardName.statusCode == 200) {
        allTabs.clear();
        otherTabs.clear();

        List<DieticianfilterwardnmModel> tabs = responseDietWardName.data ?? [];

        allTabs.addAll(tabs.where((e) => (e.shortWardName?.toLowerCase() == 'all')));
        otherTabs.addAll(tabs.where((e) => (e.shortWardName?.toLowerCase() != 'all')));

        // ✅ Select default tab
        selectedTabLabel =
            allTabs.isNotEmpty ? allTabs.first.shortWardName ?? '' : (otherTabs.isNotEmpty ? otherTabs.first.shortWardName ?? '' : '');

        // ✅ 👇 Important: Call updateSelectedTab here so that list loads based on selected ward
        updateSelectedTab(selectedTabLabel);

        isLoading = false;
      } else if (responseDietWardName.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseDietWardName.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      ApiErrorHandler.handleError(
        screenName: "DieticianListScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    update();
  }

  Future<void> dieticianBottomSheet(int index) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      context: Get.context!,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 0,
                maxHeight: Get.height * 0.9, // 🔸 max 90% height tak jaa sakta hai
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: getDynamicHeight(size: 0.007)),

                    /// 🔹 Top Handle & Close Icon
                    Row(
                      children: [
                        SizedBox(width: getDynamicHeight(size: 0.02)),
                        const Spacer(),
                        Container(
                          width: getDynamicHeight(size: 0.06),
                          child: Divider(
                            height: getDynamicHeight(size: 0.025),
                            color: AppColor.originalgrey,
                            thickness: getDynamicHeight(size: 0.0065),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            size: getDynamicHeight(size: 0.025),
                          ),
                        ),
                        SizedBox(width: getDynamicHeight(size: 0.02)),
                      ],
                    ),
                    SizedBox(height: getDynamicHeight(size: 0.007)),

                    /// 🔹 ID & UHID Section
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: getDynamicHeight(size: 0.047),
                            padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
                            decoration: BoxDecoration(color: AppColor.primaryColor),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getDynamicHeight(size: 0.04),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppString.id,
                                      style: AppStyle.w50018.copyWith(
                                        color: AppColor.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Uhid',
                                      style: AppStyle.w50018.copyWith(
                                        color: AppColor.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getDynamicHeight(size: 0.05),
                                    vertical: getDynamicHeight(size: 0.01),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    filterdieticianList[index].id.toString(),
                                    style: AppStyle.fontfamilyplus,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    filterdieticianList[index].uhidNo.toString(),
                                    style: AppStyle.fontfamilyplus,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 Relative Remark & User
                    _buildNoteSection('Relative food mark', filterdieticianList[index].relFoodRemark.toString()),
                    _buildNoteSection(AppString.user, filterdieticianList[index].username.toString()),

                    SizedBox(height: getDynamicHeight(size: 0.03)), // 🟢 extra space at bottom
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteSection(String title, String content) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
            width: double.infinity,
            height: getDynamicHeight(size: 0.047),
            color: AppColor.primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.02)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: AppStyle.w50018.copyWith(color: AppColor.white),
                ),
              ),
            ),
          ),
          // controller.otentryList.isNotEmpty
          //     ?
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getDynamicHeight(size: 0.015),
              vertical: getDynamicHeight(size: 0.01),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.015)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: content.isNotEmpty ? AppStyle.fontfamilyplus : AppStyle.plus16w600,
                ),
              ),
            ),
          )
          // : Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: Align(alignment: Alignment.centerLeft, child: Text('--:--', style: AppStyle.plus16w600)),
          //   ),
        ],
      ),
    );
  }

  void showDietDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🟦 Patient Name + IPD + Close Icon
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${dieticianList[index].patientName} (${dieticianList[index].ipdNo})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                /// 🔹 Diagnosis
                CustomTextFormField(
                  controller: diagnosisController,
                  decoration: InputDecoration(
                    hintText: "Diagnosis",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getDynamicHeight(size: 0.010),
                      vertical: getDynamicHeight(size: 0.012),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// 🔹 Diet Dropdown
                Visibility(
                  visible: isTemplateVisible,
                  child: CustomDropdown(
                    text: 'Diet',
                    textStyle: TextStyle(color: AppColor.black1),
                    controller: TextEditingController(),
                    buttonStyleData: ButtonStyleData(
                      height: getDynamicHeight(size: 0.05),
                      // padding: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.originalgrey),
                        borderRadius: BorderRadius.circular(3),
                        color: AppColor.white,
                      ),
                    ),
                    onChanged: (value) async {
                      // await templateChangeMethod(value);
                    },
                    items: [],
                    // items: controller.templatedropdownTable
                    //     .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
                    //           value: {
                    //             'value': item.value ?? '',
                    //             'text': item.name ?? '',
                    //           },
                    //           child: Text(
                    //             item.name ?? '',
                    //             style: AppStyle.black.copyWith(
                    //               fontSize: getDynamicHeight(size: 0.016),
                    //             ),
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //         ))
                    //     .toList(),
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 10),

                /// 🔹 Remarks
                CustomTextFormField(
                  controller: remarksController,
                  decoration: InputDecoration(
                    hintText: "Remarks",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getDynamicHeight(size: 0.010),
                      vertical: getDynamicHeight(size: 0.012),
                    ),
                  ),
                  minLines: 1,
                  maxLines: 10,
                ),
                SizedBox(height: getDynamicHeight(size: 0.012)),
                CustomTextFormField(
                  controller: relativeFoodRemarkController,
                  decoration: InputDecoration(
                    hintText: "Relative Food Remarks",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getDynamicHeight(size: 0.010),
                      vertical: getDynamicHeight(size: 0.012),
                    ),
                  ),
                  minLines: 2,
                  maxLines: 10,
                ),
                const SizedBox(height: 20),

                /// 🟩 Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// ✅ Save Button
                    ElevatedButton(
                      onPressed: () {
                        // 🔃 Save logic here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),

                    /// ❌ Cancel Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(100, 40),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

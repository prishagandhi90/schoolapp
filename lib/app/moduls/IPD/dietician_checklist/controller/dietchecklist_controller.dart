import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:schoolapp/app/app_custom_widget/custom_date_picker.dart';
import 'package:schoolapp/app/app_custom_widget/custom_dropdown.dart';
import 'package:schoolapp/app/core/service/api_service.dart';
import 'package:schoolapp/app/core/util/api_error_handler.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/const_api_url.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/model/dieticianfilter_model.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/model/dieticianfilterwardnm_model.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/model/dieticianlist_model.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/model/dietplandropdown_model.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/model/dietsavechecklistmaster_model.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/widgets/bed_checkbox.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/widgets/floor_checkbox.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/widgets/ward_checkbox.dart';
import 'package:schoolapp/app/moduls/PAYROLL_MAIN/leave/screen/widget/custom_textformfield.dart';
import 'package:schoolapp/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:schoolapp/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietchecklistController extends GetxController {
  @override
  void onInit() {
    fetchDieticianList();
    fetchDieticianfilterwardNM();
    GetDieticianFilterData();
    fetchDietPlanDropDown();
    super.onInit();
  }

  final TextEditingController searchController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController dietNameController = TextEditingController();
  final TextEditingController dietIdController = TextEditingController();
  final TextEditingController relativeFoodRemarkController = TextEditingController();
  final ScrollController dieticianScrollController = ScrollController();
  final AdPatientController adPatientController = Get.put(AdPatientController());
  String selectedTabLabel = 'ALL';
  bool isLoading = false;
  List<DietPlanDropDown> dietPlanDropDown = [];
  List<DieticianlistModel> dieticianList = [];
  List<DieticianlistModel> filterdieticianList = [];
  String tokenNo = '', loginId = '', empId = '';
  final bottomBarController = Get.put(BottomBarController());
  final ApiController apiController = Get.put(ApiController());
  List<DieticianfilterwardnmModel> wards = [];
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
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  bool isBottomFilterApplied = false;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onClose() {
    searchFocusNode.dispose(); // Dispose FocusNode when controller is closed
    searchController.dispose();
    super.onClose();
  }

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

  // void updateSelectedTab(DieticianfilterwardnmModel shortWardNameLabel) {
  //   selectedTabLabel = shortWardNameLabel.shortWardName.toString();
  //   if (selectedTabLabel.toLowerCase() == 'all') {
  //     selectedWardList = []; // ✅ All selected
  //   } else {
  //     // 🔍 Find actual wardName (String) from shortWardName
  //     String? actualWardName = allTabs
  //         .followedBy(otherTabs)
  //         .firstWhere(
  //           (e) => e.shortWardName?.toLowerCase() == selectedTabLabel.toLowerCase(),
  //           orElse: () => DieticianfilterwardnmModel(wardName: ''),
  //         )
  //         .wardName;
  //     if (actualWardName != null && actualWardName.isNotEmpty) {
  //       selectedWardList = [DieticianfilterwardnmModel(wardName: actualWardName, shortWardName: selectedTabLabel)];
  //     } else {
  //       // fallback
  //       selectedWardList = [shortWardNameLabel];
  //     }
  //   }
  //   callFilterAPi = true;
  //   fetchDieticianList(); // ✅ API call
  //   update(); // ✅ UI update
  // }

  void updateSelectedTab(String shortWardNameLabel) {
    selectedTabLabel = shortWardNameLabel.toString();

    if (shortWardNameLabel.toString().toLowerCase() == 'all') {
      selectedTabLabel = "ALL"; // ✅ All selected
    } else {
      // 🔍 Find actual wardName from shortWardName (from both tab lists)

      selectedTabLabel = shortWardNameLabel.toString(); // fallback (if short==actual)
    }

    callFilterAPi = true; // ✅ so when sheet is dismissed, don't re-fetch again
    fetchDieticianList(isTabFilter: true); // ✅ load patient list
    update(); // 🔁 rebuild the UI
  }

  Future<List<DieticianlistModel>> fetchDieticianList({bool isTabFilter = false, String? searchPrefix}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empDieticianChecklistListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      String? selectedTabWardName = "";

      if (isTabFilter) {
        selectedTabWardName = allTabs
            .followedBy(otherTabs)
            .firstWhere(
              (e) => e.shortWardName?.toLowerCase() == selectedTabLabel.toString().toLowerCase(),
              orElse: () => DieticianfilterwardnmModel(wardName: ''),
            )
            .wardName;
        if (selectedTabWardName.toString().toLowerCase() == "all") {
          selectedWardList = [];
        }
      }

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "prefixText": searchPrefix ?? '',
        "wards": isTabFilter && selectedTabWardName.toString().toLowerCase() != "all" ? [selectedTabWardName] : selectedWardList,
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
        wards = otherTabs;
        // ✅ Select default tab
        selectedTabLabel = allTabs.isNotEmpty ? allTabs.first.shortWardName ?? '' : (otherTabs.isNotEmpty ? otherTabs.first.shortWardName ?? '' : '');

        // ✅ 👇 Important: Call updateSelectedTab here so that list loads based on selected ward
        updateSelectedTab(
          allTabs.isNotEmpty ? allTabs.first.shortWardName.toString() : (otherTabs.isNotEmpty ? otherTabs.first.shortWardName.toString() : ''),
        );

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

  Future<List<DieticianlistModel>> GetDieticianFilterData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empPharmaFilterDataApi;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      DieticianfilterModel dieticianfilterModel = DieticianfilterModel.fromJson(jsonDecode(response));

      if (dieticianfilterModel.statusCode == 200) {
        if (dieticianfilterModel.data != null) {
          // wards = PharmaFilterModel.data!.wards ?? [];
          floors = dieticianfilterModel.data!.floors ?? [];
          beds = dieticianfilterModel.data!.beds ?? [];
        }
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "PharmacyScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    return [];
  }

  Future<void> saveDietEntry(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // isSaveBtnLoading = true;
      update();

      String url = ConstApiUrl.empDietSaveChecklistMasterAPI;
      String loginId = pref.getString(AppString.keyLoginId) ?? "";
      String tokenNo = pref.getString(AppString.keyToken) ?? "";

      /// 🟡 JSON payload banaya gaya with actual values from controllers
      Map<String, dynamic> jsonbodyObj = {
        "id": dieticianList[index].id,
        "diagnosis": diagnosisController.text,
        "diet": {
          "id": 0,
          "name": dietNameController.text,
          "value": "",
          "sort": 0,
          "txt": "",
          "parentId": 0,
          "sup_name": "",
          "dateValue": "2025-07-07T09:49:56.472Z"
        },
        "remark": remarksController.text,
        "relFood_Remark": relativeFoodRemarkController.text,
        "username": dieticianList[index].username,
        "patientName": dieticianList[index].patientName,
        "uhidNo": dieticianList[index].uhidNo,
        "ipdNo": dieticianList[index].ipdNo,
        "bedNo": dieticianList[index].bedNo,
        "wardName": dieticianList[index].wardName,
        "doa": dieticianList[index].doa,
        "doctor": dieticianList[index].doctor,
        "floorNo": dieticianList[index].floorNo.toString(),
        "sysDate": dieticianList[index].sysDate.toString(),
        "dietPlan": null
      };

      /// 🔵 API Call
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSaveDietListMaster responseSaveDietListMaster = ResponseSaveDietListMaster.fromJson(jsonDecode(response));

      /// 🔶 Response Handling
      if (responseSaveDietListMaster.statusCode == 200) {
        if (responseSaveDietListMaster.isSuccess == "true") {
          dieticianList[index].diagnosis = diagnosisController.text;
          dieticianList[index].remark = remarksController.text;
          dieticianList[index].relFoodRemark = relativeFoodRemarkController.text;
          dieticianList[index].dietPlan = dietNameController.text;

          // ✅ If you're showing filtered list, update it too
          filterdieticianList[index].diagnosis = diagnosisController.text;
          filterdieticianList[index].remark = remarksController.text;
          filterdieticianList[index].relFoodRemark = relativeFoodRemarkController.text;
          filterdieticianList[index].dietPlan = dietNameController.text;
          update();
          Get.rawSnackbar(message: "Diet entry saved successfully ✅");
          searchFocusNode.unfocus();
          // resetForm(); or refresh list here
        } else {
          Get.rawSnackbar(message: responseSaveDietListMaster.message ?? "Failed to save");
        }
      } else if (responseSaveDietListMaster.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again');
      } else {
        Get.rawSnackbar(message: responseSaveDietListMaster.message ?? "Something went wrong");
      }
    } catch (e) {
      // isSaveBtnLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "DietSaveScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    // isSaveBtnLoading = false;
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
                      padding: EdgeInsets.only(bottom: getDynamicHeight(size: 0.0078)),
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

  Future<List<DietPlanDropDown>> fetchDietPlanDropDown() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empDietPlanDropDownAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": "Diet Plan"};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDietPlanDropdown responseDietPlanDropdown = ResponseDietPlanDropdown.fromJson(jsonDecode(response));

      if (responseDietPlanDropdown.statusCode == 200) {
        // dietPlanDropDown.clear();
        dietPlanDropDown.assignAll(responseDietPlanDropdown.data ?? []);
        isLoading = false;
      } else if (responseDietPlanDropdown.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseDietPlanDropdown.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "LeaveScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return [];
  }

  Future<void> dietFiltterBottomSheet() async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColor.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.90,
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getDynamicHeight(size: 0.0234)),
            topRight: Radius.circular(getDynamicHeight(size: 0.0234)),
          ),
        ),
        child: GetBuilder<DietchecklistController>(builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.0185)),
            child: Column(
              children: [
                // 🔝 Sticky Header
                Padding(
                  padding: EdgeInsets.only(top: getDynamicHeight(size: 0.0145)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: getDynamicHeight(size: 0.0282)),
                      Text(
                        AppString.filterby,
                        style: TextStyle(
                          fontSize: getDynamicHeight(size: 0.022),
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.cancel),
                      )
                    ],
                  ),
                ),
                // 🧾 Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date Range",
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.018),
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        SizedBox(height: getDynamicHeight(size: 0.0097)),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDatePicker(
                                dateController: fromDateController,
                                hintText: AppString.from,
                                onDateSelected: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    selectedFromDate = picked;
                                    fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                    controller.update();
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: getDynamicHeight(size: 0.0097)),
                            Expanded(
                              child: CustomDatePicker(
                                dateController: toDateController,
                                hintText: AppString.to,
                                onDateSelected: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    selectedToDate = picked;
                                    toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                    controller.update();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getDynamicHeight(size: 0.0235)),
                        Text(AppString.selectWardsName,
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.018),
                              color: AppColor.black,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(height: getDynamicHeight(size: 0.0097)),
                        dietWardsCheckBoxes(controller: controller),
                        // const SizedBox(height: 10),
                        Text(AppString.floor,
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.018),
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 8),
                        dietFloorsCheckBoxes(controller: controller),
                        // const SizedBox(height: 10),
                        Text(AppString.selectbed,
                            style: TextStyle(
                              fontSize: getDynamicHeight(size: 0.018),
                              color: AppColor.black,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(height: getDynamicHeight(size: 0.0079)),
                        dietBedsCheckBoxes(controller: controller),
                        SizedBox(height: getDynamicHeight(size: 0.0079)),
                      ],
                    ),
                  ),
                ),

                // 🔻 Sticky Bottom Buttons
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: getDynamicHeight(size: 0.0475),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.0097)),
                              ),
                              backgroundColor: AppColor.primaryColor,
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              controller.callFilterAPi = true;
                              controller.isBottomFilterApplied = true; // ✅ set when filter is used
                              controller.selectedTabLabel = ''; // ✅ remove tab selection

                              final hasDate = controller.selectedFromDate != null && controller.selectedToDate != null;
                              final hasFilter = controller.selectedWardList.isNotEmpty ||
                                  controller.selectedFloorList.isNotEmpty ||
                                  controller.selectedBedList.isNotEmpty;

                              if (hasDate || hasFilter) {
                                if (hasFilter) {
                                  await controller.fetchDieticianList(isTabFilter: false);
                                }
                                if (hasDate) {
                                  controller.filterByDateRange();
                                }
                                Navigator.pop(context);
                                fromDateController.clear();
                                toDateController.clear();
                              } else {
                                Get.snackbar("Error", "Please select any filter or date to apply.");
                              }
                            },
                            child: Text(
                              AppString.apply,
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: getDynamicHeight(size: 0.017),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: getDynamicHeight(size: 0.019)),
                      Expanded(
                        child: SizedBox(
                          height: getDynamicHeight(size: 0.0475),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.0097)),
                              ),
                              backgroundColor: AppColor.primaryColor,
                            ),
                            onPressed: () async {
                              controller.callFilterAPi = true;
                              FocusScope.of(context).unfocus();
                              controller.selectedWardList = [];
                              controller.selectedFloorList = [];
                              controller.selectedBedList = [];
                              fromDateController.clear();
                              toDateController.clear();
                              await controller.fetchDieticianList();
                              Navigator.pop(context);
                              controller.update();
                            },
                            child: Text(
                              AppString.resetall,
                              style: TextStyle(
                                fontSize: getDynamicHeight(size: 0.018),
                                color: AppColor.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    ).whenComplete(() {
      if (!callFilterAPi) {
        fetchDieticianList();
        selectedWardList = List.from(tempWardList);
        selectedFloorList = List.from(tempFloorsList);
        selectedBedList = List.from(tempBedList);
        update();
      } else {
        callFilterAPi = false;
      }
    });
  }

  void filterByDateRange() {
    final from = DateTime(selectedFromDate!.year, selectedFromDate!.month, selectedFromDate!.day);
    final to = DateTime(selectedToDate!.year, selectedToDate!.month, selectedToDate!.day);

    // ✅ Always filter from All Tab data (entire list)
    final originalList = dieticianList; // Already fetched full data

    filterdieticianList = originalList.where((item) {
      final doaString = item.doa;

      if (doaString == null || doaString.isEmpty) return false;

      final parsedDoa = DateTime.tryParse(doaString);
      if (parsedDoa == null) return false;

      final doa = DateTime(parsedDoa.year, parsedDoa.month, parsedDoa.day);

      return !doa.isBefore(from) && !doa.isAfter(to); // ✅ Exact match bhi include
    }).toList();

    update();
  }

  void showDietDialog(BuildContext context, int index) {
    diagnosisController.text = dieticianList[index].diagnosis ?? '';
    remarksController.text = dieticianList[index].remark ?? '';
    relativeFoodRemarkController.text = dieticianList[index].relFoodRemark ?? '';
    final selectedDiet = dietPlanDropDown.firstWhereOrNull(
      (e) => (e.name?.toLowerCase().trim() ?? '') == (dieticianList[index].dietPlan?.toLowerCase().trim() ?? ''),
    );

    if (selectedDiet != null) {
      dietNameController.text = selectedDiet.name ?? '';
      dietIdController.text = selectedDiet.value ?? '';
    } else {
      dietNameController.clear(); // ⬅️ Clear previous value
      dietIdController.clear(); // ⬅️ Clear previous value
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return FocusScope(
          child: GetBuilder<DietchecklistController>(
            builder: (controller) {
              return AlertDialog(
                backgroundColor: AppColor.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                  getDynamicHeight(size: 0.0097),
                )),
                contentPadding: EdgeInsets.all(
                  getDynamicHeight(size: 0.0097),
                ),
                content: SizedBox(
                  width: getDynamicHeight(size: 0.3465),
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
                                fontSize: getDynamicHeight(size: 0.0155),
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.0135)),

                      /// 🔹 Diagnosis
                      CustomTextFormField(
                        controller: diagnosisController,
                        decoration: InputDecoration(
                          hintText: 'diagnosis',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getDynamicHeight(size: 0.010),
                            vertical: getDynamicHeight(size: 0.012),
                          ),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.0097)),

                      /// 🔹 Diet Dropdown
                      CustomDropdown(
                        text: 'Diet',
                        textStyle: TextStyle(color: AppColor.black1),
                        controller: controller.dietNameController,
                        buttonStyleData: ButtonStyleData(
                          height: getDynamicHeight(size: 0.05),
                          // padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.originalgrey),
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.003)),
                            color: AppColor.white,
                          ),
                        ),
                        onChanged: (value) async {
                          templateDietChangeMethod(value);
                        },
                        items: dietPlanDropDown
                            .map((DietPlanDropDown item) => DropdownMenuItem<Map<String, String>>(
                                  value: {
                                    'value': item.value ?? '',
                                    'text': item.name ?? '',
                                  },
                                  child: Text(
                                    item.name ?? '',
                                    style: AppStyle.black.copyWith(
                                      fontSize: getDynamicHeight(size: 0.016),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        width: double.infinity,
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.0097)),

                      /// 🔹 Remarks
                      CustomTextFormField(
                        controller: remarksController,
                        decoration: InputDecoration(
                          hintText: 'Remark',
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
                          hintText: 'Relative Food Remarks',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getDynamicHeight(size: 0.010),
                            vertical: getDynamicHeight(size: 0.012),
                          ),
                        ),
                        minLines: 2,
                        maxLines: 10,
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.019)),

                      /// 🟩 Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// ✅ Save Button
                          ElevatedButton(
                            onPressed: () {
                              saveDietEntry(index);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              minimumSize: Size(
                                getDynamicHeight(size: 0.098),
                                getDynamicHeight(size: 0.0385),
                              ),
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
                              backgroundColor: AppColor.primaryColor,
                              minimumSize: Size(
                                getDynamicHeight(size: 0.098),
                                getDynamicHeight(size: 0.0385),
                              ),
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
          ),
        );
      },
    );
  }

  templateDietChangeMethod(Map<String, String>? value) async {
    dietIdController.text = value!['value'] ?? '';
    dietNameController.text = value['text'] ?? '';
    update();
  }
}

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/common_methods.dart';
import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/custom_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:emp_app/app/app_custom_widget/common_dropdown_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/leave/screen/widget/custom_textformfield.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/dr_treat_detail.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/dr_treat_master.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/resp_dropdown_multifields_model.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/widget/common_multiselect_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MedicationsheetController extends GetxController {
  final InvestRequisitController investRequisitController = Get.put(InvestRequisitController());
  List<DropdownMultifieldsTable>? searchDropdnMultifieldsData;
  List<String> selectedDropdnOptionId = [];
  List<DropdownMultifieldsTable> selectedDropdownList = [];
  List<DropdownMultifieldsTable> specialDropdownMultifieldsTable = [];
  List<DropdownNamesTable> templatedropdownTable = [];
  List<DropdownNamesTable> medicationSheetDropdownTable = [];
  List<DropdownNamesTable> instructionTypeDropdownTable = [];
  List<DropdownNamesTable> drMedicationRouteDropdownTable = [];
  List<DropdownNamesTable> drMedicationFreqDropdownTable = [];
  final ApiController apiController = Get.put(ApiController());
  String tokenNo = '', loginId = '', empId = '', ipdNo = '', uhid = '', patientname = '';
  int admissionId = 0;
  bool isLoading = false;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController stopDateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  int selectedMasterIndex = -1;
  int selectedDetailIndex = -1;

  String? selectedOrder;
  String? selectedTemplate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TimeOfDay? stopTime;

  final TemplateNameController = TextEditingController();
  final TemplateIdController = TextEditingController();
  final medicationTypeController = TextEditingController();
  final instructionTypeController = TextEditingController();
  final routeController = TextEditingController();
  final FreqMorningController = TextEditingController();
  final FreqAfternoonController = TextEditingController();
  final FreqEveningController = TextEditingController();
  final FreqNightController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<RespDrTreatDetail>? filteredDetails = [];

  List<DrTreatMasterList> drTreatMasterList = [];
  bool fromAdmittedScreen = false;
  bool isTemplateVisible = true;
  final TextEditingController FormularyMedicinesController = TextEditingController();
  final TextEditingController FormularyMedicinesIDController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController nonFormularyMedicinesController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController stopTimeController = TextEditingController();
  final TextEditingController flowRateController = TextEditingController();

  List<SearchserviceModel> suggestions = [];
  List<SearchserviceModel> FormularyMedicines_suggestions = [];
  var searchService = <SearchserviceModel>[].obs;
  String webUserName = '';
  bool isViewBtnclicked = false;
  bool isMenuBtnclicked = false;
  bool isPlusBtnclicked = false;

  @override
  void onInit() {
    super.onInit();
    // Current date ko format karke controller me daalo
    fetchTemplateList();
    fetchSpecialOrderList();
    getMedicationTypeList();
    getInstructionTypeList();
    getDrTreatmentRoute();
    getDrTreatmentFrequency();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(now);
    dateController.text = formattedDate;
  }

  bool isSearchActive = false;

  String getUHId(String patientName) {
    if (patientName.isEmpty) return "";

    List<String> parts = patientName.split('|');
    return parts.last.trim(); // last part with trimmed spaces
  }

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) {
      searchController.clear();
    }
    update(); // important for GetBuilder
  }

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) return;
    List<SearchserviceModel> results = await fetchSearchService(query);

    suggestions = results;
    update();
  }

  Future<void> getFormularyMedicines_Autocomp(String query) async {
    if (query.isEmpty) return;
    List<SearchserviceModel> results = await getFormularyMedicines_AutoComplete(query);

    FormularyMedicines_suggestions = results;
    update();
  }

  Future<List<SearchserviceModel>> getFormularyMedicines_AutoComplete(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String url = ConstApiUrl.empMedicationSheet_SearchMedicinesAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSearchService responseSearchService = ResponseSearchService.fromJson(jsonDecode(response));

      if (responseSearchService.statusCode == 200) {
        // searchService.clear();
        searchService.assignAll(responseSearchService.data ?? []);
      } else if (responseSearchService.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSearchService.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {}

    return searchService.toList();
  }

  Future<List<SearchserviceModel>> fetchSearchService(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String url = ConstApiUrl.empSearchServiceAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSearchService responseSearchService = ResponseSearchService.fromJson(jsonDecode(response));

      if (responseSearchService.statusCode == 200) {
        // searchService.clear();
        searchService.assignAll(responseSearchService.data ?? []);
      } else if (responseSearchService.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSearchService.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {}
    return searchService.toList();
  }

  Future<void> selectOperationName() async {
    showModalBottomSheet(
      elevation: 0,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      context: Get.context!,
      useRootNavigator: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: Get.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          // child: const OperationListView()),
          child: commonDropdownListview<MedicationsheetController>(
            controller: Get.find<MedicationsheetController>(),
            getList: (ctrl) => ctrl.specialDropdownMultifieldsTable,
            getSearchList: (ctrl) => ctrl.searchDropdnMultifieldsData,
            getSelectedIds: (ctrl) => ctrl.selectedDropdnOptionId,
            onToggle: (ctrl, id, item) {
              if (ctrl.selectedDropdnOptionId.contains(id)) {
                ctrl.selectedDropdnOptionId.remove(id);
                ctrl.selectedDropdownList.remove(item);
              } else {
                ctrl.selectedDropdnOptionId.add(id);
                ctrl.selectedDropdownList.add(item);
              }
              ctrl.update();
            },
          ),
        ),
      ),
    );
  }

  searchOperationName(String text) {
    if (text.trim().isEmpty) {
      searchDropdnMultifieldsData = null;
    } else {
      searchDropdnMultifieldsData = [];
      for (var userDetail in specialDropdownMultifieldsTable) {
        if (userDetail.name!.toLowerCase().contains(text.toLowerCase())) {
          searchDropdnMultifieldsData!.add(userDetail);
        }
      }
    }
    update();
  }

  Future<List<DrTreatMasterList>> fetchDrTreatmentData({
    required String ipdNo,
    required String treatTyp,
    required bool isload,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      if (isload) {
        isLoading = true;
        update();
      }
      String url = ConstApiUrl.empDoctorTreatmentMasterAPI;
      String loginId = pref.getString(AppString.keyLoginId) ?? "";
      String empId = pref.getString(AppString.keyEmpId) ?? "";
      String tokenNo = pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "ipdNo": ipdNo, "treatTyp": treatTyp, "userName": webUserName};

      // List<dynamic> responseList = jsonDecode(response);
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RespDrTreatmentMst resp_DrTreatmentMst = RespDrTreatmentMst.fromJson(jsonDecode(response));

      if (resp_DrTreatmentMst.statusCode == 200) {
        if (resp_DrTreatmentMst.data != null && resp_DrTreatmentMst.data!.isNotEmpty) {
          drTreatMasterList = resp_DrTreatmentMst.data!;
          if (selectedMasterIndex < 0) {
            selectedMasterIndex = 0; // Set default index if not set
          }
          filteredDetails = drTreatMasterList[selectedMasterIndex].detail; // by default all
        } else {
          drTreatMasterList = [];
          filteredDetails = [];
        }
      } else if (resp_DrTreatmentMst.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (resp_DrTreatmentMst.statusCode == 400) {
        drTreatMasterList = [];
        filteredDetails = [];
      } else {
        drTreatMasterList = [];
        filteredDetails = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }

    return [];
  }

  void activateSearch(bool value) {
    isSearchActive = value;
    if (!value) {
      searchController.clear();
      filteredDetails = List.from(drTreatMasterList[selectedMasterIndex].detail!); // Reset
    }
    update();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredDetails = List.from(drTreatMasterList[selectedMasterIndex].detail!);
    } else {
      filteredDetails = drTreatMasterList[selectedMasterIndex].detail!.where((item) {
        final name = item.itemName?.txt?.toLowerCase() ?? item.itemNameMnl?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  Future<List<DropdownMultifieldsTable>> fetchSpecialOrderList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empSpecialOrderListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Resp_dropdown_multifields dropdownMuliFieldsData = Resp_dropdown_multifields.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          specialDropdownMultifieldsTable = dropdownMuliFieldsData.data!;
        } else {
          specialDropdownMultifieldsTable = [];
        }
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        specialDropdownMultifieldsTable = [];
      } else {
        specialDropdownMultifieldsTable = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<List<DropdownNamesTable>> fetchTemplateList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empGetTemplatesListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownData.statusCode == 200) {
        if (dropdownData.data != null && dropdownData.data!.isNotEmpty) {
          templatedropdownTable = dropdownData.data!;
        } else {
          templatedropdownTable = [];
        }
      } else if (dropdownData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownData.statusCode == 400) {
        templatedropdownTable = [];
      } else {
        templatedropdownTable = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationSheet",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<List<DropdownNamesTable>> getMedicationTypeList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empGetMedicationTypeAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          medicationSheetDropdownTable = dropdownMuliFieldsData.data!;
        } else {
          medicationSheetDropdownTable = [];
        }
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        medicationSheetDropdownTable = [];
      } else {
        medicationSheetDropdownTable = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }

    return [];
  }

  Future<List<DropdownNamesTable>> getInstructionTypeList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empGetInstructionTypeAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          instructionTypeDropdownTable = dropdownMuliFieldsData.data!;
        } else {
          instructionTypeDropdownTable = [];
        }
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        instructionTypeDropdownTable = [];
      } else {
        instructionTypeDropdownTable = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }

    return [];
  }

  Future<List<DropdownNamesTable>> getDrTreatmentRoute() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();

      String url = ConstApiUrl.empGetDrTreatRouteAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          drMedicationRouteDropdownTable = dropdownMuliFieldsData.data!;
        } else {
          drMedicationRouteDropdownTable = [];
        }
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        drMedicationRouteDropdownTable = [];
      } else {
        drMedicationRouteDropdownTable = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }

    return [];
  }

  Future<List<DropdownNamesTable>> getDrTreatmentFrequency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();

      String url = ConstApiUrl.empGetDrTreatFrequencyAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          drMedicationFreqDropdownTable = dropdownMuliFieldsData.data!;
        } else {
          drMedicationFreqDropdownTable = [];
        }
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        drMedicationFreqDropdownTable = [];
      } else {
        drMedicationFreqDropdownTable = [];
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "MedicationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    } finally {
      isLoading = false;
      update();
    }

    return [];
  }

  Future<int> fetchAdmissionId({
    required String loginId,
    required String tokenNo,
    required String empId,
    required String ipdNo,
  }) async {
    try {
      final url = ConstApiUrl.empGetAdmIdFrmIPDAPI;

      final jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "ipdNo": ipdNo,
      };

      final response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);

      final decoded = jsonDecode(response);

      if (decoded is int) {
        return decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        // If API response format is like: { "data": 3 }
        return decoded['data'] ?? 0;
      } else {
        return 0; // fallback
      }
    } catch (e) {
      print("Error fetching treatment count: $e");
      return 0;
    }
  }

  Future<void> saveMedicationSheet(int selMasterindex) async {
    if (selMasterindex == -2) {
      Get.rawSnackbar(message: 'Something went wrong in Edit Dr Medication Sheet!');
      return;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();

      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";
      admissionId = await fetchAdmissionId(empId: empId, loginId: loginId, tokenNo: tokenNo, ipdNo: ipdNo);
      update();
      String url = ConstApiUrl.empSaveDrTreatmentNoteAPI;
      // Parse date and time
      DateTime? parsedDate;
      try {
        parsedDate = DateFormat('dd-MM-yyyy').parse(dateController.text);
      } catch (e) {
        Get.rawSnackbar(message: 'Invalid date format');
        isLoading = false;
        return;
      }
      // return;
      final dateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      final uuid = Uuid();
      // Construct RespDrTreatMaster object
      final drTreatMaster = DrTreatMasterList(
        drMstId: selMasterindex == -1 ? 0 : selMasterindex,
        admissionId: admissionId,
        date: dateTime.toUtc(),
        srNo: 1,
        specialOrder: selectedDropdnOptionId.join('; '),
        weight: weightController.text.trim(),
        remark: remarksController.text.trim(),
        provisionalDiagnosis: diagnosisController.text.trim(),
        templateName: TemplateNameController.text.trim(),
        prescriptionType: '',
        statusTyp: '',
        userName: webUserName,
        terminalName: '::1',
        consDrId: 0,
        consDrName: '',
        guid: uuid.v4(), // ✅ Valid GUID
        gridName: 'DrTMaster',
        tmplName: TemplateNameController.text.trim(),
        tmplId: 0,
        isValid: true,
        detail: [],
        indoorRecordType: DropdownMultifieldsTable(
          id: 0,
          name: 'MEDICATION SHEET',
          value: null,
          sort: null,
          txt: '',
          parentId: null,
          supName: '',
          dateValue: null,
        ),
        consDr: DropdownMultifieldsTable(
          id: 0,
          name: '',
          value: null,
          sort: null,
          txt: '',
          parentId: null,
          supName: '',
          dateValue: null,
        ),
      );

// 👇👇👇 Proper JSON Body to Send
      var jsonBody = drTreatMaster.toJson(); // ✅ THIS is correct
      var response = await apiController.parseJsonBody(url, "", jsonBody);
      // print("Response: ${response.toString()}");
      // debugPrint("Response: ${response.toString()}");
      RespDrTreatmentMst responseData = RespDrTreatmentMst.fromJson(jsonDecode(response));

      if (responseData.statusCode == 200 && responseData.isSuccess == 'true') {
        Get.rawSnackbar(message: responseData.message ?? 'Data saved successfully');
      } else if (responseData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseData.statusCode == 400) {
        Get.rawSnackbar(message: responseData.message ?? 'Bad request or no data found');
      } else {
        Get.rawSnackbar(message: responseData.message ?? 'Something went wrong');
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: 'MedicationSheet',
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
      Get.rawSnackbar(message: 'Error saving data');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveAddMedication(int selectedMasterIndex, int selectedDetailIndex) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";
      admissionId = await fetchAdmissionId(empId: empId, loginId: loginId, tokenNo: tokenNo, ipdNo: ipdNo);
      update();

      String url = ConstApiUrl.empSaveAddMedicationSheetAPI; // 👈 detail-only API

      final uuid = Uuid();

      final selectedMedicationDetails = RespDrTreatDetail(
        drDtlId: selectedDetailIndex < 0 ? 0 : drTreatMasterList[selectedMasterIndex].detail![selectedDetailIndex].drDtlId,
        drMstId: drTreatMasterList[selectedMasterIndex].drMstId,
        days: int.tryParse(daysController.text.trim().isEmpty ? '0' : daysController.text.trim()) ?? 0,
        itemNameMnl: nonFormularyMedicinesController.text.trim(),
        qty: int.tryParse(qtyController.text.trim().isEmpty ? '0' : qtyController.text.trim()) ?? 0,
        dose: doseController.text.trim(),
        remark: remarksController.text.trim(),
        routeName: normalizeString(routeController.text.trim()),
        medicationName: normalizeString(medicationTypeController.text.trim()),
        itemTxt: normalizeString(FormularyMedicinesController.text),
        item: normalizeString(FormularyMedicinesIDController.text),
        instType: "",
        flowRt: "",
        userName: webUserName,
        terminalName: "::1",
        action: selectedDetailIndex < 0 ? "" : "Edit",
        stopTime: null,
        isValid: true,
        iudId: 0,
        gridName: "DrTDetail",
        freq1: normalizeString(FreqMorningController.text.trim()),
        freq2: normalizeString(FreqAfternoonController.text.trim()),
        freq3: normalizeString(FreqEveningController.text.trim()),
        freq4: normalizeString(FreqNightController.text.trim()),
        itemName: DropdownMultifieldsTable(name: FormularyMedicinesIDController.text.trim(), txt: FormularyMedicinesController.text.trim()),
        medicineType: DropdownMultifieldsTable(name: medicationTypeController.text.trim()),
        // ✅ NotMapped Dropdowns bhi set karo (agar UI me use kar rahe ho)
        frequency1: DropdownMultifieldsTable(name: FreqMorningController.text.trim()),
        frequency2: DropdownMultifieldsTable(name: FreqAfternoonController.text.trim()),
        frequency3: DropdownMultifieldsTable(name: FreqEveningController.text.trim()),
        frequency4: DropdownMultifieldsTable(name: FreqNightController.text.trim()),
        route: DropdownMultifieldsTable(name: routeController.text.trim()),
        instruction_typ: DropdownMultifieldsTable(name: instructionTypeController.text.trim()),
      );

      // Prepare JSON body
      var jsonBody = selectedMedicationDetails.toJson();

      // Send request
      var response = await apiController.parseJsonBody(url, "", jsonBody);

      RespDrDetailWithStatus responseData = RespDrDetailWithStatus.fromJson(jsonDecode(response));

      if (responseData.statusCode == 200) {
        if (responseData.isSuccess == 'true') {
          Get.rawSnackbar(message: responseData.message ?? 'Medication detail saved successfully');
          final updatedDetail = responseData.data!;
          if (drTreatMasterList[selectedMasterIndex].detail != null && drTreatMasterList[selectedMasterIndex].detail!.length > selectedDetailIndex) {
            drTreatMasterList[selectedMasterIndex].detail![selectedDetailIndex] = updatedDetail;
          }
          print(drTreatMasterList[selectedMasterIndex].detail![selectedDetailIndex]);
        } else {
          Get.rawSnackbar(message: responseData.message ?? 'Failed to save medication detail');
        }
      } else if (responseData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again');
      } else if (responseData.statusCode == 400) {
        Get.rawSnackbar(message: responseData.message ?? 'Bad request or no data found');
      } else {
        Get.rawSnackbar(message: responseData.message ?? 'Something went wrong');
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: 'MedicationDetailSave',
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
      Get.rawSnackbar(message: 'Error saving medication detail');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> deleteMedicationSheet({
    required int mstId,
    required int dtlId,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update(); // loading true
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      String url = ConstApiUrl.empDeleteMedicationSheetAPI;

      // 🔥 Prepare delete request body
      final deleteBody = {
        "LoginId": loginId,
        "EmpId": empId,
        "mstId": mstId,
        "dtlId": dtlId,
        "UserName": webUserName,
      };

      // 🔁 Call API
      var response = await apiController.parseJsonBody(url, "", deleteBody);
      var parsed = jsonDecode(response);

      if (parsed['statusCode'] == 200 && parsed['isSuccess'] == 'true') {
        Get.rawSnackbar(message: parsed['Message'] ?? 'Medication deleted successfully');
        // 💡 Tu yaha se local list se bhi delete kar sakta hai
      } else if (parsed['statusCode'] == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired. Please login again');
      } else {
        Get.rawSnackbar(message: parsed['Message'] ?? 'Something went wrong');
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: 'DeleteMedicationSheet',
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
      Get.rawSnackbar(message: 'Error deleting medication');
    } finally {
      isLoading = false;
      update();
    }
  }

  templateChangeMethod(Map<String, String>? value) async {
    TemplateIdController.text = value!['value'] ?? '';
    TemplateNameController.text = value['text'] ?? '';
    update();
  }

  Future<void> clearData() async {
    searchController.clear();
    DateTime now = DateTime.now();
    String formattedDate = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    dateController.text = formattedDate;
    selectedTime = TimeOfDay.now(); // 🕒 Set current time
    remarksController.clear();
    diagnosisController.clear();
    weightController.clear();
    TemplateNameController.clear();
    selectedDropdownList.clear();
    selectedDropdnOptionId.clear();
    fromDateController.clear();
    toDateController.clear();

    update(); // 🔁 Update GetBuilder/UI if needed
  }

  void filterByDateRange() {
    final from = selectedFromDate!;
    final to = selectedToDate!;

    drTreatMasterList = drTreatMasterList.where((item) {
      final date = item.date;
      return date != null && date.isAfter(from.subtract(const Duration(days: 1))) && date.isBefore(to.add(const Duration(days: 1)));
    }).toList();

    update();
  }

  Future<void> editDrTreatmentMasterList(DrTreatMasterList listItem) async {
    try {
      selectedDropdownList.clear();
      selectedDropdnOptionId.clear();
      remarksController.text = "";
      diagnosisController.text = "";
      weightController.text = "";

      DateTime? selectedDateTime;
      selectedDateTime = DateTime.parse(listItem.date.toString());
      if (selectedDateTime != null) {
        // Set Date
        final formattedDate = "${selectedDateTime!.day.toString().padLeft(2, '0')}-${selectedDateTime!.month.toString().padLeft(2, '0')}-${selectedDateTime!.year}";
        dateController.text = formattedDate;

        // Set Time
        selectedTime = TimeOfDay.fromDateTime(selectedDateTime!);

        weightController.text = listItem.weight.toString().trim() == "null" || listItem.weight.toString().isEmpty ? "" : listItem.weight.toString().trim();
        remarksController.text = listItem.remark.toString().trim();
        diagnosisController.text = listItem.provisionalDiagnosis.toString().trim();
        TemplateNameController.text = listItem.templateName.toString().trim();
        isTemplateVisible = false;

        if (listItem.specialOrder == null || listItem.specialOrder.toString().trim().isEmpty) {
          update(); // Refresh UI after clear
          return;
        }

        final splitItems = listItem.specialOrder.toString().split(';');

        for (var raw in splitItems) {
          final trimmed = raw.trim();

          // Search in available dropdown list
          final match = specialDropdownMultifieldsTable.firstWhereOrNull(
            (element) => (element.name ?? '').toLowerCase() == trimmed.toLowerCase(),
          );

          if (match != null) {
            final id = match.value?.toString() ?? '';
            if (!selectedDropdnOptionId.contains(id)) {
              selectedDropdnOptionId.add(id);
              selectedDropdownList.add(match);
            }
          }
        }

        update(); // To refresh the UI
      }
    } catch (e) {
      print("Invalid date format: ${listItem.date.toString()}");
    }
  }

  Future<void> editDrTreatmentDetailList(RespDrTreatDetail listItem) async {
    try {
      stopTimeController.clear();
      flowRateController.clear();

      medicationTypeController.text = normalizeString(listItem.medicineType!.name.toString());
      FormularyMedicinesController.text = normalizeString(listItem.itemName!.txt.toString());
      FormularyMedicinesIDController.text = normalizeString(listItem.itemName!.name.toString());
      nonFormularyMedicinesController.text = normalizeString(listItem.itemNameMnl.toString());
      instructionTypeController.text = normalizeString(listItem.instruction_typ!.name.toString());
      doseController.text = normalizeString(listItem.dose.toString());
      routeController.text = normalizeString(listItem.route!.name.toString());
      remarksController.text = normalizeString(listItem.remark.toString());
      FreqMorningController.text = normalizeString(listItem.frequency1!.name.toString());
      FreqAfternoonController.text = normalizeString(listItem.frequency2!.name.toString());
      FreqEveningController.text = normalizeString(listItem.frequency3!.name.toString());
      FreqNightController.text = normalizeString(listItem.frequency4!.name.toString());
      stopDateController.text = listItem.stopTime != "null" && listItem.stopTime != "" ? formatDateTime_dd_MMM_yy_HH_mm(listItem.stopTime) : '';
      qtyController.text = normalizeString(listItem.qty.toString());
      daysController.text = normalizeString(listItem.days.toString());

      update(); // To refresh the UI
    } catch (e) {
      print("Invalid date format: ${e.toString()}");
    }
  }

  String normalizeString(String? input) {
    if (input == null || input.trim().isEmpty || input.trim().toLowerCase() == 'null') {
      return '';
    }
    return input.trim();
  }

  // Future<void> showDateBottomSheet(BuildContext context) async {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isDismissible: true,
  //     enableDrag: true,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: MediaQuery.of(context).viewInsets,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //             color: Colors.white,
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // 🔹 Title Row with Close Button
  //               Row(
  //                 children: [
  //                   const Spacer(),
  //                   const Text(
  //                     'Select Date',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: const Color.fromARGB(255, 33, 137, 145),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   GestureDetector(
  //                     onTap: () => Navigator.pop(context),
  //                     child: const Icon(Icons.close, size: 20),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),
  //               // 🔹 Date Fields
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: CustomDatePicker(
  //                       dateController: fromDateController,
  //                       hintText: AppString.from,
  //                       onDateSelected: () async {
  //                         final picked = await showDatePicker(
  //                           context: context,
  //                           initialDate: DateTime.now(),
  //                           firstDate: DateTime(2000),
  //                           lastDate: DateTime(2100),
  //                         );
  //                         if (picked != null) {
  //                           selectedFromDate = picked;
  //                           fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
  //                           update();
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                   SizedBox(width: getDynamicHeight(size: 0.01)),
  //                   Expanded(
  //                     child: CustomDatePicker(
  //                       dateController: toDateController,
  //                       hintText: AppString.to,
  //                       onDateSelected: () async {
  //                         final picked = await showDatePicker(
  //                           context: context,
  //                           initialDate: DateTime.now(),
  //                           firstDate: DateTime(2000),
  //                           lastDate: DateTime(2100),
  //                         );
  //                         if (picked != null) {
  //                           selectedToDate = picked;
  //                           toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
  //                           update();
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               // 🔹 Buttons
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color.fromARGB(255, 33, 137, 145),
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //                       ),
  //                       onPressed: () {
  //                         if (selectedFromDate != null && selectedToDate != null) {
  //                           filterByDateRange();
  //                           Navigator.pop(context);
  //                         } else {
  //                           Get.snackbar("Error", "Please select both dates");
  //                         }
  //                       },
  //                       child: const Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color.fromARGB(255, 33, 137, 145),
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //                       ),
  //                       onPressed: () {
  //                         fetchDrTreatmentData(ipdNo: ipdNo, treatTyp: 'Medication Sheet');
  //                         clearData(); // Clear all fields
  //                         Navigator.pop(context); // Just close
  //                       },
  //                       child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  /// Show medication dialog with all fields
  Future<void> showMedicationDialog(BuildContext context, int selMasterindex) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GetBuilder<MedicationsheetController>(builder: (controller) {
          return AlertDialog(
            backgroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
            ),
            contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Close button and name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.nameController.text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.teal,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              clearData();
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                      SizedBox(height: 16),

                      /// Date & Time Row
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePicker(
                              dateController: dateController,
                              style: TextStyle(fontSize: getDynamicHeight(size: 0.014)),
                              hintText: 'Select Date',
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: getDynamicHeight(size: 0.012),
                                  vertical: getDynamicHeight(size: 0.011),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.black1),
                                  borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.black1),
                                  borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.006)),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      final formattedDate =
                                          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                      dateController.text = formattedDate;
                                    }
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                              // onDateSelected: () async {
                              //   final pickedDate = await showDatePicker(
                              //     context: context,
                              //     initialDate: DateTime.now(),
                              //     firstDate: DateTime(2000),
                              //     lastDate: DateTime(2100),
                              //   );
                              //   if (pickedDate != null) {
                              //     final formattedDate =
                              //         "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                              //     dateController.text = formattedDate;
                              //   }
                              // },
                            ),
                          ),
                          SizedBox(width: getDynamicHeight(size: 0.008)),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: controller.selectedTime, // fallback if null
                                );
                                if (time != null) {
                                  controller.selectedTime = time;
                                  controller.update();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getDynamicHeight(size: 0.008),
                                  vertical: getDynamicHeight(size: 0.012),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.black1),
                                  borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.004)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.selectedTime != null ? controller.selectedTime.format(context) : 'Select Time', // 👈 Show this if not selected yet
                                      style: TextStyle(
                                        color: controller.selectedTime != null ? AppColor.black : AppColor.grey,
                                      ),
                                    ),
                                    SizedBox(width: getDynamicHeight(size: 0.008)),
                                    Icon(Icons.timer_outlined),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.012)),

                      /// Special Order Dropdown & Weight
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                searchDropdnMultifieldsData = null;
                                selectOperationName();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.005)),
                                  color: AppColor.white,
                                  border: Border.all(
                                    width: 1,
                                    color: AppColor.black1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.crossLength * 0.010,
                                    vertical: Sizes.crossLength * 0.015,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: selectedDropdownList.isEmpty
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: AppText(
                                                      text: 'Select order',
                                                      fontColor: ConstColor.hintTextColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Wrap(
                                                runSpacing: getDynamicHeight(size: 0.004),
                                                spacing: getDynamicHeight(size: 0.006),
                                                children: [
                                                  for (int i = 0; i < selectedDropdownList.length; i++)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1, color: ConstColor.hintTextColor),
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: AppColor.white,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 7, right: 5, top: 5, bottom: 5),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Flexible(
                                                              child: AppText(
                                                                text: selectedDropdownList[i].name ?? '',
                                                                maxLine: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(context).unfocus();
                                                                selectedDropdnOptionId.remove(selectedDropdownList[i].value.toString());
                                                                selectedDropdownList.remove(selectedDropdownList[i]);
                                                                update();
                                                              },
                                                              child: Icon(
                                                                Icons.cancel_outlined,
                                                                size: getDynamicHeight(size: 0.016),
                                                                color: ConstColor.errorBorderColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: getDynamicHeight(size: 0.008)),
                          Container(
                            width: getDynamicHeight(size: 0.09),
                            child: CustomTextFormField(
                              controller: weightController,
                              decoration: InputDecoration(
                                hintText: "Weight",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: getDynamicHeight(size: 0.010),
                                  vertical: getDynamicHeight(size: 0.012),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.012)),

                      /// Remarks Field
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

                      /// Diagnosis Field
                      CustomTextFormField(
                        controller: diagnosisController,
                        decoration: InputDecoration(
                          hintText: "Enter Provisional Diagnosis",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getDynamicHeight(size: 0.010),
                            vertical: getDynamicHeight(size: 0.012),
                          ),
                        ),
                        minLines: 2,
                        maxLines: 10,
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.012)),

                      /// Template Dropdown
                      Visibility(
                        visible: isTemplateVisible,
                        child: CustomDropdown(
                          text: AppString.name,
                          textStyle: TextStyle(color: AppColor.black1),
                          controller: controller.TemplateNameController,
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
                            await controller.templateChangeMethod(value);
                          },
                          items: controller.templatedropdownTable
                              .map((DropdownNamesTable item) => DropdownMenuItem<Map<String, String>>(
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
                      ),
                      // DropdownButtonFormField<String>(
                      //   decoration: InputDecoration(
                      //     hintText: "Template Name",
                      //     border: OutlineInputBorder(),
                      //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      //   ),
                      //   items: ["Template A", "Template B"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      //   onChanged: (val) => selectedTemplate = val,
                      // ),
                      SizedBox(height: getDynamicHeight(size: 0.02)),

                      /// Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.teal,
                            padding: EdgeInsets.symmetric(vertical: getDynamicHeight(size: 0.014)),
                          ),
                          onPressed: () async {
                            // Submit logic
                            await saveMedicationSheet(selMasterindex > 0 ? (controller.drTreatMasterList[selMasterindex].drMstId ?? -2) : -1);
                            await fetchDrTreatmentData(ipdNo: ipdNo, treatTyp: 'Medication Sheet', isload: true);
                            clearData();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: getDynamicHeight(size: 0.016), color: AppColor.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  Future<void> medicationbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: Get.context!,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.0,
          maxChildSize: 0.95,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.white,
              ),
              child:
                  //  controller.otentryList.isNotEmpty
                  //     ?
                  SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(height: getDynamicHeight(size: 0.007)),
                    Row(
                      children: [
                        SizedBox(width: getDynamicHeight(size: 0.02)), // ~30 dynamically
                        const Spacer(),
                        Container(
                          width: getDynamicHeight(size: 0.06), // ~90 dynamically
                          child: Divider(
                            height: getDynamicHeight(size: 0.025), // ~20 dynamically
                            color: AppColor.originalgrey,
                            thickness: getDynamicHeight(size: 0.0065), // ~5 dynamically
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: getDynamicHeight(size: 0.025), // Icon size dynamic
                          ),
                        ),
                        SizedBox(width: getDynamicHeight(size: 0.02)), // ~30 dynamically
                      ],
                    ),
                    SizedBox(height: getDynamicHeight(size: 0.007)), // was SizedBox(height: 10)
                    _buildNoteSection(AppString.indoorrecordtype, drTreatMasterList[index].irt ?? ''),
                    _buildNoteSection(AppString.entrydatetime, drTreatMasterList[index].sysDate.toString()),
                    _buildNoteSection(AppString.specialorder, drTreatMasterList[index].specialOrder ?? ''),
                    _buildNoteSection(AppString.templatename, drTreatMasterList[index].tmplName ?? ''),
                    _buildNoteSection(AppString.provisionaldiagnosis, drTreatMasterList[index].provisionalDiagnosis ?? ''),
                    _buildNoteSection(AppString.weight, drTreatMasterList[index].weight ?? ''),
                    _buildNoteSection(AppString.remark, drTreatMasterList[index].remark ?? ''),
                    Container(
                      height: getDynamicHeight(size: 0.09), // was MediaQuery height * 0.12
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 Heading Row (RxID, ID)
                          Container(
                            height: getDynamicHeight(size: 0.045),
                            padding: EdgeInsets.all(getDynamicHeight(size: 0.01)),
                            decoration: BoxDecoration(color: AppColor.primaryColor),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.02)),
                                    width: getDynamicHeight(size: 0.3),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppString.rxid,
                                      style: AppStyle.w50018.copyWith(color: AppColor.white),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: getDynamicHeight(size: 0.4),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppString.id,
                                      style: AppStyle.w50018.copyWith(color: AppColor.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// 🔹 Value Row (RxID value, ID value)
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: getDynamicHeight(size: 0.3),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.05), vertical: getDynamicHeight(size: 0.01)),
                                  child: Text(
                                    drTreatMasterList[index].srNo.toString(), // ✅ RxID value
                                    style: AppStyle.fontfamilyplus,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: getDynamicHeight(size: 0.4),
                                  alignment: Alignment.center,
                                  child: Text(
                                    drTreatMasterList[index].admissionId.toString(), // ✅ ID value
                                    style: AppStyle.fontfamilyplus,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildNoteSection(AppString.user, drTreatMasterList[index].userName ?? ''),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void sortTreatmentByDate({required bool isAscending}) {
    drTreatMasterList.sort((a, b) {
      final dateA = a.date ?? DateTime(1900);
      final dateB = b.date ?? DateTime(1900);
      return isAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    update();
  }

  // Future<void> sortByBottomSheet() async {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(25),
  //             topRight: Radius.circular(25),
  //           ),
  //         ),
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             /// 🔹 Title Row
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const SizedBox(width: 24),
  //                 const Text(
  //                   "Sort By",
  //                   style: TextStyle(
  //                     color: Color(0xFF169AAA),
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () => Navigator.pop(context),
  //                   child: const Icon(Icons.cancel, color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 25),
  //             /// 🔸 Option 1 - Oldest to Newest
  //             InkWell(
  //               onTap: () {
  //                 sortTreatmentByDate(isAscending: true);
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 width: double.infinity,
  //                 padding: const EdgeInsets.symmetric(vertical: 14),
  //                 decoration: const BoxDecoration(
  //                   border: Border(
  //                     bottom: BorderSide(color: Colors.black26, width: 1),
  //                   ),
  //                 ),
  //                 child: const Text("Date [Oldest to Newest]"),
  //               ),
  //             ),
  //             /// 🔸 Option 2 - Newest to Oldest
  //             InkWell(
  //               onTap: () {
  //                 sortTreatmentByDate(isAscending: false);
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 width: double.infinity,
  //                 padding: const EdgeInsets.symmetric(vertical: 14),
  //                 decoration: const BoxDecoration(
  //                   border: Border(
  //                     bottom: BorderSide(color: Colors.black26, width: 1),
  //                   ),
  //                 ),
  //                 child: const Text("Date [Newest to Oldest]"),
  //               ),
  //             ),
  //             const SizedBox(height: 25),
  //             /// 🔘 Reset Button Center
  //             Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                 width: 130,
  //                 height: 44,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFF169AAA),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: TextButton(
  //                   onPressed: () {
  //                     fetchDrTreatmentData(ipdNo: ipdNo, treatTyp: 'Medication Sheet');
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text(
  //                     "Reset",
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  Future<void> showSortFilterBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 Header Row
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      "Sort and Filters",
                      style: TextStyle(
                        color: Color(0xFF169AAA),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// 🔸 Sort By Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sort By",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    sortTreatmentByDate(isAscending: true);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_upward_rounded, color: Color(0xFF169AAA)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Date [Oldest to Newest]",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

// 🔸 Sort Option 2
                InkWell(
                  onTap: () {
                    sortTreatmentByDate(isAscending: false);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_downward_rounded, color: Color(0xFF169AAA)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Date [Newest to Oldest]",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔸 Date Filter Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Filter by Date",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                            update();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
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
                            update();
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// 🔘 Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedFromDate != null && selectedToDate != null) {
                            filterByDateRange();
                            Navigator.pop(context);
                          } else {
                            Get.snackbar("Error", "Please select both dates");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF169AAA),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Apply Filter", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          fetchDrTreatmentData(ipdNo: ipdNo, treatTyp: 'Medication Sheet', isload: true);
                          clearData();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF169AAA),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Reset", style: TextStyle(color: Colors.white)),
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

  Future<void> viewbottomsheet(BuildContext context, int selectedMasterIndex, int detailMedicineindex) async {
    showModalBottomSheet(
        backgroundColor: AppColor.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: Get.context!,
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.0,
            maxChildSize: 0.95,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.90,
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColor.white,
                ),
                child:
                    //  controller.otentryList.isNotEmpty
                    //     ?
                    SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: getDynamicHeight(size: 0.007)),
                      Row(
                        children: [
                          SizedBox(width: getDynamicHeight(size: 0.02)), // ~30 dynamically
                          const Spacer(),
                          Container(
                            width: getDynamicHeight(size: 0.06), // ~90 dynamically
                            child: Divider(
                              height: getDynamicHeight(size: 0.025), // ~20 dynamically
                              color: AppColor.originalgrey,
                              thickness: getDynamicHeight(size: 0.0065), // ~5 dynamically
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: getDynamicHeight(size: 0.025), // Icon size dynamic
                            ),
                          ),
                          SizedBox(width: getDynamicHeight(size: 0.02)), // ~30 dynamically
                        ],
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.007)), // was SizedBox(height: 10)
                      _buildNoteSection(AppString.medicationtype, drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].medicineType!.name ?? ''),
                      _buildNoteSection(AppString.instructiontype, drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].instType ?? ''),
                      Container(
                        height: getDynamicHeight(size: 0.09), // was MediaQuery height * 0.12
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: getDynamicHeight(size: 0.045),
                              padding: EdgeInsets.all(getDynamicHeight(size: 0.01)), // was EdgeInsets.all(10)
                              decoration: BoxDecoration(color: AppColor.primaryColor),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.02)),
                                      width: getDynamicHeight(size: 0.3), // was height * 0.4
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppString.dose,
                                        style: AppStyle.w50018.copyWith(
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: getDynamicHeight(size: 0.4), // was height * 0.4
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppString.route,
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
                                      ), // was EdgeInsets.symmetric(horizontal: 50, vertical: 10)
                                      width: getDynamicHeight(size: 0.3), // was height * 0.5
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].dose ?? '',
                                        style: AppStyle.fontfamilyplus,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      width: getDynamicHeight(size: 0.5), // was height * 0.5
                                      alignment: Alignment.center,
                                      child: Text(
                                        drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].routeName ?? '',
                                        style: AppStyle.fontfamilyplus,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getDynamicHeight(size: 0.09), // was MediaQuery height * 0.12
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: getDynamicHeight(size: 0.047),
                              padding: EdgeInsets.all(getDynamicHeight(size: 0.01)), // was EdgeInsets.all(10)
                              decoration: BoxDecoration(color: AppColor.primaryColor),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.02)),
                                      width: getDynamicHeight(size: 0.3), // was height * 0.4
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppString.days,
                                        style: AppStyle.w50018.copyWith(
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: getDynamicHeight(size: 0.4), // was height * 0.4
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppString.quantity1,
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
                                      ), // was EdgeInsets.symmetric(horizontal: 50, vertical: 10)
                                      width: getDynamicHeight(size: 0.3), // was height * 0.5
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].days.toString(),
                                        style: AppStyle.fontfamilyplus,
                                      )),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                      width: getDynamicHeight(size: 0.5), // was height * 0.5
                                      alignment: Alignment.center,
                                      child: Text(
                                        drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].qty.toString(),
                                        style: AppStyle.fontfamilyplus,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildNoteSection(AppString.stoptime, drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].stopTime.toString()),
                      _buildNoteSection(AppString.user, drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].userName ?? ''),
                      _buildNoteSection(AppString.entrydatetime, drTreatMasterList[selectedMasterIndex].detail![detailMedicineindex].sysDate.toString()),
                    ],
                  ),
                ),
              );
            }));
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
}

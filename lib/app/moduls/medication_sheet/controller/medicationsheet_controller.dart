import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  int selectedMasterIndex = -1;
  int selectedDetailIndex = -1;

  String? selectedOrder;
  String? selectedTemplate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
  List<RespDrTreatDetail>? allDetails = [];
  List<RespDrTreatDetail>? filteredDetails = [];

  List<DrTreatMasterList> drTreatMasterList = [];
  bool fromAdmittedScreen = false;
  final TextEditingController FormularyMedicinesController = TextEditingController();
  List<SearchserviceModel> suggestions = [];
  List<SearchserviceModel> FormularyMedicines_suggestions = [];
  var searchService = <SearchserviceModel>[].obs;

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
      isLoading = true;
      String url = ConstApiUrl.empMedicationSheet_SearchMedicinesAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSearchService responseSearchService = ResponseSearchService.fromJson(jsonDecode(response));

      if (responseSearchService.statusCode == 200) {
        // searchService.clear();
        searchService.assignAll(responseSearchService.data ?? []);
        isLoading = false;
      } else if (responseSearchService.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSearchService.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
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
    }
    isLoading = false;
    return searchService.toList();
  }

  Future<List<SearchserviceModel>> fetchSearchService(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empSearchServiceAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSearchService responseSearchService = ResponseSearchService.fromJson(jsonDecode(response));

      if (responseSearchService.statusCode == 200) {
        // searchService.clear();
        searchService.assignAll(responseSearchService.data ?? []);
        isLoading = false;
      } else if (responseSearchService.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSearchService.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
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
    }
    isLoading = false;
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
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empDoctorTreatmentMasterAPI;
      String loginId = pref.getString(AppString.keyLoginId) ?? "";
      String empId = pref.getString(AppString.keyEmpId) ?? "";
      String tokenNo = pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "ipdNo": ipdNo, "treatTyp": treatTyp, "userName": 'Harshil'};

      // List<dynamic> responseList = jsonDecode(response);
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RespDrTreatmentMst resp_DrTreatmentMst = RespDrTreatmentMst.fromJson(jsonDecode(response));

      if (resp_DrTreatmentMst.statusCode == 200) {
        if (resp_DrTreatmentMst.data != null && resp_DrTreatmentMst.data!.isNotEmpty) {
          drTreatMasterList = resp_DrTreatmentMst.data!;
          if (drTreatMasterList.isNotEmpty) {
            if (selectedMasterIndex >= 0) {
              allDetails = drTreatMasterList[selectedMasterIndex].detail ?? [];
              filteredDetails = List.from(allDetails!); // by default all
            }
          }
        } else {}
        update();
      } else if (resp_DrTreatmentMst.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (resp_DrTreatmentMst.statusCode == 400) {
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

  void activateSearch(bool value) {
    isSearchActive = value;
    if (!value) {
      searchController.clear();
      filteredDetails = List.from(allDetails!); // Reset
    }
    update();
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredDetails = List.from(allDetails!);
    } else {
      filteredDetails = allDetails!.where((item) {
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
      String url = ConstApiUrl.empSpecialOrderListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Resp_dropdown_multifields dropdownMuliFieldsData = Resp_dropdown_multifields.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          specialDropdownMultifieldsTable = dropdownMuliFieldsData.data!;
        } else {}
        update();
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
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
        } else {}
        update();
      } else if (dropdownData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
      }
      update();
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
    }
    isLoading = false;
    return [];
  }

  Future<List<DropdownNamesTable>> getMedicationTypeList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empGetMedicationTypeAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          medicationSheetDropdownTable = dropdownMuliFieldsData.data!;
        } else {}
        update();
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
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

  Future<List<DropdownNamesTable>> getInstructionTypeList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empGetInstructionTypeAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          instructionTypeDropdownTable = dropdownMuliFieldsData.data!;
        } else {}
        update();
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
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

  Future<List<DropdownNamesTable>> getDrTreatmentRoute() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empGetDrTreatRouteAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          drMedicationRouteDropdownTable = dropdownMuliFieldsData.data!;
        } else {}
        update();
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
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

  Future<List<DropdownNamesTable>> getDrTreatmentFrequency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empGetDrTreatFrequencyAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownNames dropdownMuliFieldsData = ResponseDropdownNames.fromJson(jsonDecode(response));

      if (dropdownMuliFieldsData.statusCode == 200) {
        if (dropdownMuliFieldsData.data != null && dropdownMuliFieldsData.data!.isNotEmpty) {
          drMedicationFreqDropdownTable = dropdownMuliFieldsData.data!;
        } else {}
        update();
      } else if (dropdownMuliFieldsData.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (dropdownMuliFieldsData.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
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

  Future<void> saveMedicationSheet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
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
        drMstId: 0,
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
        userName: 'Harshil',
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
        update();
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

    nameController.text = '';
    ipdNo = '';
    uhid = '';
    fromAdmittedScreen = false;

    update(); // 🔁 Update GetBuilder/UI if needed
  }

  Future<void> showDateBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Title Row with Close Button
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 33, 137, 145),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 Date Fields
                Row(
                  children: [
                    Expanded(
                      child: CustomDatePicker(
                        dateController: TextEditingController(),
                        hintText: AppString.from,
                        // onDateSelected: () async => await controller.selectFromDate(context),
                      ),
                    ),
                    SizedBox(width: getDynamicHeight(size: 0.01)),
                    Expanded(
                      child: CustomDatePicker(
                        dateController: TextEditingController(),
                        hintText: AppString.to,
                        // onDateSelected: () async => await controller.selectToDate(context),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 33, 137, 145),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () {
                          // TODO: Confirm logic
                        },
                        child: const Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 33, 137, 145),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Just close
                        },
                        child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show medication dialog with all fields
  Future<void> showMedicationDialog(BuildContext context) async {
    await showDialog(
      context: context,
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
                            onTap: () => Navigator.pop(context),
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
                                initialTime: selectedTime,
                              );
                              if (time != null) {
                                setState(() => selectedTime = time);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: getDynamicHeight(size: 0.012),
                                horizontal: getDynamicHeight(size: 0.010),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.black1),
                                borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.005)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedTime.format(context)),
                                  SizedBox(width: getDynamicHeight(size: 0.008)),
                                  Icon(Icons.timer_outlined),
                                ],
                              ),
                            ),
                          ))
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
                            child: TextFormField(
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
                      TextFormField(
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
                      TextFormField(
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
                      CustomDropdown(
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
                            await saveMedicationSheet();
                            await fetchDrTreatmentData(ipdNo: ipdNo, treatTyp: 'Medication Sheet');
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
                                  padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.05)),
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

  Future<void> sortByBottomSheet() async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔹 Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  const Text(
                    "Sort By",
                    style: TextStyle(
                      color: Color(0xFF169AAA),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// 🔸 Option 1 - Oldest to Newest
              InkWell(
                onTap: () {
                  // Your logic
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black26, width: 1),
                    ),
                  ),
                  child: const Text("Date [Oldest to Newest]"),
                ),
              ),

              /// 🔸 Option 2 - Newest to Oldest
              InkWell(
                onTap: () {
                  // Your logic
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black26, width: 1),
                    ),
                  ),
                  child: const Text("Date [Newest to Oldest]"),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔘 Reset Button Center
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 130,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF169AAA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                                      padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.05)),
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
                                      padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.05)),
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
            height: getDynamicHeight(size: 0.045),
            color: AppColor.primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.02)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: AppStyle.w50018.copyWith(color: Colors.white),
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
              padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(size: 0.01)),
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

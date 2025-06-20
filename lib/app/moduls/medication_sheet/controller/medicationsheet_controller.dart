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
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/dr_treat_master.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/resp_dropdown_multifields_model.dart';
import 'package:emp_app/app/moduls/medication_sheet/screen/widget/common_multiselect_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationsheetController extends GetxController {
  final InvestRequisitController investRequisitController = Get.put(InvestRequisitController());
  List<DropdownMultifieldsTable>? searchDropdnMultifieldsData;
  List<String> selectedDropdnOptionId = [];
  List<DropdownMultifieldsTable> selectedDropdownList = [];
  List<DropdownMultifieldsTable> dropdownMultifieldsTable = [];
  List<DropdownNamesTable> templatedropdownTable = [];
  final ApiController apiController = Get.put(ApiController());
  String tokenNo = '', loginId = '', empId = '', ipdNo = '', uhid = '', patientname = '';
  int admissionId = 0;
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  String? selectedOrder;
  String? selectedTemplate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TemplateNameController = TextEditingController();
  final TemplateIdController = TextEditingController();

  List<DrTreatMasterList> drTreatMasterList = [];

  @override
  void onInit() {
    super.onInit();
    // Current date ko format karke controller me daalo
    fetchTemplateList();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(now);
    dateController.text = formattedDate;
  }

  bool isSearchActive = false;

  void activateSearch(bool status) {
    isSearchActive = status;
    update(); // Call this inside GetX Controller
  }

  void clearSearch() {
    searchController.clear();
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
            getList: (ctrl) => ctrl.dropdownMultifieldsTable,
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
      for (var userDetail in dropdownMultifieldsTable) {
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
        } else {}
        update();
      } else if (resp_DrTreatmentMst.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (resp_DrTreatmentMst.statusCode == 400) {
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
          dropdownMultifieldsTable = dropdownMuliFieldsData.data!;
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

      // Construct RespDrTreatMaster object
      // Sample data creation (yeh actual user input se aayega)
      final drTreatMaster = DrTreatMasterList(
        drMstId: 0, // Example only, dynamically load this
        admissionId: admissionId, // Example only, dynamically lo
        date: dateTime,
        srNo: 1,
        specialOrder: selectedDropdnOptionId.join('; '),
        weight: weightController.text.trim(),
        remark: remarksController.text.trim(),
        provisionalDiagnosis: diagnosisController.text.trim(),
        templateName: TemplateNameController.text.trim(),
        prescriptionType: null, // Sample value
        statusTyp: null, // Sample value
        userName: 'Harshil',
        terminalName: '::1',
        consDrId: null, // Sample Doctor Id
        consDrName: null,
        guid: '12345-67890', // Sample GUID
        gridName: 'DrTMaster',
        tmplName: TemplateNameController.text.trim(),
        tmplId: int.tryParse(TemplateIdController.text.trim()),
        isValid: true,
        detail: [], // Aapke entered medication detail list yahaan jayege
      );

      var jsonBody = {
        'loginId': loginId,
        'empId': empId,
        'drTreatmentMaster': drTreatMaster.toJson(),
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonBody);
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

  Future<void> showDateBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
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
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(16),
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
                              "KISHOR PRABHUBHAI DARJI ( A/1469/25 )",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.black1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.black1),
                                  borderRadius: BorderRadius.circular(3),
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
                          SizedBox(width: 8),
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
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.black1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedTime.format(context)),
                                  SizedBox(width: 8),
                                  Icon(Icons.timer_outlined),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 12),

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
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white,
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
                                                runSpacing: 5,
                                                spacing: 8,
                                                children: [
                                                  for (int i = 0; i < selectedDropdownList.length; i++)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 1, color: ConstColor.hintTextColor),
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.white,
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
                                                              child: const Icon(
                                                                Icons.cancel_outlined,
                                                                size: 20,
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
                          SizedBox(width: 8),
                          Container(
                            width: 100,
                            child: TextFormField(
                              controller: weightController,
                              decoration: InputDecoration(
                                hintText: "Weight",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      /// Remarks Field
                      TextFormField(
                        controller: remarksController,
                        decoration: InputDecoration(
                          hintText: "Remarks",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        ),
                        minLines: 1,
                        maxLines: 10,
                      ),
                      SizedBox(height: 12),

                      /// Diagnosis Field
                      TextFormField(
                        controller: diagnosisController,
                        decoration: InputDecoration(
                          hintText: "Enter Provisional Diagnosis",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        ),
                        minLines: 2,
                        maxLines: 10,
                      ),
                      SizedBox(height: 12),

                      /// Template Dropdown
                      CustomDropdown(
                        text: AppString.name,
                        controller: controller.TemplateNameController,
                        buttonStyleData: ButtonStyleData(
                          height: getDynamicHeight(size: 0.05),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black),
                            borderRadius: BorderRadius.circular(0),
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
                                      // fontSize: 14,
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
                      SizedBox(height: 20),

                      /// Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            // Submit logic
                            await saveMedicationSheet();
                            // Navigator.pop(context);
                          },
                          child: Text("Save", style: TextStyle(fontSize: 16)),
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
                    _buildNoteSection(AppString.indoorrecordtype, ''),
                    _buildNoteSection(AppString.entrydatetime, ''),
                    _buildNoteSection(AppString.specialorder, ''),
                    _buildNoteSection(AppString.templatename, ''),
                    _buildNoteSection(AppString.provisionaldiagnosis, ''),
                    _buildNoteSection(AppString.weight, ''),
                    _buildNoteSection(AppString.remark, ''),
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
                                      AppString.rxid,
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
                                      AppString.id,
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
                                    width: getDynamicHeight(size: 0.5), // was height * 0.5
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
                                      style: AppStyle.fontfamilyplus,
                                    )),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    width: getDynamicHeight(size: 0.5), // was height * 0.5
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
                                      style: AppStyle.fontfamilyplus,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildNoteSection(AppString.user, ''),
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

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> viewbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: Get.context!,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.75  ,
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
                    _buildNoteSection(AppString.medicationtype, ''),
                    _buildNoteSection(AppString.instructiontype, ''),
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
                                    width: getDynamicHeight(size: 0.5), // was height * 0.5
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
                                      style: AppStyle.fontfamilyplus,
                                    )),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    width: getDynamicHeight(size: 0.5), // was height * 0.5
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
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
                                    width: getDynamicHeight(size: 0.5), // was height * 0.5
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
                                      style: AppStyle.fontfamilyplus,
                                    )),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                    width: getDynamicHeight(size: 0.5), // was height * 0.5
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
                                      style: AppStyle.fontfamilyplus,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildNoteSection(AppString.stoptime, ''),
                    _buildNoteSection(AppString.user, ''),
                    _buildNoteSection(AppString.entrydatetime, ''),
                  ],
                ),
              ),
            );
          }),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: content.isNotEmpty ? AppStyle.fontfamilyplus : AppStyle.plus16w600,
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

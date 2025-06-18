// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/model/dropdownlist_custom.dart';
import 'package:emp_app/app/moduls/leave/model/headerlist_model.dart';
import 'package:emp_app/app/moduls/leave/model/leaveReliverName_model.dart';
import 'package:emp_app/app/moduls/leave/model/leave_saveentrylist_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedays_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavedelayreason_model.dart';
import 'package:emp_app/app/moduls/leave/model/leaveentrylist_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavenames_model.dart';
import 'package:emp_app/app/moduls/leave/model/leavereason_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveController extends GetxController with SingleGetTickerProviderMixin {
  final bottomBarController = Get.put(BottomBarController());
  final ApiController apiController = Get.put(ApiController());
  List<LeaveNamesTable> leavename = [];
  List<LeaveEntryList> leaveentryList = [];
  List<HeaderList> leaveHeaderList = [];
  List<SaveLeaveEntryList> saveleaveentrylist = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  bool isSaveBtnLoading = false;
  var leftleavedays = ''.obs;
  var dropdownItems123 = <DropdownlstTable>[].obs;
  var leavereason = <LeaveReasonTable>[].obs;
  var leavedelayreason = <LeaveDelayReason>[].obs;
  var leaverelivername = <LeaveReliverName>[].obs;
  RxString days = ''.obs; // To store the calculated days
  RxBool isDaysFieldEnabled = false.obs;
  final overtimeController = Get.put(OvertimeController());
  var inchargeAction = ''.obs;
  var hodAction = ''.obs;
  var hrAction = ''.obs;
  List<Map<String, String>> daysOptions = [];
  final ScrollController leaveScrollController = ScrollController();
  final FocusNode notesFocusNode = FocusNode();

  var initialIndex = 0.obs;
  late final TabController tabController_Leave;
  RxInt currentTabIndex = 0.obs;
  int? selectedRowIndex; // Track the selected row index

  TextEditingController leftLeaveDaysController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController leaveNameController = TextEditingController();
  TextEditingController leaveValueController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController hdleaveperiodController = TextEditingController();
  TextEditingController relieverNameController = TextEditingController();
  TextEditingController relieverValueController = TextEditingController();
  TextEditingController delayreasonNameController = TextEditingController();
  TextEditingController delayreasonIdController = TextEditingController();
  RxBool isNotesFieldFocused = false.obs;

  @override
  void onInit() async {
    tabController_Leave = TabController(length: 2, vsync: this);
    super.onInit();
    tabController_Leave.addListener(_handleTabSelection);
    currentTabIndex.value = 0;
    changeTab(0);
    noteController.text = "";
    await fetchLeaveNames();
    await fetchLeaveReason();
    await fetchLeaveReliverName();
    await fetchLeaveDelayReason();

    fromDateController.addListener(updateLeaveDays);
    toDateController.addListener(updateLeaveDays);
    notesFocusNode.addListener(_onNotesFocusChange);
    // isLoading = false;
    update();
    // Scroll hone par bottom navigation bar ko hide/show karna
    leaveScrollController.addListener(() {
      if (leaveScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (hideBottomBar.value) {
          hideBottomBar.value = false;
          bottomBarController.update();
        }
      } else if (leaveScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!hideBottomBar.value) {
          hideBottomBar.value = true;
          bottomBarController.update();
        }
      }
    });
  }

  void _onNotesFocusChange() {
    // Notes field ka focus change hone par UI update karna
    if (!notesFocusNode.hasFocus) {
      isNotesFieldFocused.value = notesFocusNode.hasFocus;
      update();
    }
  }

  @override
  void onClose() {
    // tabController_Leave.dispose();
    super.onClose();
  }

  // Bottom bar ko hide karne ka function
  void hideBottomNavBar() {
    hideBottomBar.value = true;
  }

  // Bottom bar ko show karne ka function
  void showBottomNavBar() {
    hideBottomBar.value = false;
  }

  // Tab change hone par perform hone wale actions
  void _handleTabSelection() async {
    if (tabController_Leave.indexIsChanging) {
      initialIndex.value = tabController_Leave.index;
      if (tabController_Leave.index == 1) {
        inchargeAction.value = "";
        hodAction.value = "";
        hrAction.value = "";
        selectedRowIndex = -1;
        await fetchLeaveEntryList("LV");
      }
      update();
    }
  }

  // Tab change karne ka function
  changeTab(int index) async {
    tabController_Leave.animateTo(index);
    currentTabIndex.value = index;
    // Agar Leave History tab pe jaa rahe hain aur data empty hai to fetch karo
    if (index == 1 && leaveentryList.isEmpty) {
      inchargeAction.value = "";
      hodAction.value = "";
      hrAction.value = "";
      selectedRowIndex = -1;
      await fetchLeaveEntryList("LV"); // Fetch list only if not already fetched
    }
    update();
  }

  // Leave days calculate karna based on selected from and to date
  updateLeaveDays() async {
    final String formDateText = fromDateController.text;
    final String toDateText = toDateController.text;

    DateTime? fromDate = formDateText.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(formDateText, true) : null;
    DateTime? toDate = toDateText.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(toDateText, true) : null;

    List<Map<String, String>> daysOptions;
    bool daysMoreThanOne = false;
    String tempDaysCount = "";

    if (fromDate != null && toDate != null) {
      int daysCount = toDate.difference(fromDate).inDays + 1;

      if (daysCount <= 1) {
        daysOptions = [
          {'value': 'Select', 'name': 'Select'},
          {'value': '0.5', 'name': '0.5'},
          {'value': '1', 'name': '1'},
        ];
        days.value = daysCount <= 1 ? daysCount.toString() : 'Select';
      } else {
        daysOptions = [
          {'value': 'Select', 'name': 'Select'},
          {'value': daysCount.toString(), 'name': daysCount.toString()},
        ];
        days.value = daysCount.toString();
        daysMoreThanOne = true;
        tempDaysCount = daysCount.toString();
      }

      isDaysFieldEnabled.value = true;
      // Agar leave type selected hai to left leaves check karo
      if (leaveNameController.text != '') {
        await getLeftLeaves();
        update();
        // return;
      }
    } else {
      daysOptions = [
        {'value': 'Select', 'name': 'Select'},
      ];
      days.value = 'Select';
      isDaysFieldEnabled.value = false;
    }

    daysController.clear();
    dropdownItems123.assignAll(
      daysOptions
          .map(
            (option) => DropdownlstTable(
              value: option['value']!,
              name: option['name']!,
            ),
          )
          .toList(),
    );

    if (daysMoreThanOne == true) {
      daysController.text = tempDaysCount;
    }

    daysMoreThanOne = false;

    // update();
  }

  // Responsive font size return karta hai (mobile/tablet ke hisaab se)
  double getResponsiveFontSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? size * 1.2 : size; // iPad pe 20% zyada, baki normal
  }

  // Leave days dropdown ko clear karne ka function
  clearLeaveDays() async {
    daysController.clear();
    dropdownItems123.assignAll(
      daysOptions
          .map(
            (option) => DropdownlstTable(
              value: option['value']!,
              name: option['name']!,
            ),
          )
          .toList(),
    );
  }

  // Row select karne ka function (Leave history ke liye)
  void setSelectedRow(int index) {
    selectedRowIndex = index;
    // update(); // Notify the UI to rebuild
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      fromDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      // update();
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      toDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      // update();
    }
  }

  // API call to get left leave balance for employee
  Future<void> getLeftLeaves() async {
    try {
      if (toDateController.value == '' || toDateController.text == '') {
        Get.rawSnackbar(message: "Please select To Date first!");
        return;
      }

      if (leaveValueController.text == '') {
        Get.rawSnackbar(message: "Please select Leave Name first!");
        return;
      }

      isLoading = true;
      String url = ConstApiUrl.empLeftLeavesAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      DateTime? toDate = toDateController.text.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(toDateController.text, true) : null;

      if (toDate != null) {
        isDaysFieldEnabled.value = true;

        var jsonbodyObj = {
          "loginId": loginId,
          "empId": empId,
          "leaveType": leaveValueController.text,
          "leaveDate": toDate.toIso8601String()
        };

        var decodedResp = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
        LeaveDays leaveDays = LeaveDays.fromJson(jsonDecode(decodedResp));
        if (leaveDays.statusCode == 200) {
          isLoading = false;
          if (leaveDays.data != null && leaveDays.data!.isNotEmpty) {
            leftleavedays.value = leaveDays.data![0].value.toString();
            leftLeaveDaysController.text = leftleavedays.value;
            // leaveNameController.text = leaveNameController.text;
            // leaveValueController.text = leaveValueController.text;
            // update();
            return; // Return the first data value
          } else {
            leftleavedays.value = '';
            // update();
            Get.rawSnackbar(message: "No data found!");
          }
        } else if (leaveDays.statusCode == 401) {
          pref.clear();
          Get.offAll(const LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        } else if (leaveDays.statusCode == 400) {
          isLoading = false;
        } else {
          Get.rawSnackbar(message: "Something went wrong");
        }
        // update();
      } else {
        leftleavedays.value = '';
        isDaysFieldEnabled.value = false;
      }
    } catch (e) {
      isLoading = false;
      update();
    }
    leftleavedays.value = '';
    update();
  }

  Future<List<LeaveNamesTable>> fetchLeaveNames() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveNamesAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveNames leaveNames = ResponseLeaveNames.fromJson(jsonDecode(response));

      if (leaveNames.statusCode == 200) {
        leavename.clear();
        leavename = leaveNames.data!;
        isLoading = false;
        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (leaveNames.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (leaveNames.statusCode == 400) {
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

  LeaveNameChangeMethod(Map<String, String>? value) async {
    leaveValueController.text = value!['value'] ?? '';
    leaveNameController.text = value['text'] ?? '';
    await updateLeaveDays();
    update();
    // await getLeftLeaves();
  }

  RelieverNameChangeMethod(Map<String, String>? value) async {
    relieverValueController.text = value!['value'] ?? '';
    relieverNameController.text = value['text'] ?? '';
    update();
  }

  LeaveDaysOnChange(Map<String, String>? value) async {
    daysController.text = value!['text'] ?? '';
    if (leftleavedays.value.isNotEmpty && daysController.text.isNotEmpty) {
      // Converting to double
      double leftLeaveDaysValue = double.tryParse(leftleavedays.value) ?? 0.0;
      double daysControllerValue = double.tryParse(daysController.text) ?? 0.0;

      // Check if leftLeaveDaysValue is more or equal to daysControllerValue
      if (leftLeaveDaysValue < daysControllerValue) {
        // Call your method here
        await updateLeaveDays();
        Get.rawSnackbar(message: 'Insufficient Balance!');
      }
    }
    update();
  }

  DelayReasonChangeMethod(Map<String, String>? value) async {
    delayreasonIdController.text = value!['value'] ?? '';
    delayreasonNameController.text = value['text'] ?? '';
  }

  Future<List<LeaveReasonTable>> fetchLeaveReason() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveReasonAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponseLeaveReason rsponseLeaveReason = RsponseLeaveReason.fromJson(jsonDecode(response));

      if (rsponseLeaveReason.statusCode == 200) {
        leavereason.clear();
        leavereason.assignAll(rsponseLeaveReason.data ?? []);
        isLoading = false;
      } else if (rsponseLeaveReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLeaveReason.statusCode == 400) {
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
    return leavereason.toList();
  }

  Future<List<LeaveDelayReason>> fetchLeaveReliverName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      update();
      isLoading = true;
      String url = ConstApiUrl.empLeaveReliverNameAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveReliverName responseLeaveReliverName = ResponseLeaveReliverName.fromJson(jsonDecode(response));

      if (responseLeaveReliverName.statusCode == 200) {
        leaverelivername.clear();
        leaverelivername.assignAll(responseLeaveReliverName.data ?? []);
        isLoading = false;
      } else if (responseLeaveReliverName.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveReliverName.statusCode == 400) {
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

  Future<List<LeaveDelayReason>> fetchLeaveDelayReason() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveDelayReasonAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveDelayReason rsponseLeaveDelayReason = ResponseLeaveDelayReason.fromJson(jsonDecode(response));

      if (rsponseLeaveDelayReason.statusCode == 200) {
        leavedelayreason.clear();
        leavedelayreason.assignAll(rsponseLeaveDelayReason.data ?? []);
        isLoading = false;
      } else if (rsponseLeaveDelayReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLeaveDelayReason.statusCode == 400) {
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

  Future<List<HeaderList>> fetchHeaderList(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveHeaderList;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseHeaderList responseHeaderList = ResponseHeaderList.fromJson(jsonDecode(response));

      if (responseHeaderList.statusCode == 200) {
        if (responseHeaderList.data != null && responseHeaderList.data!.isNotEmpty) {
          isLoading = false;
          leaveHeaderList = responseHeaderList.data!;
          update();
          return leaveHeaderList;
        } else {
          leaveentryList = [];
        }
      } else if (responseHeaderList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseHeaderList.statusCode == 400) {
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

  Future<List<LeaveEntryList>> fetchLeaveEntryList(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empLeaveEntryListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveEntryList responseLeaveEntryList = ResponseLeaveEntryList.fromJson(jsonDecode(response));

      if (responseLeaveEntryList.statusCode == 200) {
        if (responseLeaveEntryList.data != null && responseLeaveEntryList.data!.isNotEmpty) {
          isLoading = false;
          leaveentryList = responseLeaveEntryList.data!;
          update();
          return leaveentryList;
        } else {
          leaveentryList = [];
        }
      } else if (responseLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveEntryList.statusCode == 400) {
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

  // Date formatting function with optional time handling based on flag (OT or LV)
  String formatDateWithTime(String dateString, String flag) {
    String jsonDateTime = "";
    // Check if the date string is not empty
    if (dateString != "") {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime dateTime = dateFormat.parse(dateString);

      if (flag.toLowerCase() == 'ot') {
        // OT ke liye, manually passed time ka use karein
        DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        dateTime = dateTimeFormat.parse(dateString);
      } else {
        // LV ke liye, default 00:00:00 time use karein
        dateTime = dateTime.add(Duration(hours: 0, minutes: 0, seconds: 0));
      }

      jsonDateTime = dateTime.toIso8601String();
    }
    return jsonDateTime;
  }

  // Function to format the FromDateTime or ToDateTime for Overtime using controller
  String formatOTDateTime(OvertimeController overtimeController, String flag) {
    String jsonDateTime = "";

    if (flag == "FromDateTime") {
      // Validate and build FromDateTime using selected date and time
      if (overtimeController.selectedFromDate != null && overtimeController.selectedFromTime != null) {
        DateTime fromDateTime = DateTime(
          overtimeController.selectedFromDate!.year,
          overtimeController.selectedFromDate!.month,
          overtimeController.selectedFromDate!.day,
          overtimeController.selectedFromTime!.hour,
          overtimeController.selectedFromTime!.minute,
        );

        // Format to "YYYY-MM-DDTHH:MM:SS" (local time, no UTC conversion)
        jsonDateTime = "${fromDateTime.toLocal().toIso8601String().substring(0, 19)}"; // Ensuring format with "T" and no milliseconds
      } else {
        throw Exception("FromDateTime or FromTime is null");
      }
    } else if (flag == "ToDateTime") {
      if (overtimeController.selectedToDate != null && overtimeController.selectedToTime != null) {
        DateTime toDateTime = DateTime(
          overtimeController.selectedToDate!.year,
          overtimeController.selectedToDate!.month,
          overtimeController.selectedToDate!.day,
          overtimeController.selectedToTime!.hour,
          overtimeController.selectedToTime!.minute,
        );

        // Format to "YYYY-MM-DDTHH:MM:SS" (local time, no UTC conversion)
        jsonDateTime = "${toDateTime.toLocal().toIso8601String().substring(0, 19)}"; // Ensuring format with "T" and no milliseconds
      } else {
        throw Exception("ToDateTime or ToTime is null");
      }
    } else {
      throw Exception("Invalid flag provided. Use 'FromDateTime' or 'ToDateTime'.");
    }

    return jsonDateTime; // Return the formatted datetime string
  }

  bool validateSaveLeaveEntry(String flag) {
    if (flag.toLowerCase() == 'lv') {
      if (fromDateController.text.isEmpty || fromDateController.text == null) {
        Get.rawSnackbar(message: "Please enter start date");
        return false;
      }
      if (toDateController.text.isEmpty || toDateController.text == null) {
        Get.rawSnackbar(message: "Please enter end date");
        return false;
      }
      if (reasonController.text.isEmpty || reasonController.text == null) {
        Get.rawSnackbar(message: "Please enter reason");
        return false;
      }
      if (leaveValueController.text.isEmpty || leaveValueController.text == null) {
        Get.rawSnackbar(message: "Please select leave type");
        return false;
      }
      if (leaveNameController.text.isEmpty || leaveNameController.text == null) {
        Get.rawSnackbar(message: "Please enter leave name");
        return false;
      }
      // if (noteController.text.isEmpty || noteController.text == null) {
      //   Get.rawSnackbar(message: "Please enter note");
      //   return false;
      // }
      if (daysController.text.isEmpty || daysController.text == null) {
        Get.rawSnackbar(message: "Please enter number of days");
        return false;
      }

      if (reasonController.text.isEmpty || reasonController.text == null) {
        Get.rawSnackbar(message: "Please enter leave reason!");
        return false;
      }

      if (leaverelivername.length > 0 && relieverValueController.text.isEmpty) {
        Get.rawSnackbar(message: "Please enter reliver name!");
        return false;
      }
    } else if (flag.toLowerCase() == 'ot') {
      if (overtimeController.fromDateController.text.isEmpty || overtimeController.fromDateController.text == null) {
        Get.rawSnackbar(message: "Please enter start date");
        return false;
      }
      if (overtimeController.toDateController.text.isEmpty || overtimeController.toDateController.text == null) {
        Get.rawSnackbar(message: "Please enter end date");
        return false;
      }
      if (overtimeController.otMinutesController.text.isEmpty || overtimeController.otMinutesController.text == null) {
        Get.rawSnackbar(message: "Please select proper date & time");
        return false;
      }
    }
    return true;
  }

  Future<List<SaveLeaveEntryList>> saveLeaveEntryList(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      if (!validateSaveLeaveEntry(flag)) {
        return [];
      }
      isSaveBtnLoading = true;
      update();
      String url = ConstApiUrl.empSaveLeaveEntryList;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      // delayreasonIdController.text = delayreasonNameController.text == '' ? '0' : delayreasonIdController.text;

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "entryType": flag,
        "leaveShortName": flag == "LV" ? leaveValueController.text : "OT",
        "leaveFullName": flag == "LV" ? leaveNameController.text : "OT",
        "fromdate": flag == "LV" ? formatDateWithTime(fromDateController.text, 'lv') : formatOTDateTime(overtimeController, 'FromDateTime'),
        "todate": flag == "LV" ? formatDateWithTime(toDateController.text, 'lv') : formatOTDateTime(overtimeController, 'ToDateTime'),
        "reason": flag == "LV" ? reasonController.text : "OT",
        "note": flag == "LV" ? noteController.text : overtimeController.noteController.text,
        "leaveDays": flag == "LV" ? daysController.text : 0,
        "overTimeMinutes": flag == "LV" ? 0 : int.tryParse(overtimeController.otMinutesController.text) ?? 0,
        "usr_Nm": '',
        "reliever_Empcode": flag == "LV" ? relieverValueController.text : '',
        "delayLVNote": flag == "LV" ? delayreasonIdController.text : overtimeController.delayreasonId_OT_Controller.text,
        "leaveDivision": flag == "LV" ? hdleaveperiodController.text : "OT"
      };
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      print(response);
      ResponseSaveLeaveEntryList responseSaveLeaveEntryList = ResponseSaveLeaveEntryList.fromJson(jsonDecode(response));
      if (responseSaveLeaveEntryList.statusCode == 200) {
        if (responseSaveLeaveEntryList.isSuccess == "true" && responseSaveLeaveEntryList.data?.isNotEmpty == true) {
          if (responseSaveLeaveEntryList.data![0].savedYN == "Y") {
            isSaveBtnLoading = false;
            await fetchLeaveEntryList(flag);
            resetForm();
            Get.rawSnackbar(message: "Data saved successfully");
          }
        } else {
          Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
        }
        isSaveBtnLoading = false;
      } else if (responseSaveLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSaveLeaveEntryList.statusCode == 400) {
        isSaveBtnLoading = false;
        Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
      } else {
        isSaveBtnLoading = false;
        Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
      }
    } catch (e) {
      print(e);
      isSaveBtnLoading = false;
      ApiErrorHandler.handleError(
        screenName: "LeaveScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isSaveBtnLoading = false;
    return [];
  }

  resetForm() {
    Get.back();
    fromDateController.clear();
    toDateController.clear();
    leaveNameController.clear();
    leaveValueController.clear();
    daysController.clear();
    reasonController.clear();
    noteController.clear();
    relieverNameController.clear();
    relieverValueController.clear();
    delayreasonNameController.clear();
    delayreasonIdController.clear();
    hdleaveperiodController.clear();
    leftleavedays.value = '';
    leftLeaveDaysController.text = '';
    overtimeController.fromDateController.clear();
    overtimeController.toDateController.clear();
    overtimeController.fromTimeController.clear();
    overtimeController.toTimeController.clear();
    overtimeController.noteController.clear();
    overtimeController.otMinutesController.clear();
    overtimeController.delayreasonName_OT_Controller.clear();
    overtimeController.delayreasonId_OT_Controller.clear();
    tabController_Leave.animateTo(0);
    overtimeController.tabController_OT.animateTo(0);
    update();
  }
}

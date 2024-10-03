import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/leave/model/dropdownlist_custom.dart';
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
// import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveController extends GetxController with GetSingleTickerProviderStateMixin {
  var bottomBarController = Get.put(BottomBarController());
  var isLoading = false.obs;
  var leftleavedays = ''.obs;
  List<LeaveNamesTable> leavename = [];
  var dropdownItems123 = <DropdownlstTable>[].obs;

  List<LeaveEntryList> leaveentryList = [];
  List<LeaveEntryList> otentryList = [];
  List<SaveLeaveEntryList> saveleaveentrylist = [];

  var leavereason = <LeaveReasonTable>[].obs;
  var leavedelayreason = <LeaveDelayReason>[].obs;
  var leaverelivername = <LeaveReliverName>[].obs;

  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController leaveNameController = TextEditingController();
  TextEditingController leaveValueController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController relieverNameController = TextEditingController();
  TextEditingController relieverValueController = TextEditingController();
  TextEditingController delayreasonNameController = TextEditingController();
  TextEditingController delayreasonIdController = TextEditingController();
  RxString days = ''.obs; // To store the calculated days
  RxBool isDaysFieldEnabled = false.obs;
  var overtimeController = Get.put(OvertimeController());
  var inchargeAction = ''.obs;
  var hodAction = ''.obs;
  var hrAction = ''.obs;
  List<Map<String, String>> daysOptions = [];
  late TabController tabController;
  var activeScreen = ''.obs;
  var leaveScrollController = ScrollController();

  @override
  void onInit() async {
    super.onInit();
    // await getLeaveDays();
    await fetchLeaveNames();
    await fetchLeaveReason();
    await fetchLeaveReliverName();
    await fetchLeaveDelayReason();
    // await fetchLeaveEntryList();
    update();
    leaveScrollController.addListener(() {
      if (leaveScrollController.hasClients &&
          leaveScrollController.positions.isNotEmpty &&
          leaveScrollController.position.userScrollDirection == ScrollDirection.forward) {
        hideBottomBar = false.obs;
        bottomBarController.update();
      } else if (leaveScrollController.hasClients &&
          leaveScrollController.positions.isNotEmpty &&
          leaveScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        hideBottomBar = true.obs;
        bottomBarController.update();
      }
      update();
    });
    fromDateController.addListener(updateDays);
    toDateController.addListener(updateDays);

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() async {
      if (tabController.index == 1) {
        // Tumhara logic jab 'View' tab pe swipe karke aate ho
        print("Swiped to View Tab");
        // Yaha data fetch kar sakte ho
        await fetchLeaveEntryList(activeScreen.value == "LeaveMainScreen" ? "LV" : "OT");
      }
      update();
    });
  }

  @override
  void onClose() {
    // leaveScrollController.dispose();
    super.onClose();
  }

  void updateDays() async {
    final String formDateText = fromDateController.text;
    final String toDateText = toDateController.text;

    DateTime? fromDate = formDateText.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(formDateText, true) : null;
    DateTime? toDate = toDateText.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(toDateText, true) : null;

    List<Map<String, String>> daysOptions;

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
      }

      isDaysFieldEnabled.value = true;

      if (leaveNameController.text != '') {
        await getLeftLeaves();
        // return;
      }
    } else {
      daysOptions = [
        {'value': 'Select', 'name': 'Select'},
      ];
      days.value = 'Select';
      isDaysFieldEnabled.value = false;
    }

    // daysController.clear();
    // dropdownItems123.clear();
    // dropdownItems123 = daysOptions
    //     .map((option) => DropdownlstTable(
    //           value: option['value']!,
    //           name: option['name']!,
    //         ))
    //     .toList();
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

    // update();
  }

  Future<void> selectFromDate(BuildContext context, TextEditingController controller) async {
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

  Future<void> selectToDate(BuildContext context, TextEditingController controller) async {
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

  Future<void> getLeftLeaves() async {
    try {
      if (toDateController.value == '' || toDateController.value == null || toDateController.text == '') {
        Get.rawSnackbar(message: "Please select To Date first!");
        return;
      }

      if (leaveValueController.text == '' || leaveValueController.text == null) {
        Get.rawSnackbar(message: "Please select Leave Name first!");
        return;
      }

      isLoading.value = true;
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
          isLoading.value = false;
          if (leaveDays.data != null && leaveDays.data!.isNotEmpty) {
            leftleavedays.value = leaveDays.data![0].value.toString();
            // update();
            return; // Return the first data value
          } else {
            leftleavedays.value = '';
            update();
            Get.rawSnackbar(message: "No data found!");
          }
        } else if (leaveDays.statusCode == 401) {
          pref.clear();
          Get.offAll(const LoginScreen());
          Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
        } else if (leaveDays.statusCode == 400) {
          isLoading.value = false;
        } else {
          Get.rawSnackbar(message: "Something went wrong");
        }
        update();
      } else {
        // leftleavedays.value = '';
        isDaysFieldEnabled.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      update();
    }
    leftleavedays.value = '';
    update();
  }

  Future<List<LeaveNamesTable>> fetchLeaveNames() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveNamesAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveNames leaveNames = ResponseLeaveNames.fromJson(jsonDecode(response));

      if (leaveNames.statusCode == 200) {
        leavename.clear();
        leavename = leaveNames.data!;

        // leavename.addAll(leaveNames.data?.map((e) => e.name ?? "").toList() ?? []);
      } else if (leaveNames.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (leaveNames.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Somethin g went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  LeaveNameChangeMethod(Map<String, String>? value) async {
    leaveValueController.text = value!['value'] ?? '';
    leaveNameController.text = value['text'] ?? '';
    await getLeftLeaves();
  }

  RelieverNameChangeMethod(Map<String, String>? value) async {
    relieverValueController.text = value!['value'] ?? '';
    relieverNameController.text = value['text'] ?? '';
    // update();
  }

  LeaveDaysOnChange(Map<String, String>? value) async {
    daysController.text = value!['text'] ?? '';
    // update();
  }

  Future<List<LeaveReasonTable>> fetchLeaveReason() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveReasonAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponseLeaveReason rsponseLeaveReason = RsponseLeaveReason.fromJson(jsonDecode(response));

      if (rsponseLeaveReason.statusCode == 200) {
        leavereason.clear();
        leavereason.assignAll(rsponseLeaveReason.data ?? []);
        // print(leavereason);
      } else if (rsponseLeaveReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLeaveReason.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return leavereason.toList();
  }

  Future<List<LeaveDelayReason>> fetchLeaveReliverName() async {
    try {
      update();
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveReliverNameAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveReliverName responseLeaveReliverName = ResponseLeaveReliverName.fromJson(jsonDecode(response));

      if (responseLeaveReliverName.statusCode == 200) {
        leaverelivername.clear();
        leaverelivername.assignAll(responseLeaveReliverName.data ?? []);
      } else if (responseLeaveReliverName.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveReliverName.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<List<LeaveDelayReason>> fetchLeaveDelayReason() async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveDelayReasonAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveDelayReason rsponseLeaveDelayReason = ResponseLeaveDelayReason.fromJson(jsonDecode(response));

      if (rsponseLeaveDelayReason.statusCode == 200) {
        leavedelayreason.clear();
        leavedelayreason.assignAll(rsponseLeaveDelayReason.data ?? []);
      } else if (rsponseLeaveDelayReason.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponseLeaveDelayReason.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }

  Future<List<LeaveEntryList>> fetchLeaveEntryList(String flag) async {
    try {
      isLoading.value = true;
      String url = ConstApiUrl.empLeaveEntryListAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseLeaveEntryList responseLeaveEntryList = ResponseLeaveEntryList.fromJson(jsonDecode(response));

      if (responseLeaveEntryList.statusCode == 200) {
        if (responseLeaveEntryList.data != null && responseLeaveEntryList.data!.isNotEmpty) {
          isLoading.value = false;
          if (flag == "LV") {
            leaveentryList = responseLeaveEntryList.data!;
            update();
            return leaveentryList;
          } else {
            otentryList = responseLeaveEntryList.data!;
            // update();
            overtimeController.update();
            return otentryList;
          }
        } else {
          if (flag == "LV")
            leaveentryList = [];
          else
            otentryList = [];
        }
      } else if (responseLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseLeaveEntryList.statusCode == 400) {
        isLoading.value = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      // update();
      // overtimeController.update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
    isLoading.value = false;
    return [];
  }

  // String formatDateWithTime(String dateString) {
  //   String jsonDateTime = "";
  //   if (dateString != "") {
  //     // DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
  //     // return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(parsedDate);
  //     DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  //     // Parse karke DateTime me convert karo aur time append karo
  //     DateTime dateTime = dateFormat.parse(dateString).add(Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0));

  //     // Convert karo JSON format (ISO 8601) me
  //     jsonDateTime = dateTime.toIso8601String();
  //   }
  //   return jsonDateTime;
  // }

  String formatDateWithTime(String dateString, String flag) {
    String jsonDateTime = "";
    if (dateString != "") {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime dateTime = dateFormat.parse(dateString);

      if (flag.toLowerCase() == 'ot' && dateString != null) {
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

  String formatOTDateTime(OvertimeController overtimeController, String flag) {
    String jsonDateTime = "";

    if (flag == "FromDateTime") {
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
      if (noteController.text.isEmpty || noteController.text == null) {
        Get.rawSnackbar(message: "Please enter note");
        return false;
      }
      if (daysController.text.isEmpty || daysController.text == null) {
        Get.rawSnackbar(message: "Please enter number of days");
        return false;
      }

      // if (reasonController.text.isEmpty || reasonController.text == null) {
      //   Get.rawSnackbar(message: "Please enter leave reason!");
      //   return false;
      // }

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
        Get.rawSnackbar(message: "Please select date");
        return false;
      }
    }
    return true;
  }

  Future<List<SaveLeaveEntryList>> saveLeaveEntryList(String flag) async {
    try {
      if (!validateSaveLeaveEntry(flag)) {
        return [];
      }
      // var overtimeController = Get.put(OvertimeController());
      var overtimeController = Get.find<OvertimeController>();
      // update();
      isLoading.value = true;
      String url = ConstApiUrl.empSaveLeaveEntryList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "entryType": flag,
        "leaveShortName": flag == "LV" ? leaveValueController.text : "OT",
        "leaveFullName": flag == "LV" ? leaveNameController.text : "OT",
        "fromdate": flag == "LV" ? formatDateWithTime(fromDateController.text, 'lv') : formatOTDateTime(overtimeController, 'FromDateTime'),
        "todate": flag == "LV" ? formatDateWithTime(toDateController.text, 'lv') : formatOTDateTime(overtimeController, 'ToDateTime'),
        "reason": flag == "LV" ? reasonController.text : "OT",
        "note": noteController.text,
        "leaveDays": flag == "LV" ? daysController.text : 0,
        "overTimeMinutes": flag == "LV" ? 0 : int.tryParse(overtimeController.otMinutesController.text) ?? 0,
        "usr_Nm": '',
        "reliever_Empcode": flag == "LV" ? relieverValueController.text : '',
        "delayLVNote": flag == "LV" ? delayreasonNameController.text : overtimeController.delayReasonController.text,
      };
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      print(response);
      ResponseSaveLeaveEntryList responseSaveLeaveEntryList = ResponseSaveLeaveEntryList.fromJson(jsonDecode(response));
      if (responseSaveLeaveEntryList.statusCode == 200) {
        if (responseSaveLeaveEntryList.isSuccess == "true" && responseSaveLeaveEntryList.data?.isNotEmpty == true) {
          if (responseSaveLeaveEntryList.data![0].savedYN == "Y") {
            await fetchLeaveEntryList(flag);
            Get.rawSnackbar(message: "Data saved successfully");
            // resetForm();
            // update();
          }
        } else {
          Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
        }
      } else if (responseSaveLeaveEntryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSaveLeaveEntryList.statusCode == 400) {
        isLoading.value = false;
        Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
      } else {
        Get.rawSnackbar(message: responseSaveLeaveEntryList.message);
      }
      // update();
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
    return [];
  }

  void resetForm() {
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
    leftleavedays.value = '';
    overtimeController.fromDateController.clear();
    overtimeController.toDateController.clear();
    overtimeController.fromTimeController.clear();
    overtimeController.toTimeController.clear();
    overtimeController.noteController.clear();
    overtimeController.otMinutesController.clear();
    overtimeController.delayReasonController.clear();
    // updateDays(); // This will reset the days dropdown
    update();
  }
}

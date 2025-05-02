import 'dart:convert';
import 'dart:io';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/notification/model/notificationfile_model.dart';
import 'package:emp_app/app/moduls/notification/model/notificationlist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class NotificationController extends GetxController {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String tokenNo = '', loginId = '', empId = '';
  List<NotificationlistModel> notificationlist = [];
  List<NotificationlistModel> filternotificationlist = [];
  List<NotificationfileModel> notificationfile = [];
  bool isLoading = false;
  final ApiController apiController = Get.put(ApiController());
  List<Map<String, String>> filesList = [];
  final FocusNode searchFocusNode = FocusNode();
  RxBool isNotesFieldFocused = false.obs;

  @override
  void onInit() {
    fetchNotificationList();
    searchController.clear();
    searchFocusNode.unfocus();
    searchFocusNode.addListener(_onsearchFocusChange);
    super.onInit();
  }

  void _onsearchFocusChange() {
    if (!searchFocusNode.hasFocus) {
      isNotesFieldFocused.value = searchFocusNode.hasFocus;
      update();
    }
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

  Future<List<NotificationlistModel>> fetchNotificationList({int days = 0, String tag = "", String fromDate = "", String toDate = ""}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update();
      // notificationlist.clear(); // 👈 Important: Clear previous list
      // filternotificationlist.clear();
      String url = ConstApiUrl.empNotificationListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      var jsonbodyObj;
      if (fromDate == "" && toDate == "") {
        jsonbodyObj = {"loginId": loginId, "empId": empId, "days": days, "tag": tag};
      } else {
        jsonbodyObj = {
          "loginId": loginId,
          "empId": empId,
          "days": days,
          "tag": tag,
          "FromDate": fromDate,
          "ToDate": toDate,
        };
      }
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseNotificationList responseNotificationList = ResponseNotificationList.fromJson(jsonDecode(response));
      notificationlist.clear();
      if (responseNotificationList.statusCode == 200) {
        notificationlist.assignAll(responseNotificationList.data ?? []);
        if (responseNotificationList.data != null && responseNotificationList.data!.isNotEmpty) {
          filternotificationlist = responseNotificationList.data!;
        } else {
          filternotificationlist = [];
        }
        isLoading = false;
      } else if (responseNotificationList.statusCode == 401) {
        notificationlist.clear(); // 👈 Important: Clear previous list
        filternotificationlist.clear();
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseNotificationList.statusCode == 400) {
        notificationlist.clear(); // 👈 Important: Clear previous list
        filternotificationlist.clear();
        isLoading = false;
      } else {
        notificationlist.clear(); // 👈 Important: Clear previous list
        filternotificationlist.clear();
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "NotificationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return notificationlist.toList();
  }

  Future<List<NotificationfileModel>> fetchNotificationFile(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;

      if (notificationlist.isEmpty || index >= notificationlist.length) {
        Get.rawSnackbar(message: "No notification found for the selected index.");
        isLoading = false;
        return [];
      }
      String url = ConstApiUrl.empNotificationFileAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "notificationId": notificationlist[index].id.toString(), "index": 0};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseNotificationfile responseNotificationfile = ResponseNotificationfile.fromJson(jsonDecode(response));
      notificationfile.clear();
      filesList.clear();
      if (responseNotificationfile.statusCode == 200) {
        notificationfile.assignAll(responseNotificationfile.data ?? []);
        for (var fileData in notificationfile) {
          String fileName = fileData.fileName ?? "file";
          String base64Content = fileData.fileContent ?? "";
          String contentType = fileData.contentType ?? "application/pdf";

          File file = await writeBase64ToFile(base64Content, fileName);
          filesList.add({
            "fileName": fileName,
            "contentType": contentType,
            "filePath": file.path,
            "content": base64Content,
          });
          // Do something with the file if needed
        }
        isLoading = false;
      } else if (responseNotificationfile.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseNotificationfile.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "NotificationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return notificationfile.toList();
  }

  Future<void> updateNotificationRead(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empUpdateNotificationReadAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "notificationId": notificationlist[index].id.toString(), "index": 0};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "NotificationScreen",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filternotificationlist = notificationlist; // Show all data if search is empty
    } else {
      filternotificationlist = notificationlist.where((item) {
        final sender = (item.sender ?? "").toLowerCase();
        final messagetitle = (item.messageTitle ?? "").toLowerCase();

        // Check if query matches either patientName or ipdNo
        return sender.contains(query.toLowerCase()) || messagetitle.contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  Future<File> writeBase64ToFile(String base64Content, String fileName) async {
    final decodedBytes = base64Decode(base64Content);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$fileName");
    await file.writeAsBytes(decodedBytes);
    return file;
  }

  // Future<void> openFile(String fileName, String fileContent, String contentType) async {
  //   try {
  //     final bytes = base64Decode(fileContent);
  //     final tempDir = await getTemporaryDirectory();
  //     final filePath = '${tempDir.path}/$fileName';
  //     final file = File(filePath);

  //     await file.writeAsBytes(bytes);
  //     final result = await OpenFilex.open(file.path);

  //     if (result.type != ResultType.done) {
  //       print("OpenFilex failed: ${result.message}");
  //     }
  //   } catch (e) {
  //     print("Error while opening file: $e");
  //   }
  // }

  // Future<void> openFile(String fileName, String fileContent, String contentType) async {
  //   try {
  //     // If contentType is image, open the file picker to pick an image
  //     if (contentType == "image") {
  //       // Pick an image file using FilePicker
  //       FilePickerResult? result = await FilePicker.platform.pickFiles(
  //         type: FileType.image,
  //       );

  //       if (result != null) {
  //         // Get the selected file
  //         File file = File(result.files.single.path!);

  //         // Open the selected file using OpenFilex
  //         final openResult = await OpenFilex.open(file.path);

  //         if (openResult.type != ResultType.done) {
  //           print("OpenFilex failed: ${openResult.message}");
  //         }
  //       } else {
  //         print("No file selected");
  //       }
  //     } else {
  //       // If it's a regular file (not an image), decode the base64 and save it to a temporary file
  //       final bytes = base64Decode(fileContent);
  //       final tempDir = await getTemporaryDirectory();
  //       final filePath = '${tempDir.path}/$fileName';
  //       final file = File(filePath);

  //       await file.writeAsBytes(bytes);

  //       // Open the saved file
  //       final openResult = await OpenFilex.open(file.path);

  //       if (openResult.type != ResultType.done) {
  //         print("OpenFilex failed: ${openResult.message}");
  //       }
  //     }
  //   } catch (e) {
  //     print("Error while opening file: $e");
  //   }
  // }

  final List<String> filterOptions = [
    "Today",
    "Last 7 days",
    "Last 15 days",
    "Last 30 days",
    "Last 50 days",
    "Last 70 days",
    "Last 90 days",
    "Date range",
  ];
  final Map<String, int> filterOptionDaysMap = {
    "Today": 1,
    "Last 7 days": 7,
    "Last 15 days": 15,
    "Last 30 days": 30,
    "Last 50 days": 50,
    "Last 70 days": 70,
    "Last 90 days": 90,
    "Date range": 0, // handled separately
  };
  RxList<String> selectedTags = <String>[].obs;

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }
}

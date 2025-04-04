import 'dart:convert';
import 'dart:io';
import 'package:emp_app/app/core/service/api_service.dart';
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
import 'package:open_filex/open_filex.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    fetchNotificationList();

    super.onInit();
  }

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

  Future<List<NotificationlistModel>> fetchNotificationList() async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empNotificationListAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

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
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseNotificationList.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    return notificationlist.toList();
  }

  Future<List<NotificationfileModel>> fetchNotificationFile() async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empNotificationFileAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "index": 0};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseNotificationfile responseNotificationfile = ResponseNotificationfile.fromJson(jsonDecode(response));

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
    }
    isLoading = false;
    return notificationfile.toList();
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

  Future<void> openFile(String fileName, String fileContent, String contentType) async {
    // final bytes = base64Decode(fileContent);
    // final tempDir = await getTemporaryDirectory();
    // final file = File('${tempDir.path}/$fileName');

    // await file.writeAsBytes(bytes);
    writeBase64ToFile(fileContent, fileName).then((file) {
      OpenFilex.open(file.path);
    });
    // OpenFilex.open(file.path);
  }
}

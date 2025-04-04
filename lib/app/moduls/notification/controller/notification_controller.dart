import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/notification/model/notificationlist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<NotificationlistModel> notificationlist = [];
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  final ApiController apiController = Get.put(ApiController());

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

      if (responseNotificationList.statusCode == 200) {
        notificationlist.clear();
        notificationlist.assignAll(responseNotificationList.data ?? []);
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
}

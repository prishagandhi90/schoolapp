import 'dart:convert';
import 'package:emp_app/app/app_custom_widget/common_dropdown_model.dart';
import 'package:emp_app/app/app_custom_widget/dropdown_G_model.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuperloginController extends GetxController {
  final TextEditingController numbercontroller = TextEditingController();
  Dropdown_G? selectedUserName;
  final TextEditingController userName_nm_controller = TextEditingController();
  final TextEditingController userName_value_controller = TextEditingController();
  final TextEditingController searchFieldController = TextEditingController();
  var userTable = <DropdownTable>[].obs;
  List<DropdownTable> filteredItems = [];
  bool isLoading = false;
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  final FocusNode searchFocusNode = FocusNode();
  final superloginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    filteredItems = userTable;
    fetchUserName();
  }

  UserNameChangeMethod(Dropdown_G? value) async {
    userName_value_controller.text = value!.value ?? '';
    userName_nm_controller.text = value.name ?? '';
    update();
  }

  void updateSearchResults(String searchValue) {
    filteredItems = userTable.where((item) {
      return item.name?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
    }).toList();
    update(); // GetX state update
  }

  Future<List<DropdownTable>> fetchUserName() async {
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empLoginusernameAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseDropdownList responseDropdownList = ResponseDropdownList.fromJson(jsonDecode(response));

      if (responseDropdownList.statusCode == 200) {
        userTable.clear();
        userTable.assignAll(responseDropdownList.data ?? []);
        isLoading = false;
      } else if (responseDropdownList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseDropdownList.statusCode == 400) {
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
    return [];
  }
}

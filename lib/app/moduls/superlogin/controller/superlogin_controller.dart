import 'dart:convert';
import 'package:emp_app/app/app_custom_widget/common_dropdown_model.dart';
import 'package:emp_app/app/app_custom_widget/dropdown_G_model.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/routes/app_pages.dart';
import 'package:emp_app/app/moduls/superlogin/model/superlogincred_model.dart';
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
  List<SuperlogincredModel> superlogincredModel = [];
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

  Future userNameOnClk(Dropdown_G? value) async {
    selectedUserName = value;
    update();
  }

  // UserNameChangeMethod(Dropdown_G? value) async {
  //   userName_value_controller.text = value!.value ?? '';
  //   userName_nm_controller.text = value.name ?? '';
  //   update();
  // }

  void dismissKeyboard() {
    // Close the keyboard whenever you click outside
    FocusScope.of(Get.context!).requestFocus(FocusNode());
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

  Future<List<SuperlogincredModel>> fetchSperLoginCred() async {
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empSuperLoginCred;
      SharedPreferences pref = await SharedPreferences.getInstance();
      // loginId = await pref.getString(AppString.keyLoginId) ?? "";
      // tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"adminMobileNo": numbercontroller.text, "userName": selectedUserName!.name};
      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Map<String, dynamic> jsonResponse = jsonDecode(response);

      // Check if the response contains valid data
      if (jsonResponse['data'] == null || jsonResponse['data'].isEmpty) {
        isLoading = false;
        update();
        Get.rawSnackbar(message: "No data found");
      }

      ResponseSuperLoginCred responseSuperLoginCred = ResponseSuperLoginCred.fromJson(jsonDecode(response));

      if (responseSuperLoginCred.statusCode == 200) {
        superlogincredModel.clear();
        superlogincredModel.assignAll(responseSuperLoginCred.data ?? []);
        if (responseSuperLoginCred.data != null && responseSuperLoginCred.isSuccess.toString() == "true") {
          await pref.setString(AppString.keyToken, superlogincredModel[0].tokenNo ?? '');
          await pref.setString(AppString.keyLoginId, superlogincredModel[0].loginId.toString());
          await pref.setString(AppString.keyEmpId, superlogincredModel[0].empId.toString());
          await pref.setString(AppString.keySuperAdmin, "True");
          bool isLoggedIn = pref.getString(AppString.keyToken) != null && pref.getString(AppString.keyToken) != '' ? true : false;
          if (isLoggedIn == true) {
            Get.offAllNamed(Routes.BOTTOM_BAR);
          }
        }
        isLoading = false;
      } else if (responseSuperLoginCred.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSuperLoginCred.statusCode == 400) {
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

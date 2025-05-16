import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/city_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/externallab_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/servicegrp_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestRequisitController extends GetxController {
  @override
  void onInit() {
    fetchExternalLab();
    fetchServiceGroup();
    super.onInit();
  }

  final typeController = TextEditingController();
  final priorityController = TextEditingController();
  final InExController = TextEditingController();
  final serviceGroupController = TextEditingController();
  final ApiController apiController = Get.put(ApiController());
  String tokenNo = '', loginId = '', empId = '';
  bool isLoading = false;
  var externalLab = <ExternallabModel>[].obs;
  var serviceGroup = <ServicegrpModel>[].obs;

  final List<DropdownMenuItem<Map<String, String>>> typeItems = [
    DropdownMenuItem(
      value: {'text': '--select--'},
      child: Text('--select--'),
    ),
    DropdownMenuItem(
      value: {'text': 'lab'},
      child: Text('lab'),
    ),
    DropdownMenuItem(
      value: {'text': 'radio'},
      child: Text('radio'),
    ),
  ];

  final List<DropdownMenuItem<Map<String, String>>> priorityItems = [
    DropdownMenuItem(
      value: {'text': 'normal'},
      child: Text('normal'),
    ),
    DropdownMenuItem(
      value: {'text': 'urgent'},
      child: Text('urgent'),
    ),
  ];

  Future<List<ExternallabModel>> fetchExternalLab() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empExternalLabList;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseExternalLab responseExternalLab = ResponseExternalLab.fromJson(jsonDecode(response));

      if (responseExternalLab.statusCode == 200) {
        externalLab.clear();
        externalLab.assignAll(responseExternalLab.data ?? []);
        isLoading = false;
      } else if (responseExternalLab.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseExternalLab.statusCode == 400) {
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
    return externalLab.toList();
  }

  Future<List<ServicegrpModel>> fetchServiceGroup() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empServiceGroupAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseServiceGroup responseServiceGroup = ResponseServiceGroup.fromJson(jsonDecode(response));

      if (responseServiceGroup.statusCode == 200) {
        serviceGroup.clear();
        serviceGroup.assignAll(responseServiceGroup.data ?? []);
        isLoading = false;
      } else if (responseServiceGroup.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseServiceGroup.statusCode == 400) {
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
    return serviceGroup.toList();
  }

  static Future<List<CityModel>> fetchCitySuggestions(String query) async {
    try {
      final response = await Dio().get(
        ConstApiUrl.empPatientNm_UHID_IPDAPI,
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((e) => CityModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }
}

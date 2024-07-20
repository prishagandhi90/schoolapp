import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/payroll/model/payroll_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PayrollController extends GetxController {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  var bottomBarController = Get.put(BottomBarController());
  var isLoading = false.obs;
  late List<Payroll> payrolltable = [];
  final ApiController apiController = Get.put(ApiController());
  String tokenNo = '', loginId = '';
  final _storage = const FlutterSecureStorage();
  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }

  Future<dynamic> getProfileData() async {
    try {
      String url = 'http://117.217.126.127:44166/api/Employee/GetEmpSummary_Dashboard';

      loginId = await _storage.read(key: "KEY_LOGINID") ?? '';
      tokenNo = await _storage.read(key: "KEY_TOKENNO") ?? '';
      var jsonbodyObj = {"loginId": loginId};

      var empmonthyrtable = await apiController.getDynamicData(url, tokenNo, jsonbodyObj);
      payrolltable = apiController.parseJson_Flag_payroll(empmonthyrtable, 'data');

      isLoading.value = false;
      update();
      return payrolltable;
    } catch (e) {
      isLoading.value = false;
      update();
    }
    return [];
  }
}

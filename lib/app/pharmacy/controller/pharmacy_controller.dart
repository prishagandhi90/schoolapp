import 'dart:convert';

import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/pharmacy/model/presviewer_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchLeaveReason();
  }

  bool isLoading = true;
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  final bottomBarController = Get.put(BottomBarController());
  List<PresviewerList> presviewerList = [];

  Future<List<PresviewerList>> fetchLeaveReason() async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empPresViewerListAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Rsponsedrpresviewer rsponsedrpresviewer = Rsponsedrpresviewer.fromJson(jsonDecode(response));

      if (rsponsedrpresviewer.statusCode == 200) {
        presviewerList.clear();
        presviewerList.assignAll(rsponsedrpresviewer.data ?? []);
        isLoading = false;
      } else if (rsponsedrpresviewer.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedrpresviewer.statusCode == 400) {
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
    return presviewerList.toList();
  }
}

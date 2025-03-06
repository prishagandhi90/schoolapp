import 'dart:convert';

import 'package:dio/dio.dart' as dio_package;
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/lab_report_model.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class LabReportsController extends GetxController {
  final count = 0.obs;
  bool apiCall = false;
  List commonList = [];
  List<ReportsAllData> labReportsList = [];
  List<ReportListData> allReportsList = [];
  List dataContain = [];
  List allDatesList = [];
  void increment() => count.value++;
  final ScrollController scrollController1 = ScrollController();
  final ScrollController allscrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  ScrollController scrollControllerx = ScrollController();
  List<ScrollController> scrollController3 = [];
  final ScrollController scrollController4 = ScrollController();
  bool _isUpdatingScrollPosition = false;
  var bottomBarController = Get.put(BottomBarController());
  bool scroll1 = false;
  bool scroll2 = false;
  bool scroll3 = false;
  bool showSwipe = false;

  void _syncScroll() {
    if (scrollController1.hasClients && scrollController2.hasClients) {
      if (scrollController1.offset != scrollController2.offset) {
        scrollController2.jumpTo(scrollController1.offset);
      }
    }

    if (scrollController1.hasClients && scrollControllerx.hasClients) {
      if (scrollController1.offset != scrollControllerx.offset) {
        scrollControllerx.jumpTo(scrollController1.offset);
      }
    }
  }

  void syncScroll3() {
    if (scrollControllerx.hasClients && scrollController2.hasClients) {
      if (scrollControllerx.offset != scrollController2.offset) {
        scrollController2.jumpTo(scrollControllerx.offset);
      }
    }

    if (scrollControllerx.hasClients && scrollController1.hasClients) {
      if (scrollController1.offset != scrollController1.offset) {
        scrollController1.jumpTo(scrollControllerx.offset);
      }
    }
  }

  void _syncScroll2() {
    if (scrollController2.hasClients && scrollController1.hasClients) {
      if (scrollController2.offset != scrollController1.offset) {
        scrollController1.jumpTo(scrollController2.offset);
      }
    }
    if (scrollController2.hasClients && scrollControllerx.hasClients) {
      if (scrollController2.offset != scrollControllerx.offset) {
        scrollControllerx.jumpTo(scrollController2.offset);
      }
    }
  }

  scrollLister() {
    allscrollController.addListener(() {
      if (allscrollController.position.userScrollDirection == ScrollDirection.forward) {
        hideBottomBar = false.obs;
        update();
        bottomBarController.update();
      } else if (allscrollController.position.userScrollDirection == ScrollDirection.reverse) {
        hideBottomBar = true.obs;
        update();
        bottomBarController.update();
      }
    });
  }

  addScrollMultiple() {
    scroll1 = false;
    scroll2 = false;
    scroll3 = true;
    for (int i = 0; i < allDatesList.length; i++) {
      final controller = ScrollController();
      controller.addListener(() {
        if (!_isUpdatingScrollPosition) {
          _isUpdatingScrollPosition = true;
          for (var otherController in scrollController3) {
            if (otherController != controller && otherController.hasClients) {
              otherController.jumpTo(controller.offset);
              scrollController1.jumpTo(controller.offset);
            }
          }
          _isUpdatingScrollPosition = false;
        }
      });
      scrollController3.add(controller);
    }
  }

  getLabReporst({required String ipdNo, required String uhidNo, bool isLoader = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(AppString.keyToken) ?? '';
    String loginId = prefs.getString(AppString.keyLoginId) ?? '';
    Map data = {"loginId": loginId, "ipdNo": ipdNo, "uhid": uhidNo};
    apiCall = true;
    String apiUrl = ConstApiUrl.getLabReports;
    dio_package.Response finalData = await ApiController.postMethodWithHeaderDioMapData(
        body: data, apiUrl: apiUrl, token: token, isShowLoader: isLoader);
    if (finalData.statusCode == 200) {
      var responseData = jsonDecode(finalData.data);

      commonList = responseData['data']['Data'];
      scrollController1.addListener(_syncScroll);
      scrollController2.addListener(_syncScroll2);
      apiCall = false;
      update();
    } else if (finalData.statusCode == 401) {
      prefs.clear();
      Get.offAll(const LoginScreen());
      Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
    } else if (finalData.statusCode == 400) {
      apiCall = false;
    } else {
      apiCall = false;
      Get.rawSnackbar(message: "Something went wrong");
    }
    update();
  }

  getKey1(List data) {
    List alldates = [];
    List alldates1 = [];
    for (var response in data) {
      response.forEach((key, value) {
        if (key == "formattest" || key == "TestName" || key == "NormalRange" || key == "Unit" || key == 'RowNo') {
        } else {
          if (alldates.contains("${key.toString().split(' ')[0]}-${key.toString().split(' ')[1]}")) {
          } else {
            Get.log("key.toString() ${key.toString()}");
            alldates.add("${key.toString().split(' ')[0]}-${key.toString().split(' ')[1]}");
            alldates1.add(key.toString());
          }
        }
      });
    }
    return alldates1;
  }

  getHeightOfWidget(String text1, String text2, List alldata, List datesListing, int index) {
    // print((text1.length + text2.length));
    // if ((text1.length + text2.length) > 14) {
    //   return getDynamicHeight(size: 0.125);
    // } else {
    for (int i = 0; i < alldata.length; i++) {
      if (index == i) {
        for (int j = 0; j < datesListing.length; j++) {
          if (alldata[i][datesListing[j]].toString().length > 70) {
            return getDynamicHeight(size: 0.350);
          } else if (alldata[i][datesListing[j]].toString().length > 50) {
            return getDynamicHeight(size: 0.250);
          } else if (alldata[i][datesListing[j]].toString().length > 25) {
            return getDynamicHeight(size: 0.175);
          } else if (alldata[i][datesListing[j]].toString().length > 14) {
            return getDynamicHeight(size: 0.125);
          } else {
            if ((text1.length + text2.length) > 14) {
              return getDynamicHeight(size: 0.125);
            } else if (alldata[i]["TestName"].toString().length > 25) {
              return getDynamicHeight(size: 0.10);
            }
          }
        }
      }
    }
    return getDynamicHeight(size: 0.055);
  }
}

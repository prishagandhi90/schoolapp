import 'dart:convert';
import 'package:emp_app/app/app_custom_widget/common_elevated_button.dart';
import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/pharmacy/model/pharmafilter_model.dart';
import 'package:emp_app/app/moduls/pharmacy/model/presdetail_model.dart';
import 'package:emp_app/app/moduls/pharmacy/model/presviewer_model.dart';
import 'package:emp_app/app/moduls/pharmacy/widgets/bed_checkbox.dart';
import 'package:emp_app/app/moduls/pharmacy/widgets/floor_checkbox.dart';
import 'package:emp_app/app/moduls/pharmacy/widgets/ward_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyController extends GetxController {
  bool isLoading = true;
  String tokenNo = '', loginId = '', empId = '';
  final ApiController apiController = Get.put(ApiController());
  final bottomBarController = Get.put(BottomBarController());
  final TextEditingController searchController = TextEditingController();
  List<PresviewerList> presviewerList = [];
  List<PresdetailList> presdetailList = [];
  int SelectedIndex = -1;
  List<bool> blurState = []; // Track blur states for each row
  List<Wards> wards = [];
  List<Floors> floors = [];
  List<Beds> beds = [];
  List<String> selectedWardList = [];
  List<String> selectedFloorList = [];
  List<String> selectedBedList = [];
  bool callFilterAPi = false;
  List<String> tempWardList = [];
  List<String> tempFloorsList = [];
  List<String> tempBedList = [];
  @override
  void onInit() {
    super.onInit();
    fetchpresViewer(searchController.text);
    GetPharmaFilterData();
  }

  void toggleBlur(int index) {
    blurState[index] = !blurState[index];
    update();
  }

  Future<List<PresviewerList>> fetchpresViewer(String? searchPrefix) async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empPresViewerListAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "prefixText": searchPrefix ?? '',
        "wards": selectedWardList,
        "floors": selectedFloorList,
        "beds": selectedBedList
      };

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

  Future<List<PresdetailList>> fetchpresDetailList(String Mst_Id) async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empPresDetailListAPI;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "mstId": Mst_Id};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Rsponsedrpresdetail rsponsedrpresdetail = Rsponsedrpresdetail.fromJson(jsonDecode(response));

      if (rsponsedrpresdetail.statusCode == 200) {
        presdetailList.clear();
        presdetailList.assignAll(rsponsedrpresdetail.data ?? []);
        blurState = List.generate(presdetailList.length, (index) => false);
        isLoading = false;
      } else if (rsponsedrpresdetail.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedrpresdetail.statusCode == 400) {
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

  Future<List<PresdetailList>> GetPharmaFilterData() async {
    try {
      isLoading = true;
      String url = ConstApiUrl.empPharmaFilterDataApi;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      pharmaFilterModel PharmaFilterModel = pharmaFilterModel.fromJson(jsonDecode(response));

      if (PharmaFilterModel.statusCode == 200) {
        if (PharmaFilterModel.data != null) {
          wards = PharmaFilterModel.data!.wards ?? [];
          floors = PharmaFilterModel.data!.floors ?? [];
          beds = PharmaFilterModel.data!.beds ?? [];
        }
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
    return [];
  }

  Future<void> pharmacyFiltterBottomSheet() async {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: GetBuilder<PharmacyController>(builder: (controller) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.crossLength * 0.020),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Sizes.crossLength * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Filter by',
                            style: TextStyle(
                              fontSize: Sizes.px20,
                              color: AppColor.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.cancel),
                          )
                          // GestureDetector(
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //     },
                          //     child: SvgPicture.asset(ConstAsset.closeIcon))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Sizes.crossLength * 0.025,
                              ),
                              AppText(
                                text: 'Wards',
                                fontSize: Sizes.px15,
                                fontColor: AppColor.black,
                                fontWeight: FontWeight.w800,
                              ),
                              SizedBox(
                                height: Sizes.crossLength * 0.010,
                              ),
                              WardsCheckBoxes(controller: controller),
                              SizedBox(
                                height: Sizes.crossLength * 0.015,
                              ),
                              AppText(
                                text: 'Floor',
                                fontSize: Sizes.px15,
                                fontColor: AppColor.black,
                                fontWeight: FontWeight.w800,
                              ),
                              SizedBox(
                                height: Sizes.crossLength * 0.010,
                              ),
                              FloorsCheckBoxes(controller: controller),
                              SizedBox(
                                height: Sizes.crossLength * 0.015,
                              ),
                              AppText(
                                text: 'Ward',
                                fontSize: Sizes.px15,
                                fontColor: AppColor.black,
                                fontWeight: FontWeight.w800,
                              ),
                              SizedBox(
                                height: getDynamicHeight(size: 0.010),
                              ),
                              BedsCheckBoxes(controller: controller),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: getDynamicHeight(size: 0.050),
                              child: AppButton(
                                  radius: 50,
                                  text: 'Apply',
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    callFilterAPi = true;
                                    if (selectedWardList.isNotEmpty || selectedFloorList.isNotEmpty || selectedBedList.isNotEmpty) {
                                      Navigator.pop(context);
                                      // getFilterData();
                                    } else {
                                      Get.rawSnackbar(message: "Please select options to short");
                                    }
                                  }),
                            )),
                            SizedBox(
                              width: getDynamicHeight(size: 0.020),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: getDynamicHeight(size: 0.050),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    // padding: const EdgeInsets.only(top: 1),
                                    backgroundColor: AppColor.white,
                                    side: BorderSide(width: 1.0, color: AppColor.black),
                                  ),
                                  onPressed: () {
                                    callFilterAPi = true;
                                    FocusScope.of(context).unfocus();
                                    selectedWardList = [];
                                    selectedFloorList = [];
                                    selectedBedList = [];
                                    fetchpresViewer(searchController.text);
                                    Navigator.pop(context);
                                    controller.update();
                                  },
                                  child: AppText(
                                    text: 'Reset All',
                                    fontSize: Sizes.px16,
                                    fontWeight: FontWeight.w500,
                                    fontColor: AppColor.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getDynamicHeight(size: 0.025),
                      ),
                    ],
                  ),
                );
              }),
            )).whenComplete(() {
      if (!callFilterAPi) {
        fetchpresViewer(searchController.text);
        selectedWardList = List.from(tempWardList);
        selectedFloorList = List.from(tempFloorsList);
        selectedBedList = List.from(tempBedList);
        update();
      }
    });
  }
}

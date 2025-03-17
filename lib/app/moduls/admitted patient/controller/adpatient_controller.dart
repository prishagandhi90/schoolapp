import 'dart:convert';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientsummary_labdata_model.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/floor_checkbox.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/organization_checkbox.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/ward_checkbox.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/adpatientfilter_model.dart';

class AdpatientController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String tokenNo = '', loginId = '', empId = '';
  String ipdNo = '', uhid = '';
  final ApiController apiController = Get.put(ApiController());
  // List<PatientdataModel> patientdata = [];
  List<PatientdataModel> patientsData = [];
  List<LabData> labdata = [];
  List<filterpatientModel> filterdata = [];
  List<String> selectedorgsList = [];
  List<String> selectedFloorsList = [];
  List<String> selectedwardsList = [];
  bool callFilterAPi = false;
  List<Orgs> orgsList = [];
  List<Floors> floorsList = [];
  List<Wards> wardList = [];
  List<String> tempOrgsList = [];
  List<String> tempFloorsList = [];
  List<String> tempWardList = [];
  final ScrollController verticalScrollControllerLeft = ScrollController();
  final ScrollController verticalScrollControllerRight = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  late final String date1, date2, date3, date4, date5, date6, date7;

  @override
  void onInit() {
    super.onInit();
    // generateLast7Days();
    _syncScrollControllers();
    fetchDeptwisePatientList();
    getPatientDashboardFilters();
    // fetchsummarylabdata();
  }

  // final List<Map<String, dynamic>> patientData = [
  //   {"title": "Admitted Patients", "count": 10},
  // ];

  // final List<PatientdataModel> patients = [
  //   PatientdataModel(
  //       isValidToken: "Y",
  //       patientCategory: "Admitted",
  //       uhid: "U/45832/17",
  //       ipdNo: "A/10799/24",
  //       patientName: "CHETANKUMAR MANSUKHLAL CHITRODA",
  //       bedNo: "E/AC -1-C",
  //       ward: "ECONOMY AC",
  //       floor: "2",
  //       doa: "02/03/2025",
  //       admType: "Cash",
  //       totalDays: "4",
  //       referredDr: "",
  //       mobileNo: "8866759082"),
  //   PatientdataModel(
  //       isValidToken: "Y",
  //       patientCategory: "Admitted",
  //       uhid: "U/115404/17",
  //       ipdNo: "A/10752/24",
  //       patientName: "CHUNIBHAI LAXMANBHAI CHOTHANI",
  //       bedNo: "E/AC -1-D",
  //       ward: "ECONOMY AC",
  //       floor: "2",
  //       doa: "01/03/2025",
  //       admType: "PMJAY",
  //       totalDays: "5",
  //       referredDr: "",
  //       mobileNo: "7567765472"),
  //   PatientdataModel(
  //       isValidToken: "Y",
  //       patientCategory: "Admitted",
  //       uhid: "U/115447/17",
  //       ipdNo: "A/10791/24",
  //       patientName: "VASANTBHAI JADAVBHAI GAJERA",
  //       bedNo: "ICCU-9",
  //       ward: "ICCU",
  //       floor: "3",
  //       doa: "02/03/2025",
  //       admType: "PMJAY",
  //       totalDays: "4",
  //       referredDr: "",
  //       mobileNo: "9879180316"),
  //   PatientdataModel(
  //       isValidToken: "Y",
  //       patientCategory: "Admitted",
  //       uhid: "U/115271/17",
  //       ipdNo: "A/10672/24",
  //       patientName: "SUSHILABEN MANHARBHAI VAGHANI",
  //       bedNo: "CT SICU-4",
  //       ward: "CT SICU",
  //       floor: "3",
  //       doa: "26/02/2025",
  //       admType: "Cashless",
  //       totalDays: "8",
  //       referredDr: "",
  //       mobileNo: "9998199387"),
  //   PatientdataModel(
  //       isValidToken: "Y",
  //       patientCategory: "Admitted",
  //       uhid: "U/115429/17",
  //       ipdNo: "A/10789/24",
  //       patientName: "ARVINDBHAI KALUBHAI KHERALA",
  //       bedNo: "MICU-20",
  //       ward: "MICU",
  //       floor: "4",
  //       doa: "02/03/2025",
  //       admType: "PMJAY",
  //       totalDays: "4",
  //       referredDr: "",
  //       mobileNo: "8140690545")
  // ];

  List<List<String>> data = [
    ["Hemoglobin", "13–18", "12", "12.8", "13.5", "12", "11.5"],
    ["RBC count", "4.5–6", "4.3", "4.6", "4.7", "4.3", "4.1"],
    ["P.C.V", "40–57", "40.5", "42", "50", "40.5", "41"],
    ["Hemoglobin", "13–18", "40.5", "42", "50", "40.5", "41"],
    ["RBC count", "4.5–6", "40.5", "42", "50", "40.5", "41"],
    ["P.C.V", "40–57", "40.5", "42", "50", "40.5", "41"],
  ];

  // Generate last 7 days dynamically
  // List<String> last7Days() {
  //   DateTime today = DateTime.now();
  //   return List.generate(7, (index) {
  //     return DateFormat('dd-MM-yyyy').format(today.subtract(Duration(days: index)));
  //   }); // Reverse to show oldest first
  // }

  // void generateLast7Days() {
  //   List<String> dates = last7Days(); // Get list of last 7 days

  //   // Store each date in respective variable
  //   date1 = dates[0];
  //   date2 = dates[1];
  //   date3 = dates[2];
  //   date4 = dates[3];
  //   date5 = dates[4];
  //   date6 = dates[5];
  //   date7 = dates[6];
  // }

  final List<String> menuItems = ["View", "Edit", "Delete"];

  List<String> headers = ["Test Name", "Ref.", "12 Feb", "11 Feb", "9 Feb", "8 Feb", "7 Feb"];

  void _syncScrollControllers() {
    verticalScrollControllerLeft.addListener(() {
      if (verticalScrollControllerRight.hasClients && verticalScrollControllerRight.offset != verticalScrollControllerLeft.offset) {
        verticalScrollControllerRight.jumpTo(verticalScrollControllerLeft.offset);
      }
    });

    verticalScrollControllerRight.addListener(() {
      if (verticalScrollControllerLeft.hasClients && verticalScrollControllerLeft.offset != verticalScrollControllerRight.offset) {
        verticalScrollControllerLeft.jumpTo(verticalScrollControllerRight.offset);
      }
    });
  }

  @override
  void onClose() {
    verticalScrollControllerLeft.dispose();
    verticalScrollControllerRight.dispose();
    horizontalScrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<List<PatientdataModel>> fetchDeptwisePatientList() async {
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empfilterpatientdataList;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "prefixText": "",
        "orgs": selectedorgsList,
        "floors": selectedFloorsList,
        "wards": selectedwardsList
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Rsponsedpatientdata rsponsedpatientdata = Rsponsedpatientdata.fromJson(jsonDecode(response));

      if (rsponsedpatientdata.statusCode == 200) {
        patientsData.assignAll(rsponsedpatientdata.data ?? []);
        isLoading = false;
      } else if (rsponsedpatientdata.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsedpatientdata.statusCode == 400) {
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

  getPatientDashboardFilters({bool isLoader = true}) async {
    try {
      isLoading = true;
      String url = ConstApiUrl.patientDashboardFilters;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      AdpatientFilterModel patientFilterModel = AdpatientFilterModel.fromJson(jsonDecode(response));

      if (patientFilterModel.statusCode == 200) {
        if (patientFilterModel.data != null) {
          wardList = patientFilterModel.data!.wards ?? [];
          floorsList = patientFilterModel.data!.floors ?? [];
          orgsList = patientFilterModel.data!.orgs ?? [];
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

  Future<List<LabData>> fetchsummarylabdata({bool isLoader = true}) async {
    try {
      isLoading = true;
      update();
      String url = ConstApiUrl.empPatientSummaryLabData;
      SharedPreferences pref = await SharedPreferences.getInstance();
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "ipdNo": "A/3761/24", "uhid": "U/74859/17"};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RsponsePatientlabsummarydata rsponsePatientlabsummarydata = RsponsePatientlabsummarydata.fromJson(jsonDecode(response));

      if (rsponsePatientlabsummarydata.statusCode == 200) {
        labdata.clear();
        labdata.assignAll(rsponsePatientlabsummarydata.data?.labData ?? []);
        isLoading = false;
      } else if (rsponsePatientlabsummarydata.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (rsponsePatientlabsummarydata.statusCode == 400) {
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

  Future<void> AdpatientFiltterBottomSheet() async {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        backgroundColor: AppColor.transparent,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: GetBuilder<AdpatientController>(builder: (controller) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            AppString.filterby,
                            style: TextStyle(
                              // fontSize: 25,
                              fontSize: getDynamicHeight(size: 0.027),
                              color: AppColor.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.cancel),
                          )
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                AppString.selectWardsName,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              organizationCheckBoxes(controller: controller),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                AppString.floor,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              floorCheckBox(controller: controller),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                AppString.selectbed,
                                style: TextStyle(
                                  // fontSize: 20,
                                  fontSize: getDynamicHeight(size: 0.022),
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              WardsCheckBox(controller: controller),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: AppColor.primaryColor),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    callFilterAPi = true;
                                    if (selectedorgsList.isNotEmpty || selectedFloorsList.isNotEmpty || selectedwardsList.isNotEmpty) {
                                      Navigator.pop(context);
                                      await fetchDeptwisePatientList();
                                    } else {
                                      Get.rawSnackbar(message: AppString.plzselectoptiontosort);
                                    }
                                  },
                                  child: Text(
                                    AppString.apply,
                                    style: TextStyle(
                                      color: AppColor.white,
                                      // fontSize: 15,
                                      fontSize: getDynamicHeight(size: 0.017),
                                    ),
                                  )),
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        backgroundColor: AppColor.primaryColor),
                                    onPressed: () async {
                                      callFilterAPi = true;
                                      FocusScope.of(context).unfocus();
                                      selectedorgsList = [];
                                      selectedFloorsList = [];
                                      selectedwardsList = [];
                                      await fetchDeptwisePatientList();
                                      Navigator.pop(context);
                                      controller.update();
                                    },
                                    child: Text(
                                      AppString.resetall,
                                      style: TextStyle(
                                        // fontSize: 16,
                                        fontSize: getDynamicHeight(size: 0.018),
                                        color: AppColor.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                );
              }),
            )).whenComplete(() {
      if (!callFilterAPi) {
        fetchDeptwisePatientList();
        selectedorgsList = List.from(tempOrgsList);
        selectedFloorsList = List.from(tempFloorsList);
        selectedwardsList = List.from(tempWardList);
        update();
      }
    });
  }
}

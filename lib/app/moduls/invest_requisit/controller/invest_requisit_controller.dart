import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/externallab_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/gethistory_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/getquerylist_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/requestsheetdetail_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/save_selsrv_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/selreqhistorydetail_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/servicegrp_model.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestRequisitController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final typeController = TextEditingController();
  final priorityController = TextEditingController();
  final InExController = TextEditingController();
  final serviceGroupController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  final ApiController apiController = Get.put(ApiController());
  String tokenNo = '', loginId = '', empId = '', ipdNo = '';
  bool isLoading = false;
  var externalLab = <ExternallabModel>[].obs;
  var serviceGroup = <ServicegrpModel>[].obs;
  var searchService = <SearchserviceModel>[].obs;
  var getQueryList = <GetquerylistModel>[].obs;
  var gethistoryList = <GethistoryModelList>[].obs;
  var selReqHistoryDetailList = <SelReqHistoryDetailModel>[].obs;
  Timer? debounce;
  List<RequestSheetDetailsIPD> selectedServices = [];
  final List<int> topOptions = [10, 20, 30, 40];
  int selectedTop = 10;
  @override
  void onInit() {
    fetchExternalLab();
    fetchServiceGroup();
    focusNode.addListener(() {
      hasFocus = focusNode.hasFocus;
      update();
    });
    super.onInit();
  }

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
        screenName: "InvestRequisit",
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
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return serviceGroup.toList();
  }

  Future<List<SearchserviceModel>> fetchSearchService(String flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empSearchServiceAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "flag": flag};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSearchService responseSearchService = ResponseSearchService.fromJson(jsonDecode(response));

      if (responseSearchService.statusCode == 200) {
        // searchService.clear();
        searchService.assignAll(responseSearchService.data ?? []);
        isLoading = false;
      } else if (responseSearchService.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (responseSearchService.statusCode == 400) {
        isLoading = false;
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: pref.getString(AppString.keyLoginId) ?? '',
        tokenNo: pref.getString(AppString.keyToken) ?? '',
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return searchService.toList();
  }

  // Controller me:
  String patientName = '';

  void setPatientName(String name) {
    patientName = name.trim();
    update(); // this will rebuild widgets using GetBuilder
  }

  // final TextEditingController controller = TextEditingController();
  List<SearchserviceModel> suggestions = [];

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) return;
    List<SearchserviceModel> results = await fetchSearchService(query);

    suggestions = results;
    update();
  }

  Future<List<GetquerylistModel>> fetchGetQueryList(String ipdNo, {String searchText = ""}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update(); // show loader if any

      String url = ConstApiUrl.empGetQueryListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "type": "IR_TOP_SRVC_LIST",
        "top10_40": selectedTop.toString(),
        "ipd": ipdNo,
        "srchService": searchText,
        "invType": "LAB",
        "srvGrp": "",
        "extLabNm": "",
        "val7": ""
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseGetQueryList responseGetQueryList = ResponseGetQueryList.fromJson(jsonDecode(response));
      if (responseGetQueryList.statusCode == 200) {
        getQueryList.assignAll(responseGetQueryList.data ?? []);
      } else if (responseGetQueryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired, login again.');
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
    }
    isLoading = false;
    update();
    return getQueryList;
  }

  Future<void> searchservice(String query, String ipdNo) async {
    await fetchGetQueryList(ipdNo, searchText: query);
  }

  void onSearchChanged(String query, String ipdNo) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(Duration(milliseconds: 500), () {
      searchservice(query, ipdNo);
    });
  }

  Future<void> changeTop(int top) async {
    selectedTop = top;
    await fetchGetQueryList(ipdNo);
    update();
  }

  Future<void> addService(GetquerylistModel service) async {
    final isAlreadyAdded = selectedServices.any((item) => item.serviceId.toString() == service.id.toString());

    if (!isAlreadyAdded) {
      selectedServices.add(
        RequestSheetDetailsIPD(
          mReqId: 0,
          serviceName: service.name ?? '',
          serviceId: int.tryParse(service.id.toString()) ?? 0,
          username: 'manans', // Replace with real user
          invSrc: "INTERNAL",
          reqTyp: "labRequest",
          uhidNo: "",
          ipdNo: ipdNo,
          drId: 0,
          drName: "", // Replace with actual doctor
          drInstId: 0,
          billDetailId: 0,
          rowState: 1,
          action: "Insert",
        ),
      );
      update();
    } else {
      Get.snackbar(
        'Notice',
        'Service already added',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    }
  }

  Future<void> saveSelectedServiceList(String ipdNo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update(); // show loader if any

      String url = ConstApiUrl.empSaveSelSrvListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      var jsonbodyObj = {
        "request": {},
        // "loginId": loginId,
        // "empId": empId,
        "uhidNo": "U/119225/17",
        "ipdNo": ipdNo,
        "reqType": "labRequest",
        "remark": "",
        "username": "manans",
        "dt": "2025-05-21T11:40:23.182Z",
        "action": "insert",
        "isEmergency": "",
        "clinicRemark": "bvbcvbcv",
        "investPriority": "NORMAL",
        "reqId": 0,
        "dr_Inst_Id": 0,
        "bill_Detail_Id": 0,
        "labDetail": selectedServices
            .map<Map<String, dynamic>>((service) => {
                  "MReqId": service.mReqId,
                  "ServiceName": service.serviceName,
                  "ServiceId": service.serviceId,
                  "Username": service.username,
                  "InvSrc": service.invSrc,
                  "ReqTyp": service.reqTyp,
                  "RowState": 1,
                  "Action": service.action,
                  "Dr_Inst_Id": service.drInstId,
                  "Bill_Detail_Id": service.billDetailId,
                  "UHIDNo": service.uhidNo,
                  "IPDNo": ipdNo,
                  "DrID": service.drId,
                  "DrNAME": service.drName,
                })
            .toList(),
        "radioDetail": [],
        "otherDetail": [],
        "rowState": 1,
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSaveSelSrvList responseSaveSelSrvList = ResponseSaveSelSrvList.fromJson(jsonDecode(response));
      if (responseSaveSelSrvList.status == "success") {
        print("Service saved successfully");
        Get.snackbar(
          'Success',
          'Service saved successfully',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
    }
    isLoading = false;
    update();
  }

  Future<List<GethistoryModelList>> fetchGetHistoryList(String ipdNo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update(); // show loader if any

      String url = ConstApiUrl.empGetHistoryListAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "type": "IR_TOP_SRVC_LIST",
        "top10_40": ipdNo,
        "ipd": "",
        "srchService": "",
        "invType": "LAB",
        "srvGrp": "",
        "extLabNm": "",
        "val7": ""
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseGetHistoryList responseGetHistoryList = ResponseGetHistoryList.fromJson(jsonDecode(response));
      if (responseGetHistoryList.statusCode == 200) {
        gethistoryList.assignAll(responseGetHistoryList.data ?? []);
      } else if (responseGetHistoryList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired, login again.');
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
    }
    isLoading = false;
    update();
    return gethistoryList;
  }

  Future<List<SelReqHistoryDetailModel>> SelReqqHistoryDetailList(int requisitionNo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update(); // show loader if any

      String url = ConstApiUrl.empSelReqHistoryDetailAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "empId": empId,
        "type": "IR_TOP_SRVC_LIST",
        "top10_40": requisitionNo.toString(),
        "ipd": "",
        "srchService": "",
        "invType": "",
        "srvGrp": "",
        "extLabNm": "",
        "val7": ""
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseSelReqHistoryDetailList responseSelReqHistoryDetailList = ResponseSelReqHistoryDetailList.fromJson(jsonDecode(response));
      if (responseSelReqHistoryDetailList.statusCode == 200) {
        selReqHistoryDetailList.assignAll(responseSelReqHistoryDetailList.data ?? []);
      } else if (responseSelReqHistoryDetailList.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired, login again.');
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
    }
    isLoading = false;
    update();
    return selReqHistoryDetailList;
  }

  Future<void> HistoryBottomSheet() async {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColor.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: GetBuilder<InvestRequisitController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 24), // For alignment
                          Text(
                            'Investigation History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.cancel, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: CustomDropdown(
                        text: 'Select',
                        buttonStyleData: ButtonStyleData(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                        controller: controller.typeController,
                        items: [
                          {'value': '', 'text': 'Select'},
                          {'value': 'Lab', 'text': 'LAB'},
                          {'value': 'Radio', 'text': 'Radio'},
                          {'value': 'Other Investigation', 'text': 'OTHER INVESTIGATION'},
                        ].map((item) {
                          return DropdownMenuItem<Map<String, String>>(
                            value: item,
                            child: Text(item['text'] ?? '', style: TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          controller.typeController.text = val?['text'] ?? '';
                          controller.update();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // History List
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemCount: controller.gethistoryList.length,
                        itemBuilder: (context, index) {
                          final item = controller.gethistoryList[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Req No and menu icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Req No: ${item.requisitionNo}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          // Call the function to show history detail dialog
                                          List<SelReqHistoryDetailModel> list = await SelReqqHistoryDetailList(item.requisitionNo ?? 0);

                                          // 2. Show dialog with data
                                          showSimpleInvestigationDialog(context, list);
                                        },
                                        icon: Icon(Icons.menu, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    item.entryDate.toString(), // e.g. 27/04/2025 04:14 PM
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                  SizedBox(height: 6),
                                  // Type label
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.teal),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item.investigationType.toString(), // e.g. LAB / Radio / Other Investigation
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        item.user.toString(),
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10), // spacing before bottom buttons

                    /// 🟩 Bottom Buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// 🟥 Only Cancel Button (1/3 Width)
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text('Cancel'),
                            ),
                          ),

                          /// 🟦 Empty space jahan pe pehle dusre buttons the (2/3 width)
                          Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // void otherInvestDialog(BuildContext context, String serviceName) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Stack(
  //             children: [
  //               Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const SizedBox(height: 10),
  //                   const Text(
  //                     'Service',
  //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Text(
  //                     serviceName,
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   TextField(
  //                     controller: searchController,
  //                     decoration: InputDecoration(
  //                       hintText: "Type To Search Dr Name...",
  //                       filled: true,
  //                       fillColor: Colors.grey[100],
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.teal, // Button color
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                       // Aap yahan searchController.text use kar sakte ho
  //                     },
  //                     child: const Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                       child: Text("OK"),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Positioned(
  //                 right: 0,
  //                 top: 0,
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Icon(Icons.close),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> showSimpleInvestigationDialog(BuildContext context, List<SelReqHistoryDetailModel> dataList) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColor.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Investigation History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...dataList.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.serviceName.toString()),
                                  Text(item.reqTyp.toString(), style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.status == 'Verified' ? Colors.green.shade100 : Colors.yellow.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(item.status.toString()),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.delete, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green.shade200;
      case 'pending':
        return Colors.yellow.shade200;
      default:
        return Colors.grey.shade300;
    }
  }
}

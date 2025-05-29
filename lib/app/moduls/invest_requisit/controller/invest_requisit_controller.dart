import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_login_dialogbox.dart';
import 'package:emp_app/app/core/service/api_service.dart';
import 'package:emp_app/app/core/util/api_error_handler.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/const_api_url.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/dashboard/controller/dashboard_controller.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/externallab_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/gethistory_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/getquerylist_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/requestsheetdetail_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/resp_req_dtl_srv_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/save_selsrv_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/search_dr_nm_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/searchservice_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/selreqhistorydetail_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/servicegrp_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/model/webUserlogincred_model.dart';
import 'package:emp_app/app/moduls/invest_requisit/screen/invest_requisit_screen.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestRequisitController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController drNameController = TextEditingController();
  final TextEditingController drIdController = TextEditingController();
  final typeController = TextEditingController();
  final priorityController = TextEditingController();
  final InExController = TextEditingController();
  final ExternalLabController = TextEditingController();
  final serviceGroupController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = false;
  FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  final ApiController apiController = Get.put(ApiController());
  String tokenNo = '', loginId = '', empId = '', ipdNo = '', uhid = '', patientname = '';
  bool isLoading = false;
  var isPresViewerNavigating = false.obs;
  var externalLab = <ExternallabModel>[].obs;
  var serviceGroup = <ServicegrpModel>[].obs;
  var searchService = <SearchserviceModel>[].obs;
  var searchDrNm = <SearchDrNmModel>[].obs;
  var getQueryList = <GetquerylistModel>[].obs;
  var gethistoryList = <GethistoryModelList>[].obs;
  List<GethistoryModelList> filteredList = []; // Filtered list
  var selReqHistoryDetailList = <SelReqHistoryDetailModel>[].obs;
  var loginWebUserCreds = <LoginWebUserCreds>[].obs;
  Timer? debounce;
  List<RequestSheetDetailsIPD> selectedServices = [];
  final List<int> topOptions = [10, 20, 30, 40];
  int selectedTop = 10;
  String webUserName = '';
  bool fromAdmittedScreen = false;

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

  bool isNextButtonEnabled() {
    if ((ipdNo != null && ipdNo!.isNotEmpty) && (typeController.text != null && typeController.text!.isNotEmpty)) {
      if ((typeController.text.toLowerCase() == 'lab' ||
              typeController.text.toLowerCase() == 'radio' ||
              typeController.text.toLowerCase() == 'other investigation') &&
          InExController.text.toLowerCase() == 'internal') {
        return true;
      } else if (typeController.text.toLowerCase() == 'lab' && InExController.text.toLowerCase() == 'external') {
        if (ExternalLabController.text.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  bool isSaveButtonEnabled() {
    return selectedServices.isNotEmpty;
  }

  String getUHId(String patientName) {
    if (patientName.isEmpty) return "";

    List<String> parts = patientName.split('|');
    return parts.last.trim(); // last part with trimmed spaces
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

  Future<List<SearchDrNmModel>> fetchSearchDrNm(String searchText, String serviceId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empSearchDrnmAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "empId": empId, "searchText": searchText, "srv": serviceId};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      RespSearchDrNm respSearchDrNm = RespSearchDrNm.fromJson(jsonDecode(response));

      if (respSearchDrNm.statusCode == 200) {
        // searchService.clear();
        searchDrNm.assignAll(respSearchDrNm.data ?? []);
        isLoading = false;
      } else if (respSearchDrNm.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Your session has expired. Please log in again to continue');
      } else if (respSearchDrNm.statusCode == 400) {
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
    return searchDrNm.toList();
  }

  // Controller me:
  String patientName = '';

  void setPatientName(String name) {
    patientName = name.trim();
    update(); // this will rebuild widgets using GetBuilder
  }

  // final TextEditingController controller = TextEditingController();
  List<SearchserviceModel> suggestions = [];
  List<SearchDrNmModel> suggestions_DrNm = [];

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) return;
    List<SearchserviceModel> results = await fetchSearchService(query);

    suggestions = results;
    update();
  }

  Future<void> getDrNmSuggest(String query, String ServiceId) async {
    if (query.isEmpty) return;
    List<SearchDrNmModel> results = await fetchSearchDrNm(query, ServiceId);

    suggestions_DrNm = results;
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
        "invType": typeController.text.toLowerCase() == "other investigation" ? "OTHER" : typeController.text.toUpperCase(),
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

  bool isDuplicateService(String serviceId) {
    final isAlreadyAdded = selectedServices.any((item) => item.serviceId.toString() == serviceId);

    if (isAlreadyAdded) {
      return true;
    }
    return false;
  }

  Future<void> addService(GetquerylistModel service) async {
    final isAlreadyAdded = selectedServices.any((item) => item.serviceId.toString() == service.id.toString());

    if (!isAlreadyAdded) {
      selectedServices.add(
        RequestSheetDetailsIPD(
          mReqId: 0,
          serviceName: service.name ?? '',
          serviceId: int.tryParse(service.id.toString()) ?? 0,
          username: webUserName, // Replace with real user
          invSrc: InExController.text.toLowerCase() == "internal" ? "Internal" : "External",
          reqTyp: typeController.text.toString().toUpperCase() == "LAB"
              ? "LAB CHARGES"
              : (typeController.text.toUpperCase() == "RADIO" ? "RADIO CHARGES" : "OTHERINVESTIGATIONS"),
          uhidNo: uhid,
          ipdNo: ipdNo,
          drId: drIdController.text.trim() != null && drIdController.text.trim() != "" ? int.parse(drIdController.text.trim()) : 0,
          drName: drNameController.text.trim() != null && drNameController.text.trim() != ""
              ? drNameController.text.trim()
              : "", // Replace with actual doctor
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
        colorText: AppColor.black,
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
        // "loginId": loginId,
        // "empId": empId,
        "uhidNo": uhid,
        "ipdNo": ipdNo,
        "reqType": typeController.text.toLowerCase() == 'lab'
            ? "LabRequest"
            : (typeController.text.toLowerCase() == 'radio' ? "RadioRequest" : "ReportingRequest"),
        "remark": null,
        "username": webUserName,
        "dt": DateTime.now().toIso8601String(),
        "action": "insert",
        "isEmergency": null,
        "clinicRemark": null,
        "investPriority": "NORMAL",
        "reqId": 0,
        "dr_Inst_Id": 0,
        "bill_Detail_Id": 0,
        "labDetail": typeController.text.toLowerCase() == 'lab'
            ? selectedServices
                .map<Map<String, dynamic>>((service) => {
                      "mReqId": service.mReqId,
                      "serviceName": service.serviceName,
                      "serviceId": service.serviceId,
                      "username": service.username,
                      "invSrc": service.invSrc,
                      "reqTyp": service.reqTyp,
                      "rowState": 1,
                      "action": service.action,
                      "dr_Inst_Id": service.drInstId,
                      "bill_Detail_Id": service.billDetailId,
                      "uHIDNo": service.uhidNo,
                      "iPDNo": ipdNo,
                      "drID": service.drId,
                      "drNAME": service.drName,
                    })
                .toList()
            : [],
        "radioDetail": typeController.text.toLowerCase() == 'radio'
            ? selectedServices
                .map<Map<String, dynamic>>((service) => {
                      "mReqId": service.mReqId,
                      "serviceName": service.serviceName,
                      "serviceId": service.serviceId,
                      "username": service.username,
                      "invSrc": service.invSrc,
                      "reqTyp": service.reqTyp,
                      "rowState": 1,
                      "action": service.action,
                      "dr_Inst_Id": service.drInstId,
                      "bill_Detail_Id": service.billDetailId,
                      "uHIDNo": service.uhidNo,
                      "iPDNo": ipdNo,
                      "drID": service.drId,
                      "drNAME": service.drName,
                    })
                .toList()
            : [],
        "otherDetail": typeController.text.toLowerCase() == 'other investigation'
            ? selectedServices
                .map<Map<String, dynamic>>((service) => {
                      "mReqId": service.mReqId,
                      "serviceName": service.serviceName,
                      "serviceId": service.serviceId,
                      "username": service.username,
                      "invSrc": service.invSrc,
                      "reqTyp": service.reqTyp,
                      "rowState": 1,
                      "action": service.action,
                      "dr_Inst_Id": service.drInstId,
                      "bill_Detail_Id": service.billDetailId,
                      "uHIDNo": service.uhidNo,
                      "iPDNo": ipdNo,
                      "drID": service.drId,
                      "drNAME": service.drName,
                    })
                .toList()
            : [],
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
          colorText: AppColor.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
        selectedServices.clear();
      } else {
        Get.snackbar(
          'Error',
          jsonDecode(response)['message'].toString(),
          backgroundColor: Colors.green.shade100,
          colorText: AppColor.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
        );
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );
      isLoading = false;
      update();
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

  Future<void> Delete_ReqDtl_Srv(String reqDtlSrvId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      update(); // show loader if any

      String url = ConstApiUrl.empDelReqDtlSrvAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";
      empId = await pref.getString(AppString.keyEmpId) ?? "";

      var jsonbodyObj = {
        "loginId": loginId,
        "req_sht_dtl_id": reqDtlSrvId,
        "UserName": webUserName,
        "FormName": 'InvReq',
      };

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      Resp_DelReqDtlSrv_model resp_DelReqDtlSrv_model = Resp_DelReqDtlSrv_model.fromJson(jsonDecode(response));
      if (resp_DelReqDtlSrv_model.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Service deleted successfully',
          backgroundColor: Colors.green.shade100,
          colorText: AppColor.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
        // Refresh the history list after deletion
      } else if (resp_DelReqDtlSrv_model.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired, login again.');
      } else {
        Get.rawSnackbar(message: resp_DelReqDtlSrv_model.message ?? "Something went wrong");
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: empId,
      );

      Get.rawSnackbar(
        message: "Exception: ${e.toString()}",
        backgroundColor: Colors.red.shade100,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading = false;
    update();
  }

  void initHistoryFilter() {
    filteredList = gethistoryList;
    update();
  }

  void filterHistoryByType(String type) {
    if (type.isEmpty || type == 'Select') {
      filteredList = gethistoryList;
    } else {
      filteredList = gethistoryList.where((item) => item.investigationType?.toLowerCase() == type.toLowerCase()).toList();
    }
    update();
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
    initHistoryFilter();
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
                            AppString.investigationhistory,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColor.teal,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Future.delayed(Duration(milliseconds: 300), () {
                              //   FocusScope.of(context).unfocus();
                              // });
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.cancel, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: CustomDropdown(
                        text: AppString.select,
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
                          controller.filterHistoryByType(val?['text'] ?? '');
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
                        itemCount: controller.filteredList.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredList[index];
                          return Card(
                            color: AppColor.white,
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColor.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Req No and menu icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: AppString.reqno,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.black, // or any color you prefer for label
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${item.requisitionNo}',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          List<SelReqHistoryDetailModel> list = await SelReqqHistoryDetailList(item.requisitionNo ?? 0);
                                          InvestigationHistoryDialog(context, list);
                                        },
                                        icon: Icon(
                                          Icons.menu,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    item.entryDate.toString(), // e.g. 27/04/2025 04:14 PM
                                    style: TextStyle(fontSize: 12, color: AppColor.black),
                                  ),
                                  SizedBox(height: 6),
                                  // Type label
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColor.teal),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item.investigationType.toString(), // e.g. LAB / Radio / Other Investigation
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.teal,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        item.user.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                      child: SizedBox(
                        width: double.infinity, // Full width
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 167, 166, 166),
                            foregroundColor: AppColor.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            alignment: Alignment.center,
                          ),
                          child: Text(
                            controller.webUserName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: getDynamicHeight(size: 0.013),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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

  Future<void> InvestigationHistoryDialog(BuildContext context, List<SelReqHistoryDetailModel> dataList) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          titlePadding: const EdgeInsets.only(top: 10, left: 16, right: 8),
          title: Stack(
            children: [
              // Centered Title
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Text(
                    AppString.investigationhistory,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppColor.black,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Obx(
              () {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: dataList.asMap().entries.map(
                      (entry) {
                        int index = entry.key;
                        SelReqHistoryDetailModel item = entry.value;

                        return Padding(
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
                                      Text(item.serviceName.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(
                                        item.reqTyp.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
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
                                    InkWell(
                                      onTap: () {
                                        print('Delete pressed for item: ${item.serviceName}, index: $index');

                                        showDeleteReqSrv_Dialog(
                                          context, // current dialog context
                                          item.requestID ?? 0,
                                          item.id.toString(),
                                          index,
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: AppColor.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update(); // notify listeners
  }

  Future<void> loginAlertDialog(BuildContext context, String menuName, String patientDetails, String IPDNo, String UHID) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Disable dismiss on tap outside
      builder: (context) {
        return GetBuilder<InvestRequisitController>(builder: (controller) {
          return CustomLoginDialogBox(
            text: AppString.plzenteryourmobilenumberandpasstologin,
            hintText: AppString.mobilenumber,
            controller: mobileController,
            obscurePassword: obscurePassword,
            togglePasswordVisibility: togglePasswordVisibility,
            passwordHintText: AppString.password,
            passcontroller: passwordController,
            onLoginPressed: () async {
              bool isLoggedIn = await fetchWebUserLoginCreds(context);
              if (isLoggedIn) {
                Navigator.of(context).pop(); // Close dialog ONLY IF success
                await Future.delayed(const Duration(milliseconds: 300));

                if (menuName.toUpperCase() == 'INVESTIGATION REQUISITION') {
                  if (patientDetails.isNotEmpty && IPDNo.isNotEmpty) {
                    fromAdmittedScreen = true;
                    nameController.text = patientDetails;
                    ipdNo = IPDNo;
                    uhid = UHID;
                  } else {
                    fromAdmittedScreen = false;
                    nameController.text = '';
                    ipdNo = '';
                    uhid = '';
                  }

                  update();

                  PersistentNavBarNavigator.pushNewScreen(
                    Get.context!,
                    screen: InvestRequisitScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ).then((value) async {
                    final controller = Get.put(InvestRequisitController());
                    await controller.resetForm();
                    final bottomBarController = Get.find<BottomBarController>();
                    bottomBarController.currentIndex.value = 0;
                    bottomBarController.isIPDHome.value = true;
                    hideBottomBar.value = false;
                    var dashboardController = Get.put(DashboardController());
                    await dashboardController.getDashboardDataUsingToken();
                    return;
                  });
                } else if (menuName.toUpperCase() == 'INVESTIGATION HISTORY') {
                  await fetchGetHistoryList(IPDNo);
                  HistoryBottomSheet();
                }
              } else {
                Get.rawSnackbar(
                  message: "Login failed. Please check your credentials.",
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red.shade100,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            onTap: () {
              // mobileController.clear();
              // passwordController.clear();
              Navigator.of(context).pop(); // Close dialog on cancel
            },
          );
        });
      },
    );
  }

  Future<bool> fetchWebUserLoginCreds(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      isLoading = true;
      String url = ConstApiUrl.empWebUserLoginCredsAPI;
      loginId = await pref.getString(AppString.keyLoginId) ?? "";
      tokenNo = await pref.getString(AppString.keyToken) ?? "";

      var jsonbodyObj = {"loginId": loginId, "mobileNo": mobileController.text.trim(), "password": passwordController.text.trim()};

      var response = await apiController.parseJsonBody(url, tokenNo, jsonbodyObj);
      ResponseWebuselogin responseWebuselogin = ResponseWebuselogin.fromJson(jsonDecode(response));

      if (responseWebuselogin.statusCode == 200) {
        loginWebUserCreds.assignAll(responseWebuselogin.data ?? []);
        if (loginWebUserCreds.isNotEmpty && loginWebUserCreds.first.isValidCreds == 'True') {
          webUserName = loginWebUserCreds.first.webEmpName ?? '';

          Get.rawSnackbar(message: AppString.loginsuccessful);
          isLoading = false;
          update();

          return true;
        } else {
          Get.rawSnackbar(message: loginWebUserCreds.first.message ?? "Invalid credentials", duration: Duration(seconds: 10));
          isLoading = false;
          update();
          return false;
        }
      } else if (responseWebuselogin.statusCode == 401) {
        pref.clear();
        Get.offAll(const LoginScreen());
        Get.rawSnackbar(message: 'Session expired');
      } else {
        Get.rawSnackbar(message: "Something went wrong");
      }
    } catch (e) {
      ApiErrorHandler.handleError(
        screenName: "InvestRequisit",
        error: e.toString(),
        loginID: loginId,
        tokenNo: tokenNo,
        empID: pref.getString(AppString.keyEmpId) ?? '',
      );
    }
    isLoading = false;
    return false;
  }

  Future<void> otherInvestDialog(BuildContext context, GetquerylistModel serviceModel) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      AppString.service,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      serviceModel.name ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Autocomplete<SearchDrNmModel>(
                      displayStringForOption: (SearchDrNmModel option) => option.name ?? '',
                      optionsBuilder: (TextEditingValue textEditingValue) async {
                        await getDrNmSuggest(textEditingValue.text, serviceModel.id.toString());
                        return suggestions_DrNm;
                      },
                      onSelected: (SearchDrNmModel selection) {
                        print('Selected Dr Name: ${selection.name} (ID: ${selection.id})');
                        // controller.setPatientName(selection.txt ?? '');
                        drNameController.text = selection.name ?? '';
                        drIdController.text = selection.id != null ? selection.id.toString() : '';
                        update();
                      },
                      fieldViewBuilder: (context, drNameController, focusNode, onEditingComplete) {
                        return TextFormField(
                          controller: drNameController,
                          focusNode: focusNode,
                          minLines: 1,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              labelText: AppString.typetosearchdrname,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColor.black, width: 1.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColor.black,
                                ),
                              ),
                              prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: AppColor.black,
                                ),
                                onPressed: () {
                                  drNameController.text = '';
                                  drNameController.clear();
                                  drIdController.text = '';
                                  drIdController.clear();
                                  suggestions_DrNm.clear();
                                  update();
                                  // Future.delayed(Duration(milliseconds: 300), () {
                                  //   FocusScope.of(context).unfocus();
                                  // });
                                },
                              )),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.teal, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await addService(serviceModel);
                        Navigator.of(context).pop();
                        // Aap yahan searchController.text use kar sakte ho
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(AppString.ok),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteReqSrv_Dialog(BuildContext context, int reqDtlId, String reqDtlSrvId, int index) async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppString.logout),
          content: Text(AppString.areyousuretologout),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppString.no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(AppString.yes),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      // final OtpController otpController = Get.find();
      await Delete_ReqDtl_Srv(reqDtlSrvId);
      // Navigator.pop(context);
      selReqHistoryDetailList.removeAt(index);
      update();
      // List<SelReqHistoryDetailModel> list = await SelReqqHistoryDetailList(reqDtlId ?? 0);
      // InvestigationHistoryDialog(context, list);
    }
  }

  resetForm() {
    nameController.text = '';
    drNameController.text = '';
    drIdController.text = '';
    typeController.text = '--select--';
    priorityController.text = 'normal';
    InExController.text = 'Internal';
    ExternalLabController..text = '';
    serviceGroupController.clear();
    searchController.text = '';
    tokenNo = '';
    loginId = '';
    empId = '';
    ipdNo = '';
    isLoading = false;
    getQueryList.clear();
    selectedServices.clear();
    selectedTop = 20;
    fromAdmittedScreen = false;
    mobileController.clear();
    passwordController.clear();

    update();
  }
}

import 'dart:convert';
import 'package:emp_app/app/moduls/attendence/model/attendencetable_model.dart';
import 'package:emp_app/app/moduls/attendence/model/attpresenttable_model.dart';
import 'package:emp_app/app/core/model/dropdown_G_model.dart';
import 'package:emp_app/app/moduls/mispunch/model/mispunchtable_model.dart';
import 'package:emp_app/app/moduls/payroll/model/payroll_model.dart';
import 'package:emp_app/app/moduls/verifyotp/model/otp_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as diopackage;
import 'package:get/get.dart';

class ApiController extends GetxController {
  List<Dropdown_Glbl> ParseJson(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Dropdown_Glbl>((json) => Dropdown_Glbl.fromJson(json)).toList();
  }

  List<Dropdown_Glbl> parseJson_Flag_monthyr(String responseBody, String flag) {
    print(responseBody);
    final parsed = json.decode(responseBody)[flag].cast<Map<String, dynamic>>();
    return parsed.map<Dropdown_Glbl>((json) => Dropdown_Glbl.fromJson(json)).toList();
  }

  List<OTPModel> parseJson_Flag_otptable(String responseBody, String flag) {
    try {
      print(responseBody);
      final decodedResp = json.decode(responseBody)[flag];
      print(decodedResp);
      final parsed = decodedResp.length > 0 ? decodedResp?.cast<Map<String, dynamic>>() : [];

      return parsed.map<OTPModel>((json) => OTPModel.fromJson(json)).toList();
    } catch (e) {}

    return [];
  }

  List<MispunchTable> parseJson_Flag_Mispunch(String responseBody, String flag) {
    print(responseBody);
    final decodedResp = json.decode(responseBody)[flag];
    print(decodedResp);
    final parsed = decodedResp.length > 0 ? decodedResp?.cast<Map<String, dynamic>>() : [];
    // return parsed.map<MispunchTable>((json) => MispunchTable.fromJson(json)).toList();
    if (parsed != null && parsed.isNotEmpty) {
      return parsed.map<MispunchTable>((json) => MispunchTable.fromJson(json)).toList();
    } else {
      return [];
    }
    // return parsed.map<MispunchTable>((json) => MispunchTable.fromJson(json)).toList();
  }

  List<Payroll> parseJson_Flag_payroll(String responseBody, String flag) {
    print(responseBody);
    final decodedResp = json.decode(responseBody)[flag];
    print(decodedResp);
    final parsed = decodedResp.length > 0 ? decodedResp?.cast<Map<String, dynamic>>() : [];
    if (parsed != null && parsed.isNotEmpty) {
      return parsed.map<Payroll>((json) => Payroll.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  List<Attendencetable> parseJson_Flag_attendence(String responseBody, String flag) {
    print(responseBody);
    final decodedResp = json.decode(responseBody)[flag];
    print(decodedResp);
    final parsed = decodedResp.length > 0 ? decodedResp?.cast<Map<String, dynamic>>() : [];
    // return parsed.map<MispunchTable>((json) => MispunchTable.fromJson(json)).toList();
    if (parsed != null && parsed.isNotEmpty) {
      return parsed.map<Attendencetable>((json) => Attendencetable.fromJson(json)).toList();
    } else {
      return [];
    }
    // return parsed.map<MispunchTable>((json) => MispunchTable.fromJson(json)).toList();
  }

  List<AttPresentTable> parseJson_Flag_attprsnt(String responseBody, String flag) {
    print(responseBody);
    final decodedResp = json.decode(responseBody)[flag];
    print(decodedResp);
    final parsed = decodedResp.length > 0 ? decodedResp?.cast<Map<String, dynamic>>() : [];
    if (parsed != null && parsed.isNotEmpty) {
      return parsed.map<AttPresentTable>((json) => AttPresentTable.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Dropdown_Glbl>> getUserNames(String apiURL, String headerToken, Object jsonBodyObj) async {
    var headers;
    if (headerToken == '') {
      headers = {"Content-Type": "application/json"};
    } else {
      headers = {'Authorization': 'Bearer $headerToken', "Content-Type": "application/json"};
    }

    final body = jsonEncode(jsonBodyObj);
    final response = await http.post(Uri.parse(apiURL), headers: headers, body: body);

    if (response.statusCode == 200) {
      return ParseJson(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<String?> getDropdownData_NP(String apiURL, String headerToken, Object jsonBodyObj) async {
    var headers;
    if (headerToken == '') {
      headers = {"Content-Type": "application/json"};
    } else {
      headers = {'Authorization': 'Bearer $headerToken', "Content-Type": "application/json"};
    }
    final body = jsonEncode(jsonBodyObj);
    final response = await http.post(Uri.parse(apiURL), headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
      // var userNameList = json.decode(response.body);
      // var compId = userNameList["companyList"];
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<String> getDynamicData(String apiURL, String headerToken, Object jsonBodyObj) async {
    var headers;
    if (headerToken == '') {
      headers = {"Content-Type": "application/json"};
    } else {
      headers = {'Authorization': 'Bearer $headerToken', "Content-Type": "application/json"};
    }

    final body = jsonEncode(jsonBodyObj);
    final response = await http.post(Uri.parse(apiURL), headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
      // throw Exception('Unable to fetch products from the REST API');
    }
  }

  static dynamic postWithDioForlogin(String url, var body) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    var dio = diopackage.Dio();
    try {
      final diopackage.Response response = await dio.post(
        url,
        data: body,
        options: diopackage.Options(validateStatus: (_) => true, headers: {'Content-Type': 'application/json'}),
      );

      EasyLoading.dismiss();
      return response;
    } catch (exception) {
      EasyLoading.dismiss();

      if (exception.toString().contains('SocketException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }

        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
        return null;
      }
    }
  }
}

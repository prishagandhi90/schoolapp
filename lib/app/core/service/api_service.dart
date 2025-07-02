import 'dart:convert';
import 'package:emp_app/app/moduls/payroll/model/payroll_model.dart';
import 'package:emp_app/app/moduls/verifyotp/model/otp_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as diopackage;
import 'package:get/get.dart';

class ApiController extends GetxController {
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

  Future<String> parseJsonBody(String apiURL, String headerToken, Object jsonBodyObj) async {
    var headers;

    if (headerToken == '') {
      headers = {"Content-Type": "application/json"};
    } else {
      headers = {'Authorization': 'Bearer $headerToken', "Content-Type": "application/json"};
    }

    // final body = jsonEncode(jsonBodyObj);
    final body = jsonBodyObj == '' ? null : jsonEncode(jsonBodyObj);
    // print("body: $body");
    // print("jsonBodyObj: $jsonBodyObj");
    try {
      final response = await http.post(Uri.parse(apiURL), headers: headers, body: body);
      return response.body; // This returns a String
    } catch (exception) {
      if (exception.toString().contains('SocketException')) {
        if (Get.overlayContext != null && !Get.isSnackbarOpen) {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }
        return 'NetworkError';
      } else if (exception.toString().contains('TimeoutException')) {
        if (Get.overlayContext != null && !Get.isSnackbarOpen) {
          Get.rawSnackbar(message: "Server Error.");
        }
        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
        return 'Error'; // Return a default error message or null if necessary
      }
    }
  }

  static dynamic parseResponse(String apiURL, String headerToken, Object jsonBodyObj) async {
    var headers;

    if (headerToken == '') {
      headers = {"Content-Type": "application/json"};
    } else {
      headers = {'Authorization': 'Bearer $headerToken', "Content-Type": "application/json"};
    }

    final body = jsonEncode(jsonBodyObj);
    try {
      final response = await http.post(Uri.parse(apiURL), headers: headers, body: body);
      return response; // This returns a String
    } catch (exception) {
      if (exception.toString().contains('SocketException')) {
        if (!Get.isSnackbarOpen) {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }
        return 'NetworkError';
      } else if (exception.toString().contains('TimeoutException')) {
        if (!Get.isSnackbarOpen) {
          Get.rawSnackbar(message: "Server Error.");
        }
        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
        return 'Error'; // Return a default error message or null if necessary
      }
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

  /* DIO methods below */
  static dynamic postMethodWithHeaderDioMapData({String? apiUrl, String? token, Map? body, bool isShowLoader = true}) async {
    if (isShowLoader) {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    }
    var dio = diopackage.Dio();
    try {
      final response = await dio
          .post(
            apiUrl!,
            data: body,
            options: diopackage.Options(
              validateStatus: (_) => true,
              headers: {
                "Authorization": "Bearer $token",
              },
            ),
          )
          .timeout(const Duration(seconds: 45));
      if (isShowLoader) {
        EasyLoading.dismiss();
      }
      return response;
    } catch (exception) {
      EasyLoading.dismiss();
      if (exception.toString().contains('SocketException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }

        return 'NetworkError';
      } else if (exception.toString().contains('TimeoutException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Server Error.");
        }

        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
        return null;
      }
    }
  }

//get dio api
  static dynamic getMethodWithHeaderDio({String? apiUrl, String? token, bool isShowLoader = true, Map<String, dynamic>? queryData, bool? headerChange}) async {
    if (isShowLoader) {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    }
    var dio = diopackage.Dio();
    try {
      final response = await dio
          .get(
            apiUrl!,
            queryParameters: queryData,
            options: diopackage.Options(
              validateStatus: (_) => true,
              headers: {
                "Authorization": "Bearer $token",
              },
            ),
          )
          .timeout(const Duration(seconds: 45));
      if (isShowLoader) {
        EasyLoading.dismiss();
      }

      return response;
    } catch (exception) {
      EasyLoading.dismiss();
      if (exception.toString().contains('SocketException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }

        return 'NetworkError';
      } else if (exception.toString().contains('TimeoutException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Server Error.");
        }

        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
        return null;
      }
    }
  }

  static dynamic deleteMethodWithHeaderDio({String? apiUrl, String? token, bool isShowLoader = true, Map<String, dynamic>? queryData, bool? headerChange}) async {
    if (isShowLoader) {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    }
    var dio = diopackage.Dio();
    try {
      final response = await dio
          .delete(
            data: queryData,
            apiUrl!,
            options: diopackage.Options(
              validateStatus: (_) => true,
              headers: {
                "Authorization": "Bearer $token",
              },
            ),
          )
          .timeout(const Duration(seconds: 45));
      if (isShowLoader) {
        EasyLoading.dismiss();
      }

      return response;
    } catch (exception) {
      EasyLoading.dismiss();
      if (exception.toString().contains('SocketException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }

        return 'NetworkError';
      } else if (exception.toString().contains('TimeoutException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Server Error.");
        }

        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
        return null;
      }
    }
  }

  static dynamic putMethodWithHeaderDio({String? apiUrl, String? token, bool isShowLoader = true, Map<String, dynamic>? queryData, bool? headerChange}) async {
    if (isShowLoader) {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    }
    var dio = diopackage.Dio();
    try {
      final response = await dio
          .put(
            apiUrl!,
            queryParameters: queryData,
            options: diopackage.Options(
              validateStatus: (_) => true,
              headers: {
                "Authorization": "Bearer $token",
              },
            ),
          )
          .timeout(const Duration(seconds: 45));
      if (isShowLoader) {
        EasyLoading.dismiss();
      }

      return response;
    } catch (exception) {
      EasyLoading.dismiss();
      if (exception.toString().contains('SocketException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Please check your internet connection.");
        }

        return 'NetworkError';
      } else if (exception.toString().contains('TimeoutException')) {
        if (Get.isSnackbarOpen) {
        } else {
          Get.rawSnackbar(message: "Server Error.");
        }
        return 'NetworkError';
      } else {
        Get.rawSnackbar(message: exception.toString());
      }
    }
  }
}

import 'dart:convert';
import 'package:emp_app/model/attendencetable_model.dart';
import 'package:emp_app/model/attpresenttable_model.dart';
import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:emp_app/model/mispunchtable_model.dart';
import 'package:http/http.dart' as http;
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
}

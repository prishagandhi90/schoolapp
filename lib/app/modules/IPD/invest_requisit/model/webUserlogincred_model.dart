class ResponseWebuselogin {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LoginWebUserCreds>? data;

  ResponseWebuselogin({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseWebuselogin.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LoginWebUserCreds>[];
      json['data'].forEach((v) {
        data!.add(new LoginWebUserCreds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoginWebUserCreds {
  String? isValidCreds;
  String? message;
  String? webEmpName;
  String? webEmpId;

  LoginWebUserCreds({this.isValidCreds, this.message, this.webEmpName, this.webEmpId});

  LoginWebUserCreds.fromJson(Map<String, dynamic> json) {
    isValidCreds = json['isValidCreds'];
    message = json['message'];
    webEmpName = json['webEmpName'];
    webEmpId = json['webEmpId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isValidCreds'] = this.isValidCreds;
    data['message'] = this.message;
    data['webEmpName'] = this.webEmpName;
    data['webEmpId'] = this.webEmpId;
    return data;
  }
}

class ResponseSuperLoginCred {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<SuperlogincredModel>? data;

  ResponseSuperLoginCred({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseSuperLoginCred.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SuperlogincredModel>[];
      json['data'].forEach((v) {
        data!.add(new SuperlogincredModel.fromJson(v));
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

class SuperlogincredModel {
  String? loginId;
  String? tokenNo;
  String? empId;

  SuperlogincredModel({this.loginId, this.tokenNo, this.empId});

  SuperlogincredModel.fromJson(Map<String, dynamic> json) {
    loginId = json['loginId'];
    tokenNo = json['tokenNo'];
    empId = json['empId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loginId'] = this.loginId;
    data['tokenNo'] = this.tokenNo;
    data['empId'] = this.empId;
    return data;
  }
}

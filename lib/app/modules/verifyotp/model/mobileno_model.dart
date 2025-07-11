class ResponseMobileNo {
  int? statusCode;
  String? isSuccess;
  String? message;
  MobileTable? data;

  ResponseMobileNo({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseMobileNo.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = json['data'] != null ? new MobileTable.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MobileTable {
  String? mobileNo;
  String? otpNo;
  String? message;

  MobileTable({this.mobileNo, this.otpNo, this.message});

  MobileTable.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobileNo'];
    otpNo = json['otpNo'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNo'] = this.mobileNo;
    data['otpNo'] = this.otpNo;
    data['message'] = this.message;
    return data;
  }
}

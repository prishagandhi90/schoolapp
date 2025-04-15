import 'dart:ffi';

class ResponseDashboardData {
  int? statusCode;
  String? isSuccess;
  String? message;
  DashboardTable? data;

  ResponseDashboardData({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseDashboardData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = json['data'] != null ? new DashboardTable.fromJson(json['data']) : null;
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

class DashboardTable {
  String? isValidToken;
  int? loginId;
  String? token;
  int? employeeId;
  String? employeeName;
  String? mobileNumber;
  String? emailAddress;
  String? dob;
  String? address;
  String? empCode;
  String? department;
  String? designation;
  String? empType;
  String? isSuperAdmin;
  String? isPharmacyUser;
  int? notificationCount;

  DashboardTable(
      {this.isValidToken,
      this.loginId,
      this.token,
      this.employeeId,
      this.employeeName,
      this.mobileNumber,
      this.emailAddress,
      this.dob,
      this.address,
      this.empCode,
      this.department,
      this.designation,
      this.empType,
      this.isSuperAdmin,
      this.isPharmacyUser,
      this.notificationCount});

  DashboardTable.fromJson(Map<String, dynamic> json) {
    isValidToken = json['is_valid_token'];
    loginId = json['login_id'];
    token = json['token'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    mobileNumber = json['mobileNumber'];
    emailAddress = json['emailAddress'];
    dob = json['dob'];
    address = json['address'];
    empCode = json['empCode'];
    department = json['department'];
    designation = json['designation'];
    empType = json['emp_Type'];
    isSuperAdmin = json['isSuperAdmin'];
    isPharmacyUser = json['isPharmacyUser'];
    notificationCount = json['notificationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_valid_token'] = this.isValidToken;
    data['login_id'] = this.loginId;
    data['token'] = this.token;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['mobileNumber'] = this.mobileNumber;
    data['emailAddress'] = this.emailAddress;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['empCode'] = this.empCode;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['emp_Type'] = this.empType;
    data['isSuperAdmin'] = this.isSuperAdmin;
    data['isPharmacyUser'] = this.isPharmacyUser;
    data['notificationCount'] = this.notificationCount;
    return data;
  }
}

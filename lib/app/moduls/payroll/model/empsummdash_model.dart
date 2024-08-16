class ResponseEmpSummDashboardData {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<EmpSummDashboardTable>? data;

  ResponseEmpSummDashboardData({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseEmpSummDashboardData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EmpSummDashboardTable>[];
      json['data'].forEach((v) {
        data!.add(new EmpSummDashboardTable.fromJson(v));
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

class EmpSummDashboardTable {
  String? employeeName;
  String? employeeCode;
  String? department;
  String? inPunchTime;
  String? outPunchTime;
  String? totLCEGMin;
  String? cnt;

  EmpSummDashboardTable(
      {this.employeeName,
      this.employeeCode,
      this.department,
      this.inPunchTime,
      this.outPunchTime,
      this.totLCEGMin,
      this.cnt});

  EmpSummDashboardTable.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    employeeCode = json['employeeCode'];
    department = json['department'];
    inPunchTime = json['inPunchTime'];
    outPunchTime = json['outPunchTime'];
    totLCEGMin = json['totLCEGMin'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeName'] = this.employeeName;
    data['employeeCode'] = this.employeeCode;
    data['department'] = this.department;
    data['inPunchTime'] = this.inPunchTime;
    data['outPunchTime'] = this.outPunchTime;
    data['totLCEGMin'] = this.totLCEGMin;
    data['cnt'] = this.cnt;
    return data;
  }
}

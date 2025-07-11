class Profiletable {
  String? employeeName;
  String? employeeCode;
  String? department;
  String? inPunchTime;
  String? outPunchTime;
  String? totLCEGMin;
  String? cnt;

  Profiletable({this.employeeName, this.employeeCode, this.department, this.inPunchTime, this.outPunchTime, this.totLCEGMin, this.cnt});

  Profiletable.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    employeeCode = json['employeeCode'];
    department = json['department'];
    inPunchTime = json['inPunchTime'];
    outPunchTime = json['outPunchTime'];
    totLCEGMin = json['totLCEGMin'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class ResponseMispunchData {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<MispunchTable>? data;

  ResponseMispunchData(
      {this.statusCode, this.isSuccess, this.message, this.data});

  ResponseMispunchData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MispunchTable>[];
      json['data'].forEach((v) {
        data!.add(new MispunchTable.fromJson(v));
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

class MispunchTable {
  String? empCode;
  String? empName;
  String? department;
  String? designation;
  String? empType;
  String? dt;
  String? misPunch;
  String? punchTime;
  String? shiftTime;
  String? note;

  MispunchTable(
      {this.empCode,
      this.empName,
      this.department,
      this.designation,
      this.empType,
      this.dt,
      this.misPunch,
      this.punchTime,
      this.shiftTime,
      this.note});

  MispunchTable.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    empName = json['empName'];
    department = json['department'];
    designation = json['designation'];
    empType = json['emp_Type'];
    dt = json['dt'];
    misPunch = json['mis_Punch'];
    punchTime = json['punch_Time'];
    shiftTime = json['shiftTime'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['emp_Type'] = this.empType;
    data['dt'] = this.dt;
    data['mis_Punch'] = this.misPunch;
    data['punch_Time'] = this.punchTime;
    data['shiftTime'] = this.shiftTime;
    data['note'] = this.note;
    return data;
  }
}

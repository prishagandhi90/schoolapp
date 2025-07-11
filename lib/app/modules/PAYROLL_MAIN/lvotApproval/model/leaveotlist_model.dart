class ResponseLeaveOTList {
  int? statusCode;
  String? isSuccess;
  String? message;
  String? defaultRole;
  String? inchargeYN;
  String? hodyn;
  String? hryn;
  List<LeaveotlistModel>? data;

  ResponseLeaveOTList({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.defaultRole,
    this.inchargeYN,
    this.hodyn,
    this.hryn,
    this.data,
  });

  ResponseLeaveOTList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    defaultRole = json['defaultRole'];
    inchargeYN = json['inchargeYN'];
    hodyn = json['hodyn'];
    hryn = json['hryn'];
    if (json['data'] != null && json['data'] is List) {
      data = <LeaveotlistModel>[];
      json['data'].forEach((v) {
        data!.add(new LeaveotlistModel.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['defaultRole'] = this.defaultRole;
    data['inchargeYN'] = this.inchargeYN;
    data['hodyn'] = this.hodyn;
    data['hryn'] = this.hryn;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveotlistModel {
  int? leaveId;
  String? typeValue;
  String? typeName;
  String? leaveShortName;
  String? leaveFullName;
  String? employeeCodeValue;
  String? employeeCodeName;
  String? fromDate;
  String? toDate;
  double? overTimeMinutes;
  String? leaveDays;
  String? reason;
  String? note;
  String? inchargeAction;
  String? hodAction;
  String? deptInc;
  String? deptHOD;
  String? inchargeNote;
  String? hoDNote;
  String? hrNote;
  String? enterDate;
  String? relieverEmpName;
  String? lateReasonName;
  String? otHours;
  String? empTel;
  String? punchTime;
  String? shiftTime;

  LeaveotlistModel({
    this.leaveId,
    this.typeValue,
    this.typeName,
    this.leaveShortName,
    this.leaveFullName,
    this.employeeCodeValue,
    this.employeeCodeName,
    this.fromDate,
    this.toDate,
    this.overTimeMinutes,
    this.leaveDays,
    this.reason,
    this.note,
    this.inchargeAction,
    this.hodAction,
    this.deptInc,
    this.deptHOD,
    this.inchargeNote,
    this.hoDNote,
    this.hrNote,
    this.enterDate,
    this.relieverEmpName,
    this.lateReasonName,
    this.otHours,
    this.empTel,
    this.punchTime,
    this.shiftTime,
  });

  LeaveotlistModel.fromJson(Map<String, dynamic> json) {
    leaveId = json['leaveId'];
    typeValue = json['typeValue'];
    typeName = json['typeName'];
    leaveShortName = json['leaveShortName'];
    leaveFullName = json['leaveFullName'];
    employeeCodeValue = json['employeeCodeValue'];
    employeeCodeName = json['employeeCodeName'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    overTimeMinutes = json['overTimeMinutes'];
    leaveDays = json['leaveDays'];
    reason = json['reason'];
    note = json['note'];
    inchargeAction = json['inchargeAction'];
    hodAction = json['hodAction'];
    deptInc = json['deptInc'];
    deptHOD = json['deptHOD'];
    inchargeNote = json['inchargeNote'];
    hoDNote = json['hoDNote'];
    hrNote = json['hrNote'];
    enterDate = json['enterDate'];
    relieverEmpName = json['relieverEmpName'];
    lateReasonName = json['lateReasonName'];
    otHours = json['otHours'];
    empTel = json['empTel'];
    punchTime = json['punchTime'];
    shiftTime = json['shiftTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveId'] = this.leaveId;
    data['typeValue'] = this.typeValue;
    data['typeName'] = this.typeName;
    data['leaveShortName'] = this.leaveShortName;
    data['leaveFullName'] = this.leaveFullName;
    data['employeeCodeValue'] = this.employeeCodeValue;
    data['employeeCodeName'] = this.employeeCodeName;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['overTimeMinutes'] = this.overTimeMinutes;
    data['leaveDays'] = this.leaveDays;
    data['reason'] = this.reason;
    data['note'] = this.note;
    data['inchargeAction'] = this.inchargeAction;
    data['hodAction'] = this.hodAction;
    data['deptInc'] = this.deptInc;
    data['deptHOD'] = this.deptHOD;
    data['inchargeNote'] = this.inchargeNote;
    data['hoDNote'] = this.hoDNote;
    data['hrNote'] = this.hrNote;
    data['enterDate'] = this.enterDate;
    data['relieverEmpName'] = this.relieverEmpName;
    data['lateReasonName'] = this.lateReasonName;
    data['otHours'] = this.otHours;
    data['empTel'] = this.empTel;
    data['punchTime'] = this.punchTime;
    data['shiftTime'] = this.shiftTime;
    return data;
  }
}

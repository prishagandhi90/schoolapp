class ResponseLeaveEntryList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LeaveEntryList>? data;

  ResponseLeaveEntryList({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseLeaveEntryList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaveEntryList>[];
      json['data'].forEach((v) {
        data!.add(new LeaveEntryList.fromJson(v));
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

class LeaveEntryList {
  int? leaveId;
  String? typeValue;
  String? typeName;
  String? leaveFullName;
  String? employeeCodeValue;
  String? employeeCodeName;
  String? fromDate;
  String? toDate;
  double? overTimeMinutes;
  double? leaveDays;
  String? reason;
  String? hrAction;
  String? inchargeAction;
  String? hodAction;
  String? hrReason;
  String? inchargeReason;
  String? hodReason;
  String? empType;
  String? department;
  String? subDept;
  String? note;
  String? deptInc;
  String? deptHOD;
  String? subDeptInc;
  String? subDeptHOD;
  String? inchargeNote;
  String? hoDNote;
  String? hrNote;
  String? enterDate;
  String? relieverEmpCode;
  String? relieverEmpName;
  String? lateReasonId;
  String? lateReasonName;
  String? empEmail;
  String? otHours;
  String? empTel;
  String? shiftTime;

  LeaveEntryList(
      {this.leaveId,
      this.typeValue,
      this.typeName,
      this.leaveFullName,
      this.employeeCodeValue,
      this.employeeCodeName,
      this.fromDate,
      this.toDate,
      this.overTimeMinutes,
      this.leaveDays,
      this.reason,
      this.hrAction,
      this.inchargeAction,
      this.hodAction,
      this.hrReason,
      this.inchargeReason,
      this.hodReason,
      this.empType,
      this.department,
      this.subDept,
      this.note,
      this.deptInc,
      this.deptHOD,
      this.subDeptInc,
      this.subDeptHOD,
      this.inchargeNote,
      this.hoDNote,
      this.hrNote,
      this.enterDate,
      this.relieverEmpCode,
      this.relieverEmpName,
      this.lateReasonId,
      this.lateReasonName,
      this.empEmail,
      this.otHours,
      this.empTel,
      this.shiftTime});

  LeaveEntryList.fromJson(Map<String, dynamic> json) {
    leaveId = json['leaveId'];
    typeValue = json['typeValue'];
    typeName = json['typeName'];
    leaveFullName = json['leaveFullName'];
    employeeCodeValue = json['employeeCodeValue'];
    employeeCodeName = json['employeeCodeName'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    overTimeMinutes = json['overTimeMinutes'];
    leaveDays = json['leaveDays'];
    reason = json['reason'];
    hrAction = json['hrAction'];
    inchargeAction = json['inchargeAction'];
    hodAction = json['hodAction'];
    hrReason = json['hrReason'];
    inchargeReason = json['inchargeReason'];
    hodReason = json['hodReason'];
    empType = json['empType'];
    department = json['department'];
    subDept = json['subDept'];
    note = json['note'];
    deptInc = json['deptInc'];
    deptHOD = json['deptHOD'];
    subDeptInc = json['subDeptInc'];
    subDeptHOD = json['subDeptHOD'];
    inchargeNote = json['inchargeNote'];
    hoDNote = json['hoDNote'];
    hrNote = json['hrNote'];
    enterDate = json['enterDate'];
    relieverEmpCode = json['relieverEmpCode'];
    relieverEmpName = json['relieverEmpName'];
    lateReasonId = json['lateReasonId'];
    lateReasonName = json['lateReasonName'];
    empEmail = json['empEmail'];
    otHours = json['otHours'];
    empTel = json['empTel'];
    shiftTime = json['shiftTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveId'] = this.leaveId;
    data['typeValue'] = this.typeValue;
    data['typeName'] = this.typeName;
    data['leaveFullName'] = this.leaveFullName;
    data['employeeCodeValue'] = this.employeeCodeValue;
    data['employeeCodeName'] = this.employeeCodeName;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['overTimeMinutes'] = this.overTimeMinutes;
    data['leaveDays'] = this.leaveDays;
    data['reason'] = this.reason;
    data['hrAction'] = this.hrAction;
    data['inchargeAction'] = this.inchargeAction;
    data['hodAction'] = this.hodAction;
    data['hrReason'] = this.hrReason;
    data['inchargeReason'] = this.inchargeReason;
    data['hodReason'] = this.hodReason;
    data['empType'] = this.empType;
    data['department'] = this.department;
    data['subDept'] = this.subDept;
    data['note'] = this.note;
    data['deptInc'] = this.deptInc;
    data['deptHOD'] = this.deptHOD;
    data['subDeptInc'] = this.subDeptInc;
    data['subDeptHOD'] = this.subDeptHOD;
    data['inchargeNote'] = this.inchargeNote;
    data['hoDNote'] = this.hoDNote;
    data['hrNote'] = this.hrNote;
    data['enterDate'] = this.enterDate;
    data['relieverEmpCode'] = this.relieverEmpCode;
    data['relieverEmpName'] = this.relieverEmpName;
    data['lateReasonId'] = this.lateReasonId;
    data['lateReasonName'] = this.lateReasonName;
    data['empEmail'] = this.empEmail;
    data['otHours'] = this.otHours;
    data['empTel'] = this.empTel;
    data['shiftTime'] = this.shiftTime;
    return data;
  }
}

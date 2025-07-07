import 'package:emp_app/app/moduls/IPD/medication_sheet/model/dr_treat_detail.dart';
import 'package:emp_app/app/moduls/IPD/medication_sheet/model/resp_dropdown_multifields_model.dart';

class RespDrTreatmentMst {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DrTreatMasterList>? data;

  RespDrTreatmentMst({this.statusCode, this.isSuccess, this.message, this.data});

  RespDrTreatmentMst.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <DrTreatMasterList>[];
      json['data'].forEach((v) {
        data!.add(DrTreatMasterList.fromJson(v));
      });
    } else {
      data = [];
    }
    // json['data'].forEach((v) {
    //   data!.add(new DrTreatMasterList.fromJson(v));
    // });
  }

  Map<String, dynamic> toJson() {
    return {
      // final Map<String, dynamic> data = new Map<String, dynamic>();
      'statusCode': statusCode,
      'isSuccess': isSuccess,
      'message': message,
      // if (this.data != null) {
      'data': data?.map((e) => e.toJson()).toList(),
      // data['data'] = this.data!.map((v) => v.toJson()).toList();
      // }
    };
    // return data;
  }
}

class DrTreatMasterList {
  int? admissionId;
  int? drMstId;
  String? irt;
  DateTime? date;
  String? remark;
  int? srNo;
  DateTime? sysDate;
  String? userName;
  String? terminalName;
  String? specialOrder;
  String? provisionalDiagnosis;
  String? weight;
  String? templateName;
  String? prescriptionType;
  String? precedence;
  String? statusTyp;
  String? isAlw;
  String? age;
  String? patientName;
  String? communicationNumber;
  String? consDrName;
  int? consDrId;
  DateTime? dob;
  String? frmEmerg;
  int? rowState;
  List<RespDrTreatDetail>? detail = [];
  DropdownMultifieldsTable? indoorRecordType;
  String? action;
  DropdownMultifieldsTable? consDr;
  bool? isValid;
  int? iudId;
  String? gridName;
  String? guid;
  int? tmplId;
  String? tmplName;

  DrTreatMasterList({
    this.admissionId,
    this.drMstId,
    this.irt,
    this.date,
    this.remark,
    this.srNo,
    this.sysDate,
    this.userName,
    this.terminalName,
    this.specialOrder,
    this.provisionalDiagnosis,
    this.weight,
    this.templateName,
    this.prescriptionType,
    this.precedence,
    this.statusTyp,
    this.isAlw,
    this.age,
    this.patientName,
    this.communicationNumber,
    this.consDrName,
    this.consDrId,
    this.dob,
    this.frmEmerg,
    this.rowState,
    this.detail = const [],
    this.indoorRecordType,
    this.action,
    this.consDr,
    this.isValid,
    this.iudId,
    this.gridName,
    this.guid,
    this.tmplId,
    this.tmplName,
  });

  DrTreatMasterList.fromJson(Map<String, dynamic> json) {
    admissionId = json['admissionId'];
    drMstId = json['drMstId'];
    irt = json['irt'];
    date = json['date'] != null ? DateTime.tryParse(json['date']) : null;
    remark = json['remark'];
    srNo = json['srNo'];
    sysDate = json['sysDate'] != null ? DateTime.tryParse(json['sysDate']) : null;
    userName = json['userName'];
    terminalName = json['terminalName'];
    specialOrder = json['specialOrder'];
    provisionalDiagnosis = json['provisionalDiagnosis'];
    weight = json['weight'];
    templateName = json['templateName'];
    prescriptionType = json['prescriptionType'];
    precedence = json['precedence'];
    statusTyp = json['statusTyp'];
    isAlw = json['isAlw'];
    age = json['age'];
    patientName = json['patientName'];
    communicationNumber = json['communicationNumber'];
    consDrName = json['consDrName'];
    consDrId = json['consDrId'];
    dob = json['dob'] != null ? DateTime.tryParse(json['dob']) : null;
    frmEmerg = json['frmEmerg'];
    rowState = json['rowState'];
    if (json['detail'] != null) {
      detail = <RespDrTreatDetail>[];
      json['detail'].forEach((v) {
        detail!.add(new RespDrTreatDetail.fromJson(v));
      });
    }
    indoorRecordType = json['indoorRecordType'] != null ? new DropdownMultifieldsTable.fromJson(json['indoorRecordType']) : null;
    action = json['action'];
    consDr = json['consDr'] != null ? new DropdownMultifieldsTable.fromJson(json['consDr']) : null;
    isValid = json['isValid'];
    iudId = json['iudId'];
    gridName = json['gridName'];
    guid = json['guid'];
    tmplId = json['tmplId'];
    tmplName = json['tmplName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admissionId'] = this.admissionId;
    data['drMstId'] = this.drMstId;
    data['irt'] = this.irt;
    data['date'] = this.date?.toIso8601String();
    data['remark'] = this.remark;
    data['srNo'] = this.srNo;
    data['sysDate'] = sysDate?.toIso8601String();
    data['userName'] = this.userName;
    data['terminalName'] = this.terminalName;
    data['specialOrder'] = this.specialOrder;
    data['provisionalDiagnosis'] = this.provisionalDiagnosis;
    data['weight'] = this.weight;
    data['templateName'] = this.templateName;
    data['prescriptionType'] = this.prescriptionType;
    data['precedence'] = this.precedence;
    data['statusTyp'] = this.statusTyp;
    data['isAlw'] = this.isAlw;
    data['age'] = this.age;
    data['patientName'] = this.patientName;
    data['communicationNumber'] = this.communicationNumber;
    data['consDrName'] = this.consDrName;
    data['consDrId'] = this.consDrId;
    data['dob'] = dob?.toIso8601String();
    data['frmEmerg'] = this.frmEmerg;
    data['rowState'] = this.rowState;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    if (this.indoorRecordType != null) {
      data['indoorRecordType'] = this.indoorRecordType!.toJson();
    }
    data['action'] = this.action;
    if (this.consDr != null) {
      data['consDr'] = this.consDr!.toJson();
    }
    data['isValid'] = this.isValid;
    data['iudId'] = this.iudId;
    data['gridName'] = this.gridName;
    data['guid'] = this.guid;
    data['tmplId'] = this.tmplId;
    data['tmplName'] = this.tmplName;
    return data;
  }
}

import 'package:emp_app/app/moduls/medication_sheet/model/dr_treat_detail.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/resp_dropdown_multifields_model.dart';

class Resp_DrTreatmentMst {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DRTreatMasterList>? data;

  Resp_DrTreatmentMst({this.statusCode, this.isSuccess, this.message, this.data});

  Resp_DrTreatmentMst.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DRTreatMasterList>[];
      json['data'].forEach((v) {
        data!.add(new DRTreatMasterList.fromJson(v));
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

class DRTreatMasterList {
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
  String? action;
  bool? isValid;
  int? iudId;
  String? gridName;
  String? tmplName;
  int? tmplId;
  String? guid;

  // NotMapped
  DropdownMultifieldsTable? indoorRecordType;
  DropdownMultifieldsTable? consDr;

  List<Resp_DRTreatDetail> detail = [];

  DRTreatMasterList();

  factory DRTreatMasterList.fromJson(Map<String, dynamic> json) {
    return DRTreatMasterList()
      ..admissionId = json['admissionId']
      ..drMstId = json['drMstId']
      ..irt = json['irt']
      ..date = json['date'] != null ? DateTime.parse(json['date']) : null
      ..remark = json['remark']
      ..srNo = json['srNo']
      ..sysDate = json['sysDate'] != null ? DateTime.parse(json['sysDate']) : null
      ..userName = json['userName']
      ..terminalName = json['terminalName']
      ..specialOrder = json['specialOrder']
      ..provisionalDiagnosis = json['provisionalDiagnosis']
      ..weight = json['weight']
      ..templateName = json['templateName']
      ..prescriptionType = json['prescriptionType']
      ..precedence = json['precedence']
      ..statusTyp = json['statusTyp']
      ..isAlw = json['isAlw']
      ..age = json['age']
      ..patientName = json['patientName']
      ..communicationNumber = json['communicationNumber']
      ..consDrName = json['consDrName']
      ..consDrId = json['consDrId']
      ..dob = json['dob'] != null ? DateTime.parse(json['dob']) : null
      ..frmEmerg = json['frmEmerg']
      ..action = json['action']
      ..isValid = json['isValid']
      ..iudId = json['iudId']
      ..gridName = json['gridName']
      ..tmplId = json['tmplId']
      ..tmplName = json['tmplName']
      ..guid = json['guid']
      ..detail = (json['detail'] as List<dynamic>?)?.map((e) => Resp_DRTreatDetail.fromJson(e)).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'admissionId': admissionId,
      'drMstId': drMstId,
      'irt': irt,
      'date': date?.toIso8601String(),
      'remark': remark,
      'srNo': srNo,
      'sysDate': sysDate?.toIso8601String(),
      'userName': userName,
      'terminalName': terminalName,
      'specialOrder': specialOrder,
      'provisionalDiagnosis': provisionalDiagnosis,
      'weight': weight,
      'templateName': templateName,
      'prescriptionType': prescriptionType,
      'precedence': precedence,
      'statusTyp': statusTyp,
      'isAlw': isAlw,
      'age': age,
      'patientName': patientName,
      'communicationNumber': communicationNumber,
      'consDrName': consDrName,
      'consDrId': consDrId,
      'dob': dob?.toIso8601String(),
      'frmEmerg': frmEmerg,
      'action': action,
      'isValid': isValid,
      'iudId': iudId,
      'gridName': gridName,
      'tmplId': tmplId,
      'tmplName': tmplName,
      'guid': guid,
      'detail': detail.map((e) => e.toJson()).toList(),
    };
  }
}

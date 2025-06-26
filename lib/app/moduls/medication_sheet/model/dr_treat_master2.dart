import 'package:emp_app/app/moduls/medication_sheet/model/dr_treat_detail1.dart';
import 'package:emp_app/app/moduls/medication_sheet/model/resp_dropdown_multifields_model.dart';

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
    if (json['data'] != null) {
      data = <DrTreatMasterList>[];
      json['data'].forEach((v) {
        data!.add(DrTreatMasterList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'isSuccess': isSuccess,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
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
  String? action;
  bool? isValid;
  int? iudId;
  String? gridName;
  String? tmplName;
  int? tmplId;
  String? guid;

  /// NotMapped
  DropdownMultifieldsTable? indoorRecordType;
  DropdownMultifieldsTable? consDr;

  List<RespDrTreatDetail> detail = [];

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
    this.action,
    this.isValid,
    this.iudId,
    this.gridName,
    this.tmplName,
    this.tmplId,
    this.guid,
    this.indoorRecordType,
    this.consDr,
    this.detail = const [],
  });

  factory DrTreatMasterList.fromJson(Map<String, dynamic> json) {
    final model = DrTreatMasterList()
      ..admissionId = json['admissionId']
      ..drMstId = json['drMstId']
      ..irt = json['irt']
      ..date = json['date'] != null ? DateTime.tryParse(json['date']) : null
      ..remark = json['remark']
      ..srNo = json['srNo']
      ..sysDate = json['sysDate'] != null ? DateTime.tryParse(json['sysDate']) : null
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
      ..dob = json['dob'] != null ? DateTime.tryParse(json['dob']) : null
      ..frmEmerg = json['frmEmerg']
      ..action = json['action']
      ..isValid = json['isValid']
      ..iudId = json['iudId']
      ..gridName = json['gridName']
      ..tmplId = json['tmplId']
      ..tmplName = json['tmplName']
      ..guid = json['guid']
      ..detail = (json['detail'] as List<dynamic>?)?.map((e) => RespDrTreatDetail.fromJson(e)).toList() ?? [];

    // Set NotMapped fields using available base values
    model.indoorRecordType = model.irt != null ? DropdownMultifieldsTable(name: model.irt) : null;

    model.consDr = (model.consDrName != null || model.consDrId != null) ? DropdownMultifieldsTable(name: model.consDrName, id: model.consDrId) : null;

    return model;
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

      // NotMapped fields (optional – for local use only, not needed if sending to server)
      'indoorRecordType': indoorRecordType?.toJson(),
      'consDr': consDr?.toJson(),
    };
  }
}

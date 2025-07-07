import 'package:emp_app/app/moduls/IPD/medication_sheet/model/resp_dropdown_multifields_model.dart';

class RespDrDetailWithStatus {
  int? statusCode;
  String? isSuccess;
  String? message;
  RespDrTreatDetail? data; // 👈 List hata ke ek object banaya

  RespDrDetailWithStatus({this.statusCode, this.isSuccess, this.message, this.data});

  RespDrDetailWithStatus.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is Map) {
      data = RespDrTreatDetail.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'isSuccess': isSuccess,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class RespDrTreatDetail {
  int? drDtlId;
  int? drMstId;
  int? days;
  String? itemNameMnl;
  int? qty;
  String? dose;
  String? remark;
  DateTime? dose1;
  DateTime? dose2;
  DateTime? dose3;
  DateTime? dose4;
  DateTime? dose5;
  DateTime? dose6;
  DateTime? dose7;
  DateTime? dose8;
  DateTime? dose9;
  DateTime? dose10;
  String? userName;
  DateTime? sysDate;
  String? terminalName;
  String? action;
  DateTime? stopTime;
  String? flowRate;
  bool? isValid;
  int? iudId;
  String? gridName;
  String? freq1;
  String? freq2;
  String? freq3;
  String? freq4;
  String? routeName;
  String? medicationName;
  String? dGivenBy1;
  String? dGivenBy2;
  String? dGivenBy3;
  String? dGivenBy4;
  String? dGivenBy5;
  String? dGivenBy6;
  String? dGivenBy7;
  String? dGivenBy8;
  String? dGivenBy9;
  String? dGivenBy10;
  String? itemTxt;
  String? item;
  String? instType;
  String? flowRt;

  // NotMapped
  DropdownMultifieldsTable? medicineType;
  DropdownMultifieldsTable? itemName;
  DropdownMultifieldsTable? route;
  DropdownMultifieldsTable? frequency1;
  DropdownMultifieldsTable? frequency2;
  DropdownMultifieldsTable? frequency3;
  DropdownMultifieldsTable? frequency4;
  DropdownMultifieldsTable? doseGivenBy1;
  DropdownMultifieldsTable? doseGivenBy2;
  DropdownMultifieldsTable? doseGivenBy3;
  DropdownMultifieldsTable? doseGivenBy4;
  DropdownMultifieldsTable? doseGivenBy5;
  DropdownMultifieldsTable? doseGivenBy6;
  DropdownMultifieldsTable? doseGivenBy7;
  DropdownMultifieldsTable? doseGivenBy8;
  DropdownMultifieldsTable? doseGivenBy9;
  DropdownMultifieldsTable? doseGivenBy10;
  DropdownMultifieldsTable? instruction_typ;

  RespDrTreatDetail({
    this.drDtlId,
    this.drMstId,
    this.days,
    this.itemNameMnl,
    this.qty,
    this.dose,
    this.remark,
    this.dose1,
    this.dose2,
    this.dose3,
    this.dose4,
    this.dose5,
    this.dose6,
    this.dose7,
    this.dose8,
    this.dose9,
    this.dose10,
    this.userName,
    this.sysDate,
    this.terminalName,
    this.action,
    this.stopTime,
    this.flowRate,
    this.isValid,
    this.iudId,
    this.gridName,
    this.freq1,
    this.freq2,
    this.freq3,
    this.freq4,
    this.routeName,
    this.medicationName,
    this.dGivenBy1,
    this.dGivenBy2,
    this.dGivenBy3,
    this.dGivenBy4,
    this.dGivenBy5,
    this.dGivenBy6,
    this.dGivenBy7,
    this.dGivenBy8,
    this.dGivenBy9,
    this.dGivenBy10,
    this.itemTxt,
    this.item,
    this.instType,
    this.flowRt,

    // NotMapped
    this.medicineType,
    this.itemName,
    this.route,
    this.frequency1,
    this.frequency2,
    this.frequency3,
    this.frequency4,
    this.doseGivenBy1,
    this.doseGivenBy2,
    this.doseGivenBy3,
    this.doseGivenBy4,
    this.doseGivenBy5,
    this.doseGivenBy6,
    this.doseGivenBy7,
    this.doseGivenBy8,
    this.doseGivenBy9,
    this.doseGivenBy10,
    this.instruction_typ,
  });

  RespDrTreatDetail.fromJson(Map<String, dynamic> json) {
    drDtlId = json['drDtlId'];
    drMstId = json['drMstId'];
    days = json['days'];
    itemNameMnl = json['itemNameMnl'];
    qty = json['qty'];
    dose = json['dose'];
    remark = json['remark'];
    dose1 = json['dose1'] != null ? DateTime.tryParse(json['dose1']) : null;
    dose2 = json['dose2'] != null ? DateTime.tryParse(json['dose2']) : null;
    dose3 = json['dose3'] != null ? DateTime.tryParse(json['dose3']) : null;
    dose4 = json['dose4'] != null ? DateTime.tryParse(json['dose4']) : null;
    dose5 = json['dose5'] != null ? DateTime.tryParse(json['dose5']) : null;
    dose6 = json['dose6'] != null ? DateTime.tryParse(json['dose6']) : null;
    dose7 = json['dose7'] != null ? DateTime.tryParse(json['dose7']) : null;
    dose8 = json['dose8'] != null ? DateTime.tryParse(json['dose8']) : null;
    dose9 = json['dose9'] != null ? DateTime.tryParse(json['dose9']) : null;
    dose10 = json['dose10'] != null ? DateTime.tryParse(json['dose10']) : null;
    userName = json['userName'];
    sysDate = json['sysDate'] != null ? DateTime.tryParse(json['sysDate']) : null;
    terminalName = json['terminalName'];
    action = json['action'];
    stopTime = json['stopTime'] != null ? DateTime.tryParse(json['stopTime']) : null;
    flowRate = json['flowRate'];
    isValid = json['isValid'];
    iudId = json['iudId'];
    gridName = json['gridName'];
    freq1 = json['freq1'];
    freq2 = json['freq2'];
    freq3 = json['freq3'];
    freq4 = json['freq4'];
    routeName = json['routeName'];
    medicationName = json['medicationName'];
    dGivenBy1 = json['dGivenBy1'];
    dGivenBy2 = json['dGivenBy2'];
    dGivenBy3 = json['dGivenBy3'];
    dGivenBy4 = json['dGivenBy4'];
    dGivenBy5 = json['dGivenBy5'];
    dGivenBy6 = json['dGivenBy6'];
    dGivenBy7 = json['dGivenBy7'];
    dGivenBy8 = json['dGivenBy8'];
    dGivenBy9 = json['dGivenBy9'];
    dGivenBy10 = json['dGivenBy10'];
    itemTxt = json['itemTxt'];
    item = json['item'];
    instType = json['instType'];
    flowRt = json['flowRt'];

    // NotMapped fields initialization
    medicineType = json['medicineType'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['medicineType']) : null;
    itemName = json['itemName'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['itemName']) : null;

    route = json['route'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['route']) : null;
    frequency1 = json['frequency1'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['frequency1']) : null;
    frequency2 = json['frequency1'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['frequency2']) : null;
    frequency3 = json['frequency1'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['frequency3']) : null;
    frequency4 = json['frequency1'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['frequency4']) : null;

    doseGivenBy1 = json['doseGivenBy1'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy1']) : null;
    doseGivenBy2 = json['doseGivenBy2'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy2']) : null;
    doseGivenBy3 = json['doseGivenBy3'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy3']) : null;
    doseGivenBy4 = json['doseGivenBy4'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy4']) : null;
    doseGivenBy5 = json['doseGivenBy5'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy5']) : null;
    doseGivenBy6 = json['doseGivenBy6'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy6']) : null;
    doseGivenBy7 = json['doseGivenBy7'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy7']) : null;
    doseGivenBy8 = json['doseGivenBy8'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy8']) : null;
    doseGivenBy9 = json['doseGivenBy9'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy9']) : null;
    doseGivenBy10 = json['doseGivenBy10'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['doseGivenBy10']) : null;
    instruction_typ = json['instruction_typ'] is Map<String, dynamic> ? new DropdownMultifieldsTable.fromJson(json['instruction_typ']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drDtlId'] = this.drDtlId;
    data['drMstId'] = this.drMstId;
    data['days'] = this.days;
    data['itemNameMnl'] = this.itemNameMnl;
    data['qty'] = this.qty;
    data['dose'] = this.dose;
    data['remark'] = this.remark;
    data['dose1'] = this.dose1?.toIso8601String();
    data['dose2'] = this.dose2?.toIso8601String();
    data['dose3'] = this.dose3?.toIso8601String();
    data['dose4'] = this.dose4?.toIso8601String();
    data['dose5'] = this.dose5?.toIso8601String();
    data['dose6'] = this.dose6?.toIso8601String();
    data['dose7'] = this.dose7?.toIso8601String();
    data['dose8'] = this.dose8?.toIso8601String();
    data['dose9'] = this.dose9?.toIso8601String();
    data['dose10'] = this.dose10?.toIso8601String();
    data['userName'] = this.userName;
    data['sysDate'] = this.sysDate?.toIso8601String();
    data['terminalName'] = this.terminalName;
    data['action'] = this.action;
    data['stopTime'] = this.stopTime?.toIso8601String();
    data['flowRate'] = this.flowRate;
    data['isValid'] = this.isValid;
    data['iudId'] = this.iudId;
    data['gridName'] = this.gridName;
    data['freq1'] = this.freq1;
    data['freq2'] = this.freq2;
    data['freq3'] = this.freq3;
    data['freq4'] = this.freq4;
    data['routeName'] = this.routeName;
    data['medicationName'] = this.medicationName;
    data['dGivenBy1'] = this.dGivenBy1;
    data['dGivenBy2'] = this.dGivenBy2;
    data['dGivenBy3'] = this.dGivenBy3;
    data['dGivenBy4'] = this.dGivenBy4;
    data['dGivenBy5'] = this.dGivenBy5;
    data['dGivenBy6'] = this.dGivenBy6;
    data['dGivenBy7'] = this.dGivenBy7;
    data['dGivenBy8'] = this.dGivenBy8;
    data['dGivenBy9'] = this.dGivenBy9;
    data['dGivenBy10'] = this.dGivenBy10;
    data['itemTxt'] = this.itemTxt;
    data['item'] = this.item;
    data['instType'] = this.instType;
    data['flowRt'] = this.flowRt;

    // NotMapped (optional for debug/UI only)
    if (this.medicineType != null) {
      data['medicineType'] = this.medicineType!.toJson();
    }
    if (this.itemName != null) {
      data['itemName'] = this.itemName!.toJson();
    }
    if (this.route != null) {
      data['route'] = this.route!.toJson();
    }
    if (this.frequency1 != null) {
      data['frequency1'] = this.frequency1!.toJson();
    }
    if (this.frequency2 != null) {
      data['frequency2'] = this.frequency2!.toJson();
    }
    if (this.frequency3 != null) {
      data['frequency3'] = this.frequency3!.toJson();
    }
    if (this.frequency4 != null) {
      data['frequency4'] = this.frequency4!.toJson();
    }
    if (this.doseGivenBy1 != null) {
      data['doseGivenBy1'] = this.doseGivenBy1!.toJson();
    }
    if (this.doseGivenBy2 != null) {
      data['doseGivenBy2'] = this.doseGivenBy2!.toJson();
    }
    if (this.doseGivenBy3 != null) {
      data['doseGivenBy3'] = this.doseGivenBy3!.toJson();
    }
    if (this.doseGivenBy4 != null) {
      data['doseGivenBy4'] = this.doseGivenBy4!.toJson();
    }
    if (this.doseGivenBy5 != null) {
      data['doseGivenBy5'] = this.doseGivenBy5!.toJson();
    }
    if (this.doseGivenBy6 != null) {
      data['doseGivenBy6'] = this.doseGivenBy6!.toJson();
    }
    if (this.doseGivenBy7 != null) {
      data['doseGivenBy7'] = this.doseGivenBy7!.toJson();
    }
    if (this.doseGivenBy8 != null) {
      data['doseGivenBy8'] = this.doseGivenBy8!.toJson();
    }
    if (this.doseGivenBy9 != null) {
      data['doseGivenBy9'] = this.doseGivenBy9!.toJson();
    }
    if (this.doseGivenBy10 != null) {
      data['doseGivenBy10'] = this.doseGivenBy10!.toJson();
    }
    if (this.instruction_typ != null) {
      data['instruction_typ'] = this.instruction_typ!.toJson();
    }
    return data;
  }
}

import 'package:schoolapp/app/modules/IPD/medication_sheet/model/resp_dropdown_multifields_model.dart';

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
  DropdownMultifieldsTable? instructionTyp;

  RespDrTreatDetail();

  factory RespDrTreatDetail.fromJson(Map<String, dynamic> json) {
    final model = RespDrTreatDetail()
      ..drDtlId = json['drDtlId']
      ..drMstId = json['drMstId']
      ..days = json['days']
      ..itemNameMnl = json['itemNameMnl']
      ..qty = json['qty']
      ..dose = json['dose']
      ..remark = json['remark']
      ..dose1 = json['dose1'] != null ? DateTime.tryParse(json['dose1']) : null
      ..dose2 = json['dose2'] != null ? DateTime.tryParse(json['dose2']) : null
      ..dose3 = json['dose3'] != null ? DateTime.tryParse(json['dose3']) : null
      ..dose4 = json['dose4'] != null ? DateTime.tryParse(json['dose4']) : null
      ..dose5 = json['dose5'] != null ? DateTime.tryParse(json['dose5']) : null
      ..dose6 = json['dose6'] != null ? DateTime.tryParse(json['dose6']) : null
      ..dose7 = json['dose7'] != null ? DateTime.tryParse(json['dose7']) : null
      ..dose8 = json['dose8'] != null ? DateTime.tryParse(json['dose8']) : null
      ..dose9 = json['dose9'] != null ? DateTime.tryParse(json['dose9']) : null
      ..dose10 = json['dose10'] != null ? DateTime.tryParse(json['dose10']) : null
      ..userName = json['userName']
      ..sysDate = json['sysDate'] != null ? DateTime.tryParse(json['sysDate']) : null
      ..terminalName = json['terminalName']
      ..action = json['action']
      ..stopTime = json['stopTime'] != null ? DateTime.tryParse(json['stopTime']) : null
      ..flowRate = json['flowRate']
      ..isValid = json['isValid']
      ..iudId = json['iudId']
      ..gridName = json['gridName']
      ..freq1 = json['freq1']
      ..freq2 = json['freq2']
      ..freq3 = json['freq3']
      ..freq4 = json['freq4']
      ..routeName = json['routeName']
      ..medicationName = json['medicationName']
      ..dGivenBy1 = json['dGivenBy1']
      ..dGivenBy2 = json['dGivenBy2']
      ..dGivenBy3 = json['dGivenBy3']
      ..dGivenBy4 = json['dGivenBy4']
      ..dGivenBy5 = json['dGivenBy5']
      ..dGivenBy6 = json['dGivenBy6']
      ..dGivenBy7 = json['dGivenBy7']
      ..dGivenBy8 = json['dGivenBy8']
      ..dGivenBy9 = json['dGivenBy9']
      ..dGivenBy10 = json['dGivenBy10']
      ..itemTxt = json['itemTxt']
      ..item = json['item']
      ..instType = json['instType']
      ..flowRt = json['flowRt'];

    // NotMapped fields initialization
    model.medicineType = model.medicationName != null ? DropdownMultifieldsTable(name: model.medicationName) : null;
    model.itemName = (model.item != null || model.itemTxt != null) ? DropdownMultifieldsTable(name: model.item, txt: model.itemTxt) : null;
    model.route = model.routeName != null ? DropdownMultifieldsTable(name: model.routeName) : null;
    model.frequency1 = model.freq1 != null ? DropdownMultifieldsTable(name: model.freq1) : null;
    model.frequency2 = model.freq2 != null ? DropdownMultifieldsTable(name: model.freq2) : null;
    model.frequency3 = model.freq3 != null ? DropdownMultifieldsTable(name: model.freq3) : null;
    model.frequency4 = model.freq4 != null ? DropdownMultifieldsTable(name: model.freq4) : null;
    model.doseGivenBy1 = model.dGivenBy1 != null ? DropdownMultifieldsTable(name: model.dGivenBy1) : null;
    model.doseGivenBy2 = model.dGivenBy2 != null ? DropdownMultifieldsTable(name: model.dGivenBy2) : null;
    model.doseGivenBy3 = model.dGivenBy3 != null ? DropdownMultifieldsTable(name: model.dGivenBy3) : null;
    model.doseGivenBy4 = model.dGivenBy4 != null ? DropdownMultifieldsTable(name: model.dGivenBy4) : null;
    model.doseGivenBy5 = model.dGivenBy5 != null ? DropdownMultifieldsTable(name: model.dGivenBy5) : null;
    model.doseGivenBy6 = model.dGivenBy6 != null ? DropdownMultifieldsTable(name: model.dGivenBy6) : null;
    model.doseGivenBy7 = model.dGivenBy7 != null ? DropdownMultifieldsTable(name: model.dGivenBy7) : null;
    model.doseGivenBy8 = model.dGivenBy8 != null ? DropdownMultifieldsTable(name: model.dGivenBy8) : null;
    model.doseGivenBy9 = model.dGivenBy9 != null ? DropdownMultifieldsTable(name: model.dGivenBy9) : null;
    model.doseGivenBy10 = model.dGivenBy10 != null ? DropdownMultifieldsTable(name: model.dGivenBy10) : null;
    model.instructionTyp = model.instType != null ? DropdownMultifieldsTable(name: model.instType) : null;

    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'drDtlId': drDtlId,
      'drMstId': drMstId,
      'days': days,
      'itemNameMnl': itemNameMnl,
      'qty': qty,
      'dose': dose,
      'remark': remark,
      'dose1': dose1?.toIso8601String(),
      'dose2': dose2?.toIso8601String(),
      'dose3': dose3?.toIso8601String(),
      'dose4': dose4?.toIso8601String(),
      'dose5': dose5?.toIso8601String(),
      'dose6': dose6?.toIso8601String(),
      'dose7': dose7?.toIso8601String(),
      'dose8': dose8?.toIso8601String(),
      'dose9': dose9?.toIso8601String(),
      'dose10': dose10?.toIso8601String(),
      'userName': userName,
      'sysDate': sysDate?.toIso8601String(),
      'terminalName': terminalName,
      'action': action,
      'stopTime': stopTime?.toIso8601String(),
      'flowRate': flowRate,
      'isValid': isValid,
      'iudId': iudId,
      'gridName': gridName,
      'freq1': freq1,
      'freq2': freq2,
      'freq3': freq3,
      'freq4': freq4,
      'routeName': routeName,
      'medicationName': medicationName,
      'dGivenBy1': dGivenBy1,
      'dGivenBy2': dGivenBy2,
      'dGivenBy3': dGivenBy3,
      'dGivenBy4': dGivenBy4,
      'dGivenBy5': dGivenBy5,
      'dGivenBy6': dGivenBy6,
      'dGivenBy7': dGivenBy7,
      'dGivenBy8': dGivenBy8,
      'dGivenBy9': dGivenBy9,
      'dGivenBy10': dGivenBy10,
      'itemTxt': itemTxt,
      'item': item,
      'instType': instType,
      'flowRt': flowRt,

      // NotMapped (optional for debug/UI only)
      'medicineType': medicineType?.toJson(),
      'itemNameObj': itemName?.toJson(),
      'routeObj': route?.toJson(),
      'frequency1': frequency1?.toJson(),
      'frequency2': frequency2?.toJson(),
      'frequency3': frequency3?.toJson(),
      'frequency4': frequency4?.toJson(),
      'doseGivenBy1': doseGivenBy1?.toJson(),
      'doseGivenBy2': doseGivenBy2?.toJson(),
      'doseGivenBy3': doseGivenBy3?.toJson(),
      'doseGivenBy4': doseGivenBy4?.toJson(),
      'doseGivenBy5': doseGivenBy5?.toJson(),
      'doseGivenBy6': doseGivenBy6?.toJson(),
      'doseGivenBy7': doseGivenBy7?.toJson(),
      'doseGivenBy8': doseGivenBy8?.toJson(),
      'doseGivenBy9': doseGivenBy9?.toJson(),
      'doseGivenBy10': doseGivenBy10?.toJson(),
      'instructionTyp': instructionTyp?.toJson(),
    };
  }
}

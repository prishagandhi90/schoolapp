class Rsponsedpatientdata {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<PatientdataModel>? data;

  Rsponsedpatientdata(
      {this.statusCode, this.isSuccess, this.message, this.data});

  Rsponsedpatientdata.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PatientdataModel>[];
      json['data'].forEach((v) {
        data!.add(new PatientdataModel.fromJson(v));
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

class PatientdataModel {
  String? isValidToken;
  String? patientCategory;
  String? uhid;
  String? ipdNo;
  String? patientName;
  String? bedNo;
  String? ward;
  String? floor;
  String? doa;
  String? admType;
  String? totalDays;
  String? referredDr;
  String? mobileNo;

  PatientdataModel(
      {this.isValidToken,
      this.patientCategory,
      this.uhid,
      this.ipdNo,
      this.patientName,
      this.bedNo,
      this.ward,
      this.floor,
      this.doa,
      this.admType,
      this.totalDays,
      this.referredDr,
      this.mobileNo});

  PatientdataModel.fromJson(Map<String, dynamic> json) {
    isValidToken = json['isValidToken'];
    patientCategory = json['patientCategory'];
    uhid = json['uhid'];
    ipdNo = json['ipdNo'];
    patientName = json['patientName'];
    bedNo = json['bedNo'];
    ward = json['ward'];
    floor = json['floor'];
    doa = json['doa'];
    admType = json['admType'];
    totalDays = json['totalDays'];
    referredDr = json['referredDr'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isValidToken'] = this.isValidToken;
    data['patientCategory'] = this.patientCategory;
    data['uhid'] = this.uhid;
    data['ipdNo'] = this.ipdNo;
    data['patientName'] = this.patientName;
    data['bedNo'] = this.bedNo;
    data['ward'] = this.ward;
    data['floor'] = this.floor;
    data['doa'] = this.doa;
    data['admType'] = this.admType;
    data['totalDays'] = this.totalDays;
    data['referredDr'] = this.referredDr;
    data['mobileNo'] = this.mobileNo;
    return data;
  }
}

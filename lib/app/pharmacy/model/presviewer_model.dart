class Rsponsedrpresviewer {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<PresviewerList>? data;

  Rsponsedrpresviewer({this.statusCode, this.isSuccess, this.message, this.data});

  Rsponsedrpresviewer.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <PresviewerList>[];
      json['data'].forEach((v) {
        data!.add(new PresviewerList.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PresviewerList {
  int? srNo;
  String? priority;
  String? rxType;
  String? patientName;
  String? rxStatus;
  String? uhid;
  String? ipd;
  String? ward;
  String? bed;
  String? lastUser;
  String? timeofsavingbill;
  int? mstId;
  int? admissionId;
  String? indoorRecordType;
  String? isPharmaUsr;
  int? stsrt;
  String? printStatus;
  String? printUserName;
  String? printDateTime;
  String? rxCtgr;

  PresviewerList(
      {this.srNo,
      this.priority,
      this.rxType,
      this.patientName,
      this.rxStatus,
      this.uhid,
      this.ipd,
      this.ward,
      this.bed,
      this.lastUser,
      this.timeofsavingbill,
      this.mstId,
      this.admissionId,
      this.indoorRecordType,
      this.isPharmaUsr,
      this.stsrt,
      this.printStatus,
      this.printUserName,
      this.printDateTime,
      this.rxCtgr});

  PresviewerList.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    priority = json['priority'];
    rxType = json['rxType'];
    patientName = json['patientName'];
    rxStatus = json['rxStatus'];
    uhid = json['uhid'];
    ipd = json['ipd'];
    ward = json['ward'];
    bed = json['bed'];
    lastUser = json['lastUser'];
    timeofsavingbill = json['timeofsavingbill'];
    mstId = json['mstId'];
    admissionId = json['admissionId'];
    indoorRecordType = json['indoorRecordType'];
    isPharmaUsr = json['isPharmaUsr'];
    stsrt = json['stsrt'];
    printStatus = json['printStatus'];
    printUserName = json['printUserName'];
    printDateTime = json['printDateTime'];
    rxCtgr = json['rxCtgr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['priority'] = this.priority;
    data['rxType'] = this.rxType;
    data['patientName'] = this.patientName;
    data['rxStatus'] = this.rxStatus;
    data['uhid'] = this.uhid;
    data['ipd'] = this.ipd;
    data['ward'] = this.ward;
    data['bed'] = this.bed;
    data['lastUser'] = this.lastUser;
    data['timeofsavingbill'] = this.timeofsavingbill;
    data['mstId'] = this.mstId;
    data['admissionId'] = this.admissionId;
    data['indoorRecordType'] = this.indoorRecordType;
    data['isPharmaUsr'] = this.isPharmaUsr;
    data['stsrt'] = this.stsrt;
    data['printStatus'] = this.printStatus;
    data['printUserName'] = this.printUserName;
    data['printDateTime'] = this.printDateTime;
    data['rxCtgr'] = this.rxCtgr;
    return data;
  }
}

class ResponseDieticianListData {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DieticianlistModel>? data;

  ResponseDieticianListData({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseDieticianListData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DieticianlistModel>[];
      json['data'].forEach((v) {
        data!.add(new DieticianlistModel.fromJson(v));
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

class DieticianlistModel {
  int? id;
  String? patientName;
  String? uhidNo;
  String? ipdNo;
  String? bedNo;
  String? wardName;
  int? grpSequence;
  int? sequence;
  String? doa;
  String? doctor;
  int? floorNo;
  String? diagnosis;
  String? remark;
  String? username;
  String? sysDate;
  String? dietPlan;
  String? relFoodRemark;

  DieticianlistModel(
      {this.id,
      this.patientName,
      this.uhidNo,
      this.ipdNo,
      this.bedNo,
      this.wardName,
      this.grpSequence,
      this.sequence,
      this.doa,
      this.doctor,
      this.floorNo,
      this.diagnosis,
      this.remark,
      this.username,
      this.sysDate,
      this.dietPlan,
      this.relFoodRemark});

  DieticianlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientName = json['patientName'];
    uhidNo = json['uhidNo'];
    ipdNo = json['ipdNo'];
    bedNo = json['bedNo'];
    wardName = json['wardName'];
    grpSequence = json['grpSequence'];
    sequence = json['sequence'];
    doa = json['doa'];
    doctor = json['doctor'];
    floorNo = json['floorNo'];
    diagnosis = json['diagnosis'];
    remark = json['remark'];
    username = json['username'];
    sysDate = json['sysDate'];
    dietPlan = json['dietPlan'];
    relFoodRemark = json['relFood_Remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patientName'] = this.patientName;
    data['uhidNo'] = this.uhidNo;
    data['ipdNo'] = this.ipdNo;
    data['bedNo'] = this.bedNo;
    data['wardName'] = this.wardName;
    data['grpSequence'] = this.grpSequence;
    data['sequence'] = this.sequence;
    data['doa'] = this.doa;
    data['doctor'] = this.doctor;
    data['floorNo'] = this.floorNo;
    data['diagnosis'] = this.diagnosis;
    data['remark'] = this.remark;
    data['username'] = this.username;
    data['sysDate'] = this.sysDate;
    data['dietPlan'] = this.dietPlan;
    data['relFood_Remark'] = this.relFoodRemark;
    return data;
  }
}

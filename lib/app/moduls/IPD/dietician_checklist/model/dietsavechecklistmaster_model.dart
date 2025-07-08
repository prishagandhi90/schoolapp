class ResponseSaveDietListMaster {
  int? statusCode;
  String? isSuccess;
  String? message;
  Data? data;

  ResponseSaveDietListMaster({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseSaveDietListMaster.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? diagnosis;
  Diet? diet;
  String? remark;
  String? relFoodRemark;
  String? username;
  String? patientName;
  String? uhidNo;
  String? ipdNo;
  String? bedNo;
  String? wardName;
  String? doa;
  String? doctor;
  String? floorNo;
  String? sysDate;
  Null dietPlan;

  Data(
      {this.id,
      this.diagnosis,
      this.diet,
      this.remark,
      this.relFoodRemark,
      this.username,
      this.patientName,
      this.uhidNo,
      this.ipdNo,
      this.bedNo,
      this.wardName,
      this.doa,
      this.doctor,
      this.floorNo,
      this.sysDate,
      this.dietPlan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diagnosis = json['diagnosis'];
    diet = json['diet'] != null ? new Diet.fromJson(json['diet']) : null;
    remark = json['remark'];
    relFoodRemark = json['relFood_Remark'];
    username = json['username'];
    patientName = json['patientName'];
    uhidNo = json['uhidNo'];
    ipdNo = json['ipdNo'];
    bedNo = json['bedNo'];
    wardName = json['wardName'];
    doa = json['doa'];
    doctor = json['doctor'];
    floorNo = json['floorNo'];
    sysDate = json['sysDate'];
    dietPlan = json['dietPlan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['diagnosis'] = this.diagnosis;
    if (this.diet != null) {
      data['diet'] = this.diet!.toJson();
    }
    data['remark'] = this.remark;
    data['relFood_Remark'] = this.relFoodRemark;
    data['username'] = this.username;
    data['patientName'] = this.patientName;
    data['uhidNo'] = this.uhidNo;
    data['ipdNo'] = this.ipdNo;
    data['bedNo'] = this.bedNo;
    data['wardName'] = this.wardName;
    data['doa'] = this.doa;
    data['doctor'] = this.doctor;
    data['floorNo'] = this.floorNo;
    data['sysDate'] = this.sysDate;
    data['dietPlan'] = this.dietPlan;
    return data;
  }
}

class Diet {
  int? id;
  String? name;
  String? value;
  int? sort;
  String? txt;
  int? parentId;
  String? supName;
  String? dateValue;

  Diet({this.id, this.name, this.value, this.sort, this.txt, this.parentId, this.supName, this.dateValue});

  Diet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    sort = json['sort'];
    txt = json['txt'];
    parentId = json['parentId'];
    supName = json['sup_name'];
    dateValue = json['dateValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['sort'] = this.sort;
    data['txt'] = this.txt;
    data['parentId'] = this.parentId;
    data['sup_name'] = this.supName;
    data['dateValue'] = this.dateValue;
    return data;
  }
}

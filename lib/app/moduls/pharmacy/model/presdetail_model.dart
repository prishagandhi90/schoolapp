class Rsponsedrpresdetail {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<PresdetailList>? data;

  Rsponsedrpresdetail({this.statusCode, this.isSuccess, this.message, this.data});

  Rsponsedrpresdetail.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <PresdetailList>[];
      json['data'].forEach((v) {
        data!.add(new PresdetailList.fromJson(v));
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

class PresdetailList {
  int? sr;
  String? formBrand;
  String? genericName;
  String? rmk;
  String? instructionTyp;
  String? freq;
  int? qty;
  String? medicineType;
  String? pkg;

  PresdetailList(
      {this.sr, this.formBrand, this.genericName, this.rmk, this.instructionTyp, this.freq, this.qty, this.medicineType, this.pkg});

  PresdetailList.fromJson(Map<String, dynamic> json) {
    sr = json['sr'];
    formBrand = json['form_Brand'];
    genericName = json['genericName'];
    rmk = json['rmk'];
    instructionTyp = json['instruction_typ'];
    freq = json['freq'];
    qty = json['qty'];
    medicineType = json['medicine_type'];
    pkg = json['pkg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sr'] = this.sr;
    data['form_Brand'] = this.formBrand;
    data['genericName'] = this.genericName;
    data['rmk'] = this.rmk;
    data['instruction_typ'] = this.instructionTyp;
    data['freq'] = this.freq;
    data['qty'] = this.qty;
    data['medicine_type'] = this.medicineType;
    data['pkg'] = this.pkg;
    return data;
  }
}

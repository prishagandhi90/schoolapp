class ResponseDietWardName {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DieticianfilterwardnmModel>? data;

  ResponseDietWardName({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseDietWardName.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DieticianfilterwardnmModel>[];
      json['data'].forEach((v) {
        data!.add(new DieticianfilterwardnmModel.fromJson(v));
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

class DieticianfilterwardnmModel {
  String? wardName;
  String? shortWardName;
  int? grpSeq;
  int? seq;
  int? wardCount;

  DieticianfilterwardnmModel({
    this.wardName,
    this.shortWardName,
    this.grpSeq,
    this.seq,
    this.wardCount,
  });

  DieticianfilterwardnmModel.fromJson(Map<String, dynamic> json) {
    wardName = json['wardName'];
    shortWardName = json['shortWardName'];
    grpSeq = json['grp_Seq'];
    seq = json['seq'];
    wardCount = json['wardCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wardName'] = this.wardName;
    data['shortWardName'] = this.shortWardName;
    data['grp_Seq'] = this.grpSeq;
    data['seq'] = this.seq;
    data['wardCount'] = this.wardCount;
    return data;
  }
}

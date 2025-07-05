class RsponseLVRejReason {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<ReasonList>? data;

  RsponseLVRejReason({this.statusCode, this.isSuccess, this.message, this.data});

  RsponseLVRejReason.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <ReasonList>[];
      json['data'].forEach((v) {
        data!.add(new ReasonList.fromJson(v));
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

class ReasonList {
  String? value;
  String? name;

  ReasonList({this.value, this.name});

  ReasonList.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }
}

class LeaveNames {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LeavenamesModel>? data;

  LeaveNames({this.statusCode, this.isSuccess, this.message, this.data});

  LeaveNames.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeavenamesModel>[];
      json['data'].forEach((v) {
        data!.add(new LeavenamesModel.fromJson(v));
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

class LeavenamesModel {
  String? value;
  String? name;

  LeavenamesModel({this.value, this.name});

  LeavenamesModel.fromJson(Map<String, dynamic> json) {
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

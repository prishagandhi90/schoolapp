class ResponseServiceGroup {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<ServicegrpModel>? data;

  ResponseServiceGroup(
      {this.statusCode, this.isSuccess, this.message, this.data});

  ResponseServiceGroup.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ServicegrpModel>[];
      json['data'].forEach((v) {
        data!.add(new ServicegrpModel.fromJson(v));
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

class ServicegrpModel {
  String? name;

  ServicegrpModel({this.name});

  ServicegrpModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

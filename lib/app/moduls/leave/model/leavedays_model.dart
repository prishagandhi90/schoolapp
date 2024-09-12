class LeaveDays {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<Data>? data;

  LeaveDays({this.statusCode, this.isSuccess, this.message, this.data});

  LeaveDays.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  // String? outValue;
  String? value;
  String? name;

  // Data({this.outValue});
  Data({this.value, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    // outValue = json['outValue'];
    value = json['outValue'];
    name = json['outValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['outValue'] = this.outValue;
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }
}

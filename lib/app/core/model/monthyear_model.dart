class MonthYear {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<Data>? data;

  MonthYear({this.statusCode, this.isSuccess, this.message, this.data});

  MonthYear.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? monthYr;

  Data({this.monthYr});

  Data.fromJson(Map<String, dynamic> json) {
    monthYr = json['monthYr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['monthYr'] = monthYr;
    return data;
  }
}

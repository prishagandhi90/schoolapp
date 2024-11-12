class ResponseGetDutyScheduleShift {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DutySchSftData>? data;

  ResponseGetDutyScheduleShift({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseGetDutyScheduleShift.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    if (json['data'] != null && json['data'] is List) {
      data = <DutySchSftData>[];
      json['data'].forEach((v) {
        data!.add(new DutySchSftData.fromJson(v));
      });
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DutySchSftData {
  String? code;
  String? name;
  List<DateColumnsValue>? dateColumnsValue;

  DutySchSftData({this.code, this.name, this.dateColumnsValue});

  DutySchSftData.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    if (json['DateColumnsValue'] != null) {
      dateColumnsValue = <DateColumnsValue>[];
      json['DateColumnsValue'].forEach((v) {
        dateColumnsValue!.add(new DateColumnsValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    if (this.dateColumnsValue != null) {
      data['DateColumnsValue'] = this.dateColumnsValue!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateColumnsValue {
  String? name;
  String? value;
  String? activeYN;

  DateColumnsValue({this.name, this.value, this.activeYN});

  DateColumnsValue.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    value = json['Value'];
    activeYN = json['ActiveYN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['ActiveYN'] = this.activeYN;
    return data;
  }
}

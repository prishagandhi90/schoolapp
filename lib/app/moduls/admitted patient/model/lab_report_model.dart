class LabReportModel {
  int? statusCode;
  String? isSuccess;
  String? message;
  Data? data;

  LabReportModel({this.statusCode, this.isSuccess, this.message, this.data});

  LabReportModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? patientName;
  String? bedNo;
  List<ReportListData>? data;

  Data({this.patientName, this.bedNo, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    patientName = json['PatientName'];
    bedNo = json['BedNo'];
    if (json['Data'] != null) {
      data = <ReportListData>[];
      json['Data'].forEach((v) {
        data!.add(ReportListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientName'] = patientName;
    data['BedNo'] = bedNo;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportListData {
  String? reportName;
  List<ReportsAllData>? data;

  ReportListData({this.reportName, this.data});

  ReportListData.fromJson(Map<String, dynamic> json) {
    reportName = json['report_name'];
    if (json['data'] != null) {
      data = <ReportsAllData>[];
      json['data'].forEach((v) {
        data!.add(ReportsAllData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['report_name'] = reportName;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportsAllData {
  String? formattest;
  String? testName;
  String? normalRange;
  String? unit;
  String? date;
  String? value;
  // String? s19JUL24021335PM;
  // String? s19JUL24121400PM;
  // String? s19JUL24021827PM;

  ReportsAllData({
    this.formattest,
    this.testName,
    this.normalRange,
    this.unit,
    // this.s19JUL24021335PM,
    // this.s19JUL24121400PM,
    // this.s19JUL24021827PM
  });

  ReportsAllData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};

    json.forEach((key, value) {
      if (key == "formattest" ||
          key == "TestName" ||
          key == "NormalRange" ||
          key == "Unit") {
        newJson[key] = value;
      } else {
        newJson["Date"] = key;
        newJson["value"] = value;
      }
    });

    json = newJson;

    formattest = json['formattest'];
    testName = json['TestName'];
    normalRange = json['NormalRange'];
    unit = json['Unit'];
    date = json['Date'];
    value = json['value'];
    // s19JUL24021335PM = json['19-JUL-24 02:13:35 PM'];
    // s19JUL24121400PM = json['19-JUL-24 12:14:00 PM'];
    // s19JUL24021827PM = json['19-JUL-24 02:18:27 PM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['formattest'] = formattest;
    data['TestName'] = testName;
    data['NormalRange'] = normalRange;
    data['Unit'] = unit;
    data['Date'] = date;
    data['value'] = value;
    // data['19-JUL-24 02:13:35 PM'] = s19JUL24021335PM;
    // data['19-JUL-24 12:14:00 PM'] = s19JUL24121400PM;
    // data['19-JUL-24 02:18:27 PM'] = s19JUL24021827PM;
    return data;
  }
}

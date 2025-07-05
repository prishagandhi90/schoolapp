class RsponsePatientlabsummarydata {
  int? statusCode;
  String? isSuccess;
  String? message;
  Data? data;

  RsponsePatientlabsummarydata({this.statusCode, this.isSuccess, this.message, this.data});

  RsponsePatientlabsummarydata.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? patientName;
  String? bedNo;
  List<LabData>? labData;

  Data({this.patientName, this.bedNo, this.labData});

  Data.fromJson(Map<String, dynamic> json) {
    patientName = json['PatientName'];
    bedNo = json['BedNo'];
    if (json['LabData'] != null) {
      labData = <LabData>[];
      json['LabData'].forEach((v) {
        labData!.add(new LabData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PatientName'] = this.patientName;
    data['BedNo'] = this.bedNo;
    if (this.labData != null) {
      data['LabData'] = this.labData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabData {
  String? formattest;
  String? testName;
  String? normalRange;
  String? unit;
  int? rowNo;
  Map<String, String?>? dateValues;

  LabData({
    this.formattest,
    this.testName,
    this.normalRange,
    this.unit,
    this.rowNo,
    this.dateValues,
  });

  LabData.fromJson(Map<String, dynamic> json) {
    formattest = json['formattest'];
    testName = json['TestName'];
    normalRange = json['NormalRange'];
    unit = json['Unit'];
    rowNo = json['RowNo'];
    // ✅ Extract dynamic date columns
    dateValues = {};
    json.forEach((key, value) {
      if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(key)) {
        dateValues![key] = value?.toString(); // Store only date fields
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formattest'] = this.formattest;
    data['TestName'] = this.testName;
    data['NormalRange'] = this.normalRange;
    data['Unit'] = this.unit;
    data['RowNo'] = this.rowNo;
    if (dateValues != null) {
      data.addAll(dateValues!); // ✅ Add all date values dynamically
    }
    return data;
  }
}

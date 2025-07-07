class ResponseHeaderList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<HeaderList>? data;

  ResponseHeaderList({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseHeaderList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <HeaderList>[];
      json['data'].forEach((v) {
        data!.add(new HeaderList.fromJson(v));
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

class HeaderList {
  String? department;
  String? subDept;
  String? deptInc;
  String? deptHOD;
  String? subDeptInc;

  HeaderList({this.department, this.subDept, this.deptInc, this.deptHOD, this.subDeptInc});

  HeaderList.fromJson(Map<String, dynamic> json) {
    department = json['department'];
    subDept = json['subDept'];
    deptInc = json['deptInc'];
    deptHOD = json['deptHOD'];
    subDeptInc = json['subDeptInc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department'] = this.department;
    data['subDept'] = this.subDept;
    data['deptInc'] = this.deptInc;
    data['deptHOD'] = this.deptHOD;
    data['subDeptInc'] = this.subDeptInc;
    return data;
  }
}

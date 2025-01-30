class ResponseLeaveNames {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LeaveNamesTable>? data;

  ResponseLeaveNames({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseLeaveNames.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <LeaveNamesTable>[];
      json['data'].forEach((v) {
        data!.add(new LeaveNamesTable.fromJson(v));
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

class LeaveNamesTable {
  String? value;
  String? name;

  LeaveNamesTable({this.value, this.name});

  LeaveNamesTable.fromJson(Map<String, dynamic> json) {
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

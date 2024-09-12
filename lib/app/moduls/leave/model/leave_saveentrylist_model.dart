class ResponseSaveLeaveEntryList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<SaveLeaveEntryList>? data;

  ResponseSaveLeaveEntryList(
      {this.statusCode, this.isSuccess, this.message, this.data});

  ResponseSaveLeaveEntryList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SaveLeaveEntryList>[];
      json['data'].forEach((v) {
        data!.add(new SaveLeaveEntryList.fromJson(v));
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

class SaveLeaveEntryList {
  String? savedYN;

  SaveLeaveEntryList({this.savedYN});

  SaveLeaveEntryList.fromJson(Map<String, dynamic> json) {
    savedYN = json['savedYN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['savedYN'] = this.savedYN;
    return data;
  }
}

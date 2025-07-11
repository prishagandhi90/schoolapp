class ResponseGetHistoryList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<GethistoryModelList>? data;

  ResponseGetHistoryList({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseGetHistoryList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GethistoryModelList>[];
      json['data'].forEach((v) {
        data!.add(new GethistoryModelList.fromJson(v));
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

class GethistoryModelList {
  int? requisitionNo;
  String? date;
  String? investigationType;
  String? investigationPriority;
  String? entryDate;
  String? user;

  GethistoryModelList({this.requisitionNo, this.date, this.investigationType, this.investigationPriority, this.entryDate, this.user});

  GethistoryModelList.fromJson(Map<String, dynamic> json) {
    requisitionNo = json['requisitionNo'];
    date = json['date'];
    investigationType = json['investigationType'];
    investigationPriority = json['investigationPriority'];
    entryDate = json['entryDate'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requisitionNo'] = this.requisitionNo;
    data['date'] = this.date;
    data['investigationType'] = this.investigationType;
    data['investigationPriority'] = this.investigationPriority;
    data['entryDate'] = this.entryDate;
    data['user'] = this.user;
    return data;
  }
}

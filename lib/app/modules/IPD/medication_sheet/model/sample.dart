class OperationNameModel {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<OperationNameList>? data;

  OperationNameModel(
      {this.statusCode, this.isSuccess, this.message, this.data});

  OperationNameModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      if (json['data'].runtimeType == List) {
        data = <OperationNameList>[];
        json['data'].forEach((v) {
          data!.add(OperationNameList.fromJson(v));
        });
      } else {
        data = [];
      }
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

class OperationNameList {
  int? id;
  String? operationName;

  OperationNameList({this.id, this.operationName});

  OperationNameList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operationName = json['operationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operationName'] = operationName;
    return data;
  }
}

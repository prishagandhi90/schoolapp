class ResponseNotificationfile {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<NotificationfileModel>? data;

  ResponseNotificationfile(
      {this.statusCode, this.isSuccess, this.message, this.data});

  ResponseNotificationfile.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationfileModel>[];
      json['data'].forEach((v) {
        data!.add(new NotificationfileModel.fromJson(v));
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

class NotificationfileModel {
  String? fileName;
  String? contentType;
  String? fileContent;

  NotificationfileModel({this.fileName, this.contentType, this.fileContent});

  NotificationfileModel.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    contentType = json['contentType'];
    fileContent = json['fileContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['contentType'] = this.contentType;
    data['fileContent'] = this.fileContent;
    return data;
  }
}

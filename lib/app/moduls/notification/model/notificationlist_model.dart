class ResponseNotificationList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<NotificationlistModel>? data;

  ResponseNotificationList({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseNotificationList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationlistModel>[];
      json['data'].forEach((v) {
        data!.add(new NotificationlistModel.fromJson(v));
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

class NotificationlistModel {
  int? id;
  String? appName;
  String? notificationType;
  String? messageType;
  String? sender;
  String? messageTitle;
  String? message;
  String? fileYN;
  String? createdDate;
  String? scheduleDate;
  String? inactiveDate;
  String? sendToAll;
  String? createdBy;
  String? boldYN;

  NotificationlistModel(
      {this.id,
      this.appName,
      this.notificationType,
      this.messageType,
      this.sender,
      this.messageTitle,
      this.message,
      this.fileYN,
      this.createdDate,
      this.scheduleDate,
      this.inactiveDate,
      this.sendToAll,
      this.createdBy,
      this.boldYN});

  NotificationlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appName = json['appName'];
    notificationType = json['notificationType'];
    messageType = json['messageType'];
    sender = json['sender'];
    messageTitle = json['messageTitle'];
    message = json['message'];
    fileYN = json['fileYN'];
    createdDate = json['createdDate'];
    scheduleDate = json['scheduleDate'];
    inactiveDate = json['inactiveDate'];
    sendToAll = json['sendToAll'];
    createdBy = json['createdBy'];
    boldYN = json['boldYN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appName'] = this.appName;
    data['notificationType'] = this.notificationType;
    data['messageType'] = this.messageType;
    data['sender'] = this.sender;
    data['messageTitle'] = this.messageTitle;
    data['message'] = this.message;
    data['fileYN'] = this.fileYN;
    data['createdDate'] = this.createdDate;
    data['scheduleDate'] = this.scheduleDate;
    data['inactiveDate'] = this.inactiveDate;
    data['sendToAll'] = this.sendToAll;
    data['createdBy'] = this.createdBy;
    data['boldYN'] = this.boldYN;
    return data;
  }
}

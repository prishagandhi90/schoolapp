class ResponseModuleData {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<ModuleScreenRights>? data;

  ResponseModuleData({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseModuleData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <ModuleScreenRights>[];
      json['data'].forEach((v) {
        data!.add(ModuleScreenRights.fromJson(v));
      });
    } else {
      data = [];
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

class ModuleScreenRights {
  int? id;
  String? moduleName;
  String? screenName;
  int? moduleSeq;
  int? screenSeq;
  String? imagePath;
  String? rightsYN;
  String? inactiveYN;

  ModuleScreenRights({
    this.id,
    this.moduleName,
    this.screenName,
    this.moduleSeq,
    this.screenSeq,
    this.imagePath,
    this.rightsYN,
    this.inactiveYN,
  });

  ModuleScreenRights.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['moduleName'];
    screenName = json['screenName'];
    moduleSeq = json['moduleSeq'];
    screenSeq = json['screenSeq'];
    imagePath = json['imagePath'];
    rightsYN = json['rightsYN'];
    inactiveYN = json['inactiveYN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['moduleName'] = moduleName;
    data['screenName'] = screenName;
    data['moduleSeq'] = moduleSeq;
    data['screenSeq'] = screenSeq;
    data['imagePath'] = imagePath;
    data['rightsYN'] = rightsYN;
    data['inactiveYN'] = inactiveYN;
    return data;
  }
}

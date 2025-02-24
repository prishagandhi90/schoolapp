class AdpatientFilterModel {
  int? statusCode;
  String? isSuccess;
  String? message;
  filterpatientModel? data;

  AdpatientFilterModel({this.statusCode, this.isSuccess, this.message, this.data});

  AdpatientFilterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = json['data'] != null ? new filterpatientModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class filterpatientModel {
  List<Orgs>? orgs;
  List<Floors>? floors;
  List<Wards>? wards;

  filterpatientModel({this.orgs, this.floors, this.wards});

  filterpatientModel.fromJson(Map<String, dynamic> json) {
    if (json['orgs'] != null) {
      orgs = <Orgs>[];
      json['orgs'].forEach((v) {
        orgs!.add(new Orgs.fromJson(v));
      });
    }
    if (json['floors'] != null) {
      floors = <Floors>[];
      json['floors'].forEach((v) {
        floors!.add(new Floors.fromJson(v));
      });
    }
    if (json['wards'] != null) {
      wards = <Wards>[];
      json['wards'].forEach((v) {
        wards!.add(new Wards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orgs != null) {
      data['orgs'] = this.orgs!.map((v) => v.toJson()).toList();
    }
    if (this.floors != null) {
      data['floors'] = this.floors!.map((v) => v.toJson()).toList();
    }
    if (this.wards != null) {
      data['wards'] = this.wards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orgs {
  String? isValidToken;
  String? organization;

  Orgs({this.isValidToken, this.organization});

  Orgs.fromJson(Map<String, dynamic> json) {
    isValidToken = json['isValidToken'];
    organization = json['organization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isValidToken'] = this.isValidToken;
    data['organization'] = this.organization;
    return data;
  }
}

class Floors {
  String? isValidToken;
  int? floorId;
  String? floorName;

  Floors({this.isValidToken, this.floorId, this.floorName});

  Floors.fromJson(Map<String, dynamic> json) {
    isValidToken = json['isValidToken'];
    floorId = json['floorId'];
    floorName = json['floorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isValidToken'] = this.isValidToken;
    data['floorId'] = this.floorId;
    data['floorName'] = this.floorName;
    return data;
  }
}

class Wards {
  String? isValidToken;
  int? wardId;
  String? wardName;

  Wards({this.isValidToken, this.wardId, this.wardName});

  Wards.fromJson(Map<String, dynamic> json) {
    isValidToken = json['isValidToken'];
    wardId = json['wardId'];
    wardName = json['wardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isValidToken'] = this.isValidToken;
    data['wardId'] = this.wardId;
    data['wardName'] = this.wardName;
    return data;
  }
}

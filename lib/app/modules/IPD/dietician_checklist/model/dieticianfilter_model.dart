class DieticianfilterModel {
  int? statusCode;
  String? isSuccess;
  String? message;
  Data? data;

  DieticianfilterModel({this.statusCode, this.isSuccess, this.message, this.data});

  DieticianfilterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<Wards>? wards;
  List<Floors>? floors;
  List<Beds>? beds;

  Data({this.wards, this.floors, this.beds});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['wards'] != null) {
      wards = <Wards>[];
      json['wards'].forEach((v) {
        wards!.add(new Wards.fromJson(v));
      });
    }
    if (json['floors'] != null) {
      floors = <Floors>[];
      json['floors'].forEach((v) {
        floors!.add(new Floors.fromJson(v));
      });
    }
    if (json['beds'] != null) {
      beds = <Beds>[];
      json['beds'].forEach((v) {
        beds!.add(new Beds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wards != null) {
      data['wards'] = this.wards!.map((v) => v.toJson()).toList();
    }
    if (this.floors != null) {
      data['floors'] = this.floors!.map((v) => v.toJson()).toList();
    }
    if (this.beds != null) {
      data['beds'] = this.beds!.map((v) => v.toJson()).toList();
    }
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

class Beds {
  int? bedId;
  String? bedName;

  Beds({this.bedId, this.bedName});

  Beds.fromJson(Map<String, dynamic> json) {
    bedId = json['bedId'];
    bedName = json['bedName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bedId'] = this.bedId;
    data['bedName'] = this.bedName;
    return data;
  }
}

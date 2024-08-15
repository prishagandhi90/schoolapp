class Attendencetable {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<Data>? data;

  Attendencetable({this.statusCode, this.isSuccess, this.message, this.data});

  Attendencetable.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? mntHYR;
  int? empLCD;
  String? atTDATE;
  String? iN;
  String? out;
  String? punch;
  String? shift;
  String? lv;
  String? st;
  String? oTENTMIN;
  String? oTMIN;
  String? lc;
  String? eg;
  String? lCEGMIN;

  Data(
      {this.mntHYR,
      this.empLCD,
      this.atTDATE,
      this.iN,
      this.out,
      this.punch,
      this.shift,
      this.lv,
      this.st,
      this.oTENTMIN,
      this.oTMIN,
      this.lc,
      this.eg,
      this.lCEGMIN});

  Data.fromJson(Map<String, dynamic> json) {
    mntHYR = json['mntH_YR'];
    empLCD = json['empL_CD'];
    atTDATE = json['atT_DATE'];
    iN = json['iN_'];
    out = json['out'];
    punch = json['punch'];
    shift = json['shift'];
    lv = json['lv'];
    st = json['st'];
    oTENTMIN = json['oT_ENT_MIN'];
    oTMIN = json['oT_MIN'];
    lc = json['lc'];
    eg = json['eg'];
    lCEGMIN = json['lC_EG_MIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mntH_YR'] = this.mntHYR;
    data['empL_CD'] = this.empLCD;
    data['atT_DATE'] = this.atTDATE;
    data['iN_'] = this.iN;
    data['out'] = this.out;
    data['punch'] = this.punch;
    data['shift'] = this.shift;
    data['lv'] = this.lv;
    data['st'] = this.st;
    data['oT_ENT_MIN'] = this.oTENTMIN;
    data['oT_MIN'] = this.oTMIN;
    data['lc'] = this.lc;
    data['eg'] = this.eg;
    data['lC_EG_MIN'] = this.lCEGMIN;
    return data;
  }
}

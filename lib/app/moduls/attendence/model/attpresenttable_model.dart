class AttendenceSummarytable {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<Data>? data;

  AttendenceSummarytable(
      {this.statusCode, this.isSuccess, this.message, this.data});

  AttendenceSummarytable.fromJson(Map<String, dynamic> json) {
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
  int? toTP;
  int? toTA;
  int? toTDAYS;
  int? p;
  int? a;
  int? wo;
  int? co;
  double? pl;
  int? sl;
  int? cl;
  double? ho;
  int? ml;
  int? ch;
  int? lCEGMIN;
  int? lCEGCNT;
  int? nOTHRS;
  int? cOTHRS;
  int? ttLOTHRS;
  String? dutYHRS;
  String? dutYST;

  Data(
      {this.toTP,
      this.toTA,
      this.toTDAYS,
      this.p,
      this.a,
      this.wo,
      this.co,
      this.pl,
      this.sl,
      this.cl,
      this.ho,
      this.ml,
      this.ch,
      this.lCEGMIN,
      this.lCEGCNT,
      this.nOTHRS,
      this.cOTHRS,
      this.ttLOTHRS,
      this.dutYHRS,
      this.dutYST});

  Data.fromJson(Map<String, dynamic> json) {
    toTP = json['toT_P'];
    toTA = json['toT_A'];
    toTDAYS = json['toT_DAYS'];
    p = json['p'];
    a = json['a'];
    wo = json['wo'];
    co = json['co'];
    pl = json['pl'];
    sl = json['sl'];
    cl = json['cl'];
    ho = json['ho'];
    ml = json['ml'];
    ch = json['ch'];
    lCEGMIN = json['lC_EG_MIN'];
    lCEGCNT = json['lC_EG_CNT'];
    nOTHRS = json['n_OT_HRS'];
    cOTHRS = json['c_OT_HRS'];
    ttLOTHRS = json['ttL_OT_HRS'];
    dutYHRS = json['dutY_HRS'];
    dutYST = json['dutY_ST'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toT_P'] = this.toTP;
    data['toT_A'] = this.toTA;
    data['toT_DAYS'] = this.toTDAYS;
    data['p'] = this.p;
    data['a'] = this.a;
    data['wo'] = this.wo;
    data['co'] = this.co;
    data['pl'] = this.pl;
    data['sl'] = this.sl;
    data['cl'] = this.cl;
    data['ho'] = this.ho;
    data['ml'] = this.ml;
    data['ch'] = this.ch;
    data['lC_EG_MIN'] = this.lCEGMIN;
    data['lC_EG_CNT'] = this.lCEGCNT;
    data['n_OT_HRS'] = this.nOTHRS;
    data['c_OT_HRS'] = this.cOTHRS;
    data['ttL_OT_HRS'] = this.ttLOTHRS;
    data['dutY_HRS'] = this.dutYHRS;
    data['dutY_ST'] = this.dutYST;
    return data;
  }
}

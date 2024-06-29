class Attendencetable {
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

  Attendencetable(
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

  Attendencetable.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mntH_YR'] = mntHYR;
    data['empL_CD'] = empLCD;
    data['atT_DATE'] = atTDATE;
    data['iN_'] = iN;
    data['out'] = out;
    data['punch'] = punch;
    data['shift'] = shift;
    data['lv'] = lv;
    data['st'] = st;
    data['oT_ENT_MIN'] = oTENTMIN;
    data['oT_MIN'] = oTMIN;
    data['lc'] = lc;
    data['eg'] = eg;
    data['lC_EG_MIN'] = lCEGMIN;
    return data;
  }
}

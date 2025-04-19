class ResponseForceUpdate {
  String? versionName;
  String? forceUpdYN;

  ResponseForceUpdate({this.versionName, this.forceUpdYN});

  ResponseForceUpdate.fromJson(Map<String, dynamic> json) {
    versionName = json['versionName'];
    forceUpdYN = json['forceUpdYN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['versionName'] = this.versionName;
    data['forceUpdYN'] = this.forceUpdYN;
    return data;
  }
}

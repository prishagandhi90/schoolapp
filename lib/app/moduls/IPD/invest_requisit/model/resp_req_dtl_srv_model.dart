class Resp_DelReqDtlSrv_model {
  final int statusCode;
  final String isSuccess;
  final String message;
  final Map<String, dynamic> data;

  Resp_DelReqDtlSrv_model({
    required this.statusCode,
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory Resp_DelReqDtlSrv_model.fromJson(Map<String, dynamic> json) {
    return Resp_DelReqDtlSrv_model(
      statusCode: json['statusCode'] ?? 0,
      isSuccess: json['isSuccess'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'isSuccess': isSuccess,
      'message': message,
      'data': data,
    };
  }
}

class ResponseData {
  late int code;
  late String message;

  ResponseData({
    required this.code,
    required this.message,
  });

  ResponseData.fromJson(Map<dynamic, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

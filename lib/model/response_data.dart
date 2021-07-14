class ResponseData {
  late int code;
  late String message;
  late dynamic data;

  ResponseData({
    required this.code,
    required this.message,
    required this.data,
  });

  ResponseData.fromJson(Map<dynamic, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}

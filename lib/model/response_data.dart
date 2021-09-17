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

class BienSoXe {
  late String name;
  BienSoXe({
    required this.name,
  });

  BienSoXe.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Employee {
  late String name;

  late String employeeName;
  late String userId;
  Employee({
    required this.name,
    required this.employeeName,
    required this.userId,
  });

  Employee.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    employeeName = json['employee_name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['employee_name'] = this.employeeName;
    data['user_id'] = this.userId;
    return data;
  }
}

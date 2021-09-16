import 'package:frappe_app/model/response_data.dart';

class PhanKho12 {
  late String company;
  late List<PhanKho12Members> incharge1;
  late List<PhanKho12Members> incharge2;
  PhanKho12(this.company, this.incharge1, this.incharge2);

  PhanKho12.fromJson(Map<dynamic, dynamic> json) {
    company = json['company'];
    incharge1 = json['incharge_1'] != null
        ? (json['incharge_1'] as List<dynamic>).map((e) {
            return PhanKho12Members.fromJson(e);
          }).toList()
        : [];
    incharge2 = json['incharge_2'] != null
        ? (json['incharge_2'] as List<dynamic>).map((e) {
            return PhanKho12Members.fromJson(e);
          }).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company;
    final List<Map<String, dynamic>> incharge1Map =
        incharge1 != null ? incharge1.map((e) => e.toJson()).toList() : [];

    final List<Map<String, dynamic>> incharge2Map =
        incharge2 != null ? incharge2.map((e) => e.toJson()).toList() : [];
    data['incharge_1'] = incharge1Map;
    data['incharge_2'] = incharge2Map;
    return data;
  }
}

class PhanKho12Members {
  late String account;
  late String code;
  late String fullName;

  PhanKho12Members(this.account, this.fullName, this.code);

  PhanKho12Members.fromJson(Map<dynamic, dynamic> json) {
    account = json['account'];
    code = json['code'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['code'] = this.code;
    data['full_name'] = this.fullName;
    return data;
  }
}

class PhanKho12Response {
  PhanKho12Response({this.responseData});

  late ResponseData? responseData;

  PhanKho12Response.fromJson(Map<String, dynamic> json) {
    responseData = json['message'] != null
        ? ResponseData.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

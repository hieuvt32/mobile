import 'package:frappe_app/model/response_data.dart';

class HoaDonMuaBanHiddenStatus {
  late String order;
  late String status;
  late String realName;

  HoaDonMuaBanHiddenStatus(this.order, this.status, this.realName);

  HoaDonMuaBanHiddenStatus.fromJson(Map<dynamic, dynamic> json) {
    order = json['order'];
    status = json['status'];
    realName = json['real_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['status'] = this.status;
    data['real_name'] = this.realName;
    return data;
  }
}

class HoaDonMuaBanHiddenStatusResponse {
  HoaDonMuaBanHiddenStatusResponse({this.responseData});

  late ResponseData? responseData;

  HoaDonMuaBanHiddenStatusResponse.fromJson(Map<String, dynamic> json) {
    responseData = json['message'] != null
        ? ResponseData.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

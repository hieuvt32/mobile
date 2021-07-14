import 'package:frappe_app/model/response_data.dart';

class UpdateLichSuSanXuatResponse {
  UpdateLichSuSanXuatResponse({this.responseData});

  late ResponseData? responseData;

  UpdateLichSuSanXuatResponse.fromJson(Map<String, dynamic> json) {
    responseData = json['message'] != null
        ? ResponseData.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

import 'package:frappe_app/model/response_data.dart';

class UpdateBienBanKiemKhoResponse {
  UpdateBienBanKiemKhoResponse({this.responseData});

  late ResponseData? responseData;

  UpdateBienBanKiemKhoResponse.fromJson(Map<String, dynamic> json) {
    responseData = json['message'] != null
        ? ResponseData.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

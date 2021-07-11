import 'package:frappe_app/model/response_data.dart';

class UpdateTrangThaiQuyChuanResponse {
  UpdateTrangThaiQuyChuanResponse({this.responseData});

  late ResponseData? responseData;

  UpdateTrangThaiQuyChuanResponse.fromJson(Map<String, dynamic> json) {
    responseData = json['message'] != null
        ? ResponseData.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

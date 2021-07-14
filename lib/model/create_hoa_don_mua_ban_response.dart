import 'package:frappe_app/model/response_data.dart';

class CreateHoaDonMuaBanRespone {
  CreateHoaDonMuaBanRespone({required this.responseData});

  late ResponseData responseData;

  CreateHoaDonMuaBanRespone.fromJson(Map<String, dynamic> json) {
    responseData =
        ResponseData.fromJson(json['message'] as Map<String, dynamic>);
  }
}

class UpdateHoaDonMuaBanRespone {
  UpdateHoaDonMuaBanRespone({required this.responseData});

  late ResponseData responseData;

  UpdateHoaDonMuaBanRespone.fromJson(Map<String, dynamic> json) {
    responseData =
        ResponseData.fromJson(json['message'] as Map<String, dynamic>);
  }
}

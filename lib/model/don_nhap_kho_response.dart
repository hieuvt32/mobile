import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/response_data.dart';

class CreateDonNhapKhoResponse {
  ResponseData? responseData;
  CreateDonNhapKhoResponse({this.responseData});

  CreateDonNhapKhoResponse.fromJson(Map<String, dynamic> json) {
    responseData =
        ResponseData.fromJson(json['message'] as Map<String, dynamic>);
  }
}

class UpdateDonNhapKhoResponse {
  ResponseData? responseData;
  UpdateDonNhapKhoResponse({this.responseData});

  UpdateDonNhapKhoResponse.fromJson(Map<String, dynamic> json) {
    responseData =
        ResponseData.fromJson(json['message'] as Map<String, dynamic>);
  }
}

class GetSingleDonNhapKhoResponse {
  DonNhapKho? donNhapKho;
  GetSingleDonNhapKhoResponse({this.donNhapKho});

  GetSingleDonNhapKhoResponse.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null)
      donNhapKho = DonNhapKho.fromJson(json['message'] as Map<String, dynamic>);
  }
}

import 'package:frappe_app/model/bien_ban_kiem_kho.dart';

class GetBienBanKiemKhoResponse {
  BienBanKiemKho? bienBanKiemKho;
  GetBienBanKiemKhoResponse({this.bienBanKiemKho});

  GetBienBanKiemKhoResponse.fromJson(Map<String, dynamic> json) {
    dynamic jsonFromMessage = json['message'];
    if (jsonFromMessage['data'] != null)
      bienBanKiemKho = BienBanKiemKho.fromJson(jsonFromMessage['data']);
  }
}

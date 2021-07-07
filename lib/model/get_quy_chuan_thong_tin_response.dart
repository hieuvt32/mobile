import 'package:frappe_app/model/quy_chuan_thong_tin.dart';

class GetQuyChuanThongTinResponse {
  GetQuyChuanThongTinResponse({this.quyChuanThongTin});

  late QuyChuanThongTin? quyChuanThongTin;

  GetQuyChuanThongTinResponse.fromJson(Map<String, dynamic> json) {
    quyChuanThongTin = json['message'] != null
        ? QuyChuanThongTin.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

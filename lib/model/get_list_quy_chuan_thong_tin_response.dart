import 'package:frappe_app/model/report_quy_chuan_thong_tin.dart';

class GetListQuyChuanThongTinResponse {
  GetListQuyChuanThongTinResponse({this.reportQuyChuanThongTins});

  late List<ReportQuyChuanThongTin>? reportQuyChuanThongTins;

  GetListQuyChuanThongTinResponse.fromJson(Map<String, dynamic> json) {
    reportQuyChuanThongTins = (json['message'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return ReportQuyChuanThongTin.fromJson(castValue);
    }).toList();
  }
}

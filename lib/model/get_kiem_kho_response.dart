import 'package:frappe_app/model/bang_thong_ke_kho.dart';

class GetKiemKhoResponse {
  GetKiemKhoResponse({this.thongKeKhos});

  late List<BangThongKeKho>? thongKeKhos;

  GetKiemKhoResponse.fromJson(Map<String, dynamic> json) {
    thongKeKhos = (json['message'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return BangThongKeKho.fromJson(castValue);
    }).toList();
  }
}

import 'package:frappe_app/model/lich_su_san_xuat.dart';

class UpdateLichSuSanXuatResponse {
  UpdateLichSuSanXuatResponse({this.lichSuSanXuat});

  late LichSuSanXuat? lichSuSanXuat;

  UpdateLichSuSanXuatResponse.fromJson(Map<String, dynamic> json) {
    lichSuSanXuat = json['message'] != null
        ? LichSuSanXuat.fromJson(json['message'] as Map<String, dynamic>)
        : null;
  }
}

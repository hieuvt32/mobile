import 'nguyen_vat_lieu_san_pham.dart';

class GetNguyenVatLieuSanPhamResponse {
  List<NguyenVatLieuSanPham>? nguyenVatLieuSanPhams;
  GetNguyenVatLieuSanPhamResponse({this.nguyenVatLieuSanPhams});

  GetNguyenVatLieuSanPhamResponse.fromJson(Map<String, dynamic> json) {
    nguyenVatLieuSanPhams = (json['message'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return NguyenVatLieuSanPham.fromJson(castValue);
    }).toList();
  }
}

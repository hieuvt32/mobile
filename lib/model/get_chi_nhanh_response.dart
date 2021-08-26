class DanhSachChiNhanhResponse {
  late List<String> listChiNhanh;

  DanhSachChiNhanhResponse.fromJson(Map<String, dynamic> json) {
    listChiNhanh = (json['message']['data'] as List<dynamic>)
        .map((e) => e[0].toString())
        .toList();
  }
}

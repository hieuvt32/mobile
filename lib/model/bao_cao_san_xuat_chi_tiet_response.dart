class BaoCaoSanXuatChiTietResponse {
  late List<BaoCaoSanXuatChiTiet> listBaoCaoSanXuatChiTiet;
  BaoCaoSanXuatChiTietResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];
    listBaoCaoSanXuatChiTiet = (data as List<dynamic>)
        .map((e) => BaoCaoSanXuatChiTiet.fromJson(e))
        .toList();
  }
}

class BaoCaoSanXuatChiTiet {
  late String product;
  late int amount;

  BaoCaoSanXuatChiTiet.fromJson(Map<String, dynamic> json) {
    product = json['Sản phẩm'];
    amount = json['Value'];
  }
}

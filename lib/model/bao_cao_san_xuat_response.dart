class BaoCaoSanXuatResponse {
  late List<BaoCaoSanXuat> listBaoCaoSanXuat;

  BaoCaoSanXuatResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];
    listBaoCaoSanXuat =
        (data as List<dynamic>).map((e) => BaoCaoSanXuat.fromJson(e)).toList();
  }
}

class BaoCaoSanXuat {
  late String company;
  late double value;

  BaoCaoSanXuat.fromJson(Map<String, dynamic> json) {
    company = json['công ty'];
    value = json['Value'];
  }
}

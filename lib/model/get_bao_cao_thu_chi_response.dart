class BaoCaoThuChiResponse {
  late List<BaoCaoThuChi> listBaoCaoThuChi;

  BaoCaoThuChiResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message'];
    listBaoCaoThuChi = (data as List<dynamic>).map((e) {
      return BaoCaoThuChi.fromJson(e);
    }).toList();
  }
}

class BaoCaoThuChi {
  late String date;
  late double noNhaCungCap;
  late double khNo;
  late double thu;
  late double chi;

  BaoCaoThuChi.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    noNhaCungCap = json['Nợ nhà cung cấp'];
    khNo = json['Khác hàng nợ'];
    thu = json['Thu'];
    chi = json['Chi'];
  }
}

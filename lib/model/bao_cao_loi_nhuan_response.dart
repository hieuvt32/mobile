class BaoCaoLoiNhuanResponse {
  late List<BaoCaoLoiNhuan> listProfitReport;

  BaoCaoLoiNhuanResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];
    listProfitReport = (data as List<dynamic>).map((e) {
      return BaoCaoLoiNhuan.fromJson(e);
    }).toList();
  }
}

class BaoCaoLoiNhuan {
  late String date;
  late double profit;

  BaoCaoLoiNhuan({required this.date, required this.profit});

  BaoCaoLoiNhuan.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    profit = json['Lợi nhuận'];
  }
}

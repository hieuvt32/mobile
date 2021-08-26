class BaoCaoChiTieuKhachHang {
  late int totalOrder;
  late double totalAmount;
  late double totalPaidAmount;
  late double totalOwedAmount;

  BaoCaoChiTieuKhachHang(
      {required this.totalOwedAmount,
      required this.totalPaidAmount,
      required this.totalOrder,
      required this.totalAmount});

  BaoCaoChiTieuKhachHang.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];
    totalOrder = data["Tổng số hóa đơn"];
    totalAmount = data["Tổng tiền hàng"];
    totalPaidAmount = data["Tổng tiền đã trả"];
    totalOwedAmount = data["Tổng tiền còn nợ"];
  }
}

class ChartChiTieuKHResponse {
  late List<ChiTieuModel> chiTieuReportData = [];

  ChartChiTieuKHResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];
    chiTieuReportData = (data as List<dynamic>).map((e) {
      return ChiTieuModel.fromJson(e);
    }).toList();
  }
}

class ChiTieuModel {
  late String accountingDate;
  late double amount;

  ChiTieuModel.fromJson(Map<String, dynamic> json) {
    accountingDate = json['accounting_date'];
    amount = json['value'];
  }
}

class ChiTieuDetailKHResponse {
  late List<ChiTieuDetailModel> listChiTieuDetail = [];

  ChiTieuDetailKHResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];

    (data as List<dynamic>).forEach((obj) {
      (obj['Chi tiết'] as List<dynamic>).forEach((value) {
        listChiTieuDetail.add(ChiTieuDetailModel(
            ngay: value['Ngày'],
            tongNo: value['Tổng nợ'].toString(),
            chi: value['Chi'].toString(),
            duNo: value['Dư nợ'].toString()));
      });

      listChiTieuDetail.add(ChiTieuDetailModel(
          ngay: "Chuyển", chi: "", tongNo: "", duNo: obj["Chuyển"].toString()));
    });
  }
}

class ChiTieuDetailModel {
  late String ngay;
  late String tongNo;
  late String chi;
  late String duNo;

  ChiTieuDetailModel(
      {required this.ngay,
      required this.tongNo,
      required this.chi,
      required this.duNo});

  ChiTieuDetailModel.fromJson(Map<String, dynamic> json) {
    ngay = json["Ngày"];
    tongNo = json["Tổng nợ"];
    chi = json["Chi"];
    duNo = json['Dư nợ'];
  }
}

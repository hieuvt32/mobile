class BaoCaoChiTieuKhachHang {
  late int totalOrder;
  late double totalAmount;
  late double totalPaidAmount;
  late double totalOwedAmount;

  BaoCaoChiTieuKhachHang.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['data'];
    totalOrder = data["Tổng số hóa đơn"];
    totalAmount = data["Tổng tiền hàng"];
    totalPaidAmount = data["Tổng tiền đã trả"];
    totalOwedAmount = data["Tổng tiền còn nợ"];
  }
}

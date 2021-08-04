class BaoCaoCongNo {
  late String sanpham;
  late String nhan;
  late String tra;
  late String no;
  late String kg;
  BaoCaoCongNo({
    required this.sanpham,
    required this.tra,
    required this.no,
    required this.nhan,
    required this.kg,
  });
}

class ListBaoCaoCongNoKH {
  List<BaoCaoCongNo>? listBaoCaoCongNo;

  ListBaoCaoCongNoKH.fromJson(Map<String, dynamic> json) {
    try {
      dynamic data = json['message']['data'];
      List<String> listKey = data.keys.toList() as List<String>;

      listBaoCaoCongNo = listKey.map((key) {
        List<dynamic> reports = data[key] as List<dynamic>;

        String sanpham = key;
        String nhan = reports[0].toString();
        String tra = reports[1].toString();
        String no = reports[2].toString();
        String kg = reports[3].toString();
        BaoCaoCongNo baoCaoCongNo = BaoCaoCongNo(
            sanpham: sanpham, nhan: nhan, tra: tra, no: no, kg: kg);

        return baoCaoCongNo;
      }).toList();
    } catch (err) {
      print(err);
    }
  }
}

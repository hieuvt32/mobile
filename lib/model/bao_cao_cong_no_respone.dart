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
    dynamic data = json['message']['data'];
    List<String> listKey = data.keys.toList() as List<String>;

    listBaoCaoCongNo = listKey.map((key) {
      String sanpham = key;
      String nhan = data[key][0];
      String tra = data[key][1];
      String no = data[key][2];
      String kg = data[key][3];
      BaoCaoCongNo baoCaoCongNo =
          BaoCaoCongNo(sanpham: sanpham, nhan: nhan, tra: tra, no: no, kg: kg);

      return baoCaoCongNo;
    }).toList();
  }
}

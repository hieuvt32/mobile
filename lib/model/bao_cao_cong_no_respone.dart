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
      throw err;
    }
  }
}

class ListBaoCaoCongNoDetail {
  List<BaoCaoCongNoDetail>? listBaocaoCongNoDetail;

  ListBaoCaoCongNoDetail.fromJson(Map<String, dynamic> json) {
    try {
      dynamic data = json['message']['data'];
      List<BaoCaoCongNoDetail> listTemp = [];
      List<String> keys = data.keys.toList() as List<String>;

      keys.forEach((key) {
        dynamic objectData = data[key];
        String childKey = (objectData.keys.toList() as List<String>)[0];
        List<dynamic> reports = objectData[childKey] as List<dynamic>;

        reports.forEach((element) {
          List<dynamic> report = element;
          listTemp.add(BaoCaoCongNoDetail(
              date: report[0].toString(),
              nhan: report[1].toString(),
              tra: report[2].toString(),
              no: report[3].toString(),
              kg: report[4].toString(),
              sanpham: ''));
        });

        listTemp.add(BaoCaoCongNoDetail(
            no: childKey,
            date: 'Chuyển',
            nhan: '',
            sanpham: '',
            kg: '',
            tra: ''));
      });

      listBaocaoCongNoDetail = listTemp;
    } catch (er) {
      print(er);
    }
  }
}

class BaoCaoCongNoDetail extends BaoCaoCongNo {
  late String date;

  BaoCaoCongNoDetail(
      {required this.date,
      required String sanpham,
      required String nhan,
      required String no,
      required String tra,
      required String kg})
      : super(kg: kg, nhan: nhan, no: no, sanpham: sanpham, tra: tra);
}

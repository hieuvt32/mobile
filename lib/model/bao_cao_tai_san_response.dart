class BaoCaoTaiSanResponse {
  late List<BaoCaoTaiSan> listBaoCao;

  BaoCaoTaiSanResponse.fromJson(Map<String, dynamic> json) {
    try {
      dynamic data = json['message']['data'];
      listBaoCao = (data as List<dynamic>).map((e) {
        return BaoCaoTaiSan(
            code: e[0].toString(),
            name: e[1].toString(),
            nhan: e[2].toString(),
            kg: e[3].toString(),
            tra: e[4].toString(),
            no: e[5].toString());
      }).toList();
    } catch (err) {
      print(err);
    }
  }
}

class BaoCaoTaiSan {
  late String code;
  late String name;
  late String nhan;
  late String kg;
  late String tra;
  late String no;

  BaoCaoTaiSan({
    required this.code,
    required this.name,
    required this.tra,
    required this.no,
    required this.nhan,
    required this.kg,
  });
}

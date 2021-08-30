class DonBaoBinhLoi {
  late DateTime createdDate;
  late List<String> addresses;
  late String id;
  late String customer;

  DonBaoBinhLoi({
    required this.createdDate,
    required this.addresses,
    required this.id,
  });

  DonBaoBinhLoi.fromJson(Map<String, dynamic> json) {
    var date = json['created_date'] != null
        ? DateTime.tryParse(json['created_date'])
        : DateTime.now();
    createdDate = date == null ? DateTime.now() : date;
    customer = json['customer'];

    id = json['id'];
    addresses = (json['addresses'] as List<dynamic>).map((e) {
      String address = (e as Map<String, dynamic>)['address'];
      return address;
    }).toList();
  }

  //Map<String, dynamic> toJson() {}
}

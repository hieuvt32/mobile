class CreateBaoNhamLanRequest {
  late String customerCode;
  late String reason;
  late String content;

  CreateBaoNhamLanRequest(
      {required this.customerCode,
      required this.reason,
      required this.content});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer'] = this.customerCode;
    data['customer_type'] = this.reason;
    data['content'] = this.content;

    return data;
  }
}

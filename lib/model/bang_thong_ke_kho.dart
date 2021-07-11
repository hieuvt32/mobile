class BangThongKeKho {
  late String customName;
  late String realName;
  late int quantity;
  late String type;
  late String status;
  late String name;

  late int actualCount;

  BangThongKeKho({
    required this.customName,
    required this.realName,
    required this.quantity,
    required this.type,
    required this.status,
    required this.name,
  }) {
    this.actualCount = 0;
  }

  BangThongKeKho.fromJson(Map<dynamic, dynamic> json) {
    customName = json['custom_name'];
    realName = json['real_name'];
    quantity = json['quantity'];
    type = json['type'];
    status = json['status'];
    name = json['name'];
    actualCount = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custom_name'] = this.customName;
    data['real_name'] = this.realName;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['status'] = this.status;
    data['name'] = this.name;

    data['system_count'] = this.quantity;
    data['actual_count'] = this.actualCount;
    return data;
  }
}

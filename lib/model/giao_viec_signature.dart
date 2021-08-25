class GiaoViecSignature {
  late String address;
  late String attachSignatureCustomerImage;
  late String attachSignatureDeliverImage;
  late String order;
  late String status;

  GiaoViecSignature(
      {required this.address,
      required this.attachSignatureCustomerImage,
      required this.attachSignatureDeliverImage,
      required this.order,
      required this.status});

  GiaoViecSignature.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    attachSignatureCustomerImage =
        json['attach_signature_customer_image'] != null
            ? json['attach_signature_customer_image']
            : '';
    attachSignatureDeliverImage = json['attach_signature_deliver_image'] != null
        ? json['attach_signature_deliver_image']
        : '';
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['order'] = this.order;
    data['attach_signature_deliver_image'] = this.attachSignatureDeliverImage;
    data['attach_signature_customer_image'] = this.attachSignatureCustomerImage;
    data['address'] = this.address;
    return data;
  }
}

class GiaoViecSignatureResponse {
  late List<GiaoViecSignature> message;

  GiaoViecSignatureResponse({required this.message});

  GiaoViecSignatureResponse.fromJson(Map<dynamic, dynamic> json) {
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message.add(new GiaoViecSignature.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message.map((v) => v.toJson()).toList();
    return data;
  }
}

class GiaoViec {
  late String deliverDate;
  late String? plate;
  late String? supportEmployee;
  late String? order;
  late String? employee;
  late String? name;
  GiaoViec({
    required this.deliverDate,
    required this.plate,
    required this.supportEmployee,
    required this.order,
    required this.employee,
    this.name = '',
  });

  GiaoViec.fromJson(Map<String, dynamic> json) {
    deliverDate = json['deliver_date'];
    plate = json['plate'] != null ? json['plate'] : '';
    supportEmployee =
        json['support_employee'] != null ? json['support_employee'] : '';
    order = json['order'];
    employee = json['employee'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliver_date'] = this.deliverDate;
    data['order'] = this.order;
    data['plate'] = this.plate;
    data['support_employee'] = this.supportEmployee;
    data['employee'] = this.employee;
    data['name'] = this.name;
    return data;
  }
}

class GiaoViecResponse {
  late GiaoViec? message;

  GiaoViecResponse({required this.message});

  GiaoViecResponse.fromJson(Map<String, dynamic> json) {
    if (json["message"] == null) {
      message = null;
      return;
    }
    message = new GiaoViec.fromJson(json["message"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message!.toJson();
    return data;
  }
}

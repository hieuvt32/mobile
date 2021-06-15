class ChangePasswordRequest {
  late String? newPassword;
  late String? usr;

  ChangePasswordRequest({
    this.newPassword,
    this.usr,
  }) : assert(
          newPassword != null && usr != null,
        );

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    newPassword = json['new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new_password'] = this.newPassword;
    return data;
  }
}

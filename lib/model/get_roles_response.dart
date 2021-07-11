class GetRolesResponse {
  GetRolesResponse({this.roles});

  late List<String>? roles;

  GetRolesResponse.fromJson(Map<String, dynamic> json) {
    try {
      var message = json['message'] as List<dynamic>;
      roles = message.map((e) => e.toString()).toList();
    } catch (e) {
      roles = [];
    }
  }
}

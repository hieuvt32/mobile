import 'dart:convert';

import 'package:frappe_app/utils/constants.dart';
import 'package:frappe_app/utils/enums.dart';

import '../services/storage_service.dart';

import '../app/locator.dart';

class Config {
  static var configContainer = locator<StorageService>().getHiveBox('config');

  bool get isLoggedIn => configContainer.get(
        'isLoggedIn',
        defaultValue: false,
      );

  String? get userId => Uri.decodeFull(
        configContainer.get(
          'userId',
        ),
      );

  List<UserRole> get roles {
    dynamic roles = configContainer.get('roles');
    if (roles == null) return [];

    List<dynamic> decodedRoles = jsonDecode(roles);

    List<UserRole> listRole = [];
    decodedRoles.forEach((element) {
      UserRole? role = Constants.mappingRole[element];
      if (role != null) {
        listRole.add(role);
      }
    });

    return listRole;
  }

  String get user => configContainer.get(
        'user',
      );

  String get customerCode {
    String userId = configContainer.get(
          'userId',
        ) ??
        "";
    String customerCode = userId.split("%")[0];
    if (customerCode == userId) {
      customerCode = userId.split("@")[0];
    }

    return customerCode;
  }

  String? get primaryCacheKey {
    if (baseUrl != null && userId != null) {
      return "$baseUrl$userId";
    } else {
      return null;
    }
  }

  String get version => configContainer.get(
        'version',
      );

  String? get baseUrl => configContainer.get(
        'baseUrl',
      );

  Uri? get uri {
    if (baseUrl != null) {
      return Uri.parse(baseUrl!);
    } else {
      return null;
    }
  }

  static Future set(String k, dynamic v) async {
    configContainer.put(k, v);
  }

  static dynamic get(String k) {
    return configContainer.get(k);
  }

  static bool containsKey(String k) {
    return configContainer.containsKey(k);
  }

  static Future clear() async {
    configContainer.clear();
  }

  static Future remove(String k) async {
    await configContainer.delete(k);
    var data = configContainer.containsKey(k);
  }
}

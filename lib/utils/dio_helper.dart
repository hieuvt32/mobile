import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/background_location_service.dart';
import 'package:frappe_app/utils/navigation_helper.dart';
import 'package:frappe_app/views/login/login_view.dart';
import 'package:path_provider/path_provider.dart';

import '../app.dart';
import '../model/config.dart';
import 'helpers.dart';

class DioHelper {
  static Dio? dio;
  static String? cookies;

  static Future init(String baseUrl) async {
    var cookieJar = await getCookiePath();
    dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
      ),
    )..interceptors.addAll([
        CookieManager(cookieJar),
        InterceptorsWrapper(
          onRequest: (request, handler) {
            return handler.next(request);
          },
          onError: (e, handler) async {
            if (e.response?.statusCode == 403 ||
                e.response?.statusCode == 401) {
              await clearLoginInfo();
              await BackgroundLocationService().stopLocationService();
              // NavigationHelper.clearAllAndNavigateTo(
              //   context: context,
              //   page: Login(),
              // );
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return Login();
                }),
                (_) => false,
              );
            }
          },
        ),
      ]);

    dio?.options.connectTimeout = 60 * 1000;
    dio?.options.receiveTimeout = 60 * 1000;
  }

  static Future initCookies() async {
    cookies = await getCookies();
  }

  static Future<PersistCookieJar> getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath));
  }

  static Future<String?> getCookies() async {
    var cookieJar = await getCookiePath();
    if (Config().uri != null) {
      var cookies = await cookieJar.loadForRequest(Config().uri!);

      var cookie = CookieManager.getCookies(cookies);

      return cookie;
    } else {
      return null;
    }
  }
}

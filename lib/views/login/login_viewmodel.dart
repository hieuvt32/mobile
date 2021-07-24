import 'package:frappe_app/model/login_request.dart';
import 'package:frappe_app/model/login_response.dart';
import 'package:frappe_app/utils/dio_helper.dart';
import 'package:injectable/injectable.dart';

import '../../app/locator.dart';
import '../../services/api/api.dart';
import '../../model/offline_storage.dart';

import '../../utils/helpers.dart';
import '../../utils/http.dart';

import '../../model/config.dart';

import '../../views/base_viewmodel.dart';

class SavedCredentials {
  String? serverURL;
  String? usr;

  SavedCredentials({
    this.serverURL,
    this.usr,
  });
}

@lazySingleton
class LoginViewModel extends BaseViewModel {
  var savedCreds = SavedCredentials();

  late String loginButtonLabel;

  init() {
    loginButtonLabel = "Đăng nhập";

    savedCreds = SavedCredentials(
      serverURL: Config().baseUrl,
      usr: OfflineStorage.getItem('usr')["data"],
    );
  }

  updateUserDetails(LoginResponse response) {
    Config.set('isLoggedIn', true);

    Config.set(
      'userId',
      response.userId,
    );
    Config.set(
      'user',
      response.fullName,
    );
  }

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    loginButtonLabel = "Đang xác thực...";
    notifyListeners();

    try {
      var response = await locator<Api>().login(
        loginRequest,
      );

      if (response.verification != null) {
        loginButtonLabel = "Xác thực";
        return response;
      } else {
        updateUserDetails(response);

        OfflineStorage.putItem(
          'usr',
          loginRequest.usr,
        );

        await cacheAllUsers();
        //await initAwesomeItems();
        await DioHelper.initCookies();

        loginButtonLabel = "Thành công";
        notifyListeners();

        return response;
      }
    } catch (e) {
      Config.set('isLoggedIn', false);
      loginButtonLabel = "Đăng nhập";
      notifyListeners();
      throw e;
    }
  }
}

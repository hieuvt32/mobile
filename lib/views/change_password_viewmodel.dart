import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/change_password_request.dart';
import 'package:frappe_app/model/change_password_response.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/offline_storage.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:injectable/injectable.dart';

import 'base_viewmodel.dart';

class SavedChangePassword {
  String? newPassword;
  String? usr;

  SavedChangePassword({
    this.newPassword,
    this.usr,
  });
}

@lazySingleton
class ChangePasswordViewModel extends BaseViewModel {
  var savedChangePassword = SavedChangePassword();

  late String loginButtonLabel;

  init() {
    loginButtonLabel = "Thay đổi";

    savedChangePassword = SavedChangePassword(
      newPassword: '',
      usr: OfflineStorage.getItem('usr')["data"],
    );
  }

  // updateUserDetails(LoginResponse response) {
  //   Config.set('isLoggedIn', true);

  //   Config.set(
  //     'userId',
  //     response.userId,
  //   );
  //   Config.set(
  //     'user',
  //     response.fullName,
  //   );
  // }

  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    loginButtonLabel = "Đang thực hiện....";
    notifyListeners();

    try {
      var response = await locator<Api>().changePassword(
        changePasswordRequest,
      );
      loginButtonLabel = "Thay đổi";
      notifyListeners();
      return response;
    } catch (e) {
      // Config.set('isLoggedIn', false);
      loginButtonLabel = "Thay đổi";
      notifyListeners();
      throw e;
    }
  }
}

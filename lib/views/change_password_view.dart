import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/control.dart';
import 'package:frappe_app/model/change_password_request.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/model/offline_storage.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

import 'base_view.dart';
import 'change_password_viewmodel.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<ChangePasswordViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      FormBuilder(
                        key: _fbKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // buildDecoratedControl(
                              //   control: FormBuilderTextField(
                              //     name: 'serverURL',
                              //     initialValue: model.savedCreds.serverURL,
                              //     validator: FormBuilderValidators.compose([
                              //       FormBuilderValidators.required(context),
                              //       FormBuilderValidators.url(context),
                              //     ]),
                              //     decoration: Palette.formFieldDecoration(
                              //       label: "Server URL",
                              //     ),

                              //   ),
                              //   field: DoctypeField(
                              //     fieldname: 'serverUrl',
                              //     label: "Server URL",
                              //   ),

                              // ),,
                              SizedBox(
                                height: 122,
                              ),
                              Text(
                                'Đổi mật khẩu',
                                style: TextStyle(
                                    color: hexToColor('#00478B'),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              PasswordField(
                                name: 'pwd',
                                label: 'Mật khẩu mới',
                              ),
                              PasswordField(
                                name: 're_pwd',
                                label: 'Nhập lại mật khẩu mới',
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: FrappeFlatButton(
                                  title: model.loginButtonLabel,
                                  fullWidth: true,
                                  height: 52,
                                  buttonType: ButtonType.primary,
                                  onPressed: () async {
                                    FocusScope.of(context).requestFocus(
                                      FocusNode(),
                                    );

                                    if (_fbKey.currentState != null) {
                                      if (_fbKey.currentState!
                                          .saveAndValidate()) {
                                        var formValue =
                                            _fbKey.currentState?.value;

                                        try {
                                          // formValue!["serverURL"] ??
                                          // await setBaseUrl('https://dpotech.vn');

                                          if (formValue!["pwd"] !=
                                              formValue["re_pwd"]) {
                                            FrappeAlert.warnAlert(
                                              title: "Thông báo",
                                              subtitle:
                                                  "Nhập lại mật khẩu chưa đúng",
                                              context: context,
                                            );
                                            return;
                                          }

                                          var usr = OfflineStorage.getItem(
                                              'usr')["data"];
                                          var changePasswordRequest =
                                              ChangePasswordRequest(
                                                  newPassword: formValue["pwd"],
                                                  usr: usr);

                                          var changePasswordResponse =
                                              await model.changePassword(
                                            changePasswordRequest,
                                          );

                                          if (changePasswordResponse
                                                  .doctypeDoc.name ==
                                              usr) {
                                            FrappeAlert.successAlert(
                                              title: "Thông báo",
                                              subtitle:
                                                  "Thay đổi mật khẩu thành công",
                                              context: context,
                                            );
                                          }

                                          // if (loginResponse.verification != null &&
                                          //     loginResponse.tmpId != null) {
                                          //   showModalBottomSheet(
                                          //     context: context,
                                          //     useRootNavigator: true,
                                          //     isScrollControlled: true,
                                          //     builder: (context) =>
                                          //         VerificationBottomSheetView(
                                          //       loginRequest: loginRequest,
                                          //       tmpId: loginResponse.tmpId!,
                                          //       message: loginResponse
                                          //           .verification!.prompt,
                                          //     ),
                                          //   );
                                          // } else {
                                          //   NavigationHelper.pushReplacement(
                                          //     context: context,
                                          //     page: HomeView(),
                                          //   );
                                          // }
                                        } catch (e) {
                                          var _e = e as ErrorResponse;

                                          if (_e.statusCode ==
                                              HttpStatus.unauthorized) {
                                            FrappeAlert.errorAlert(
                                              title: "Not Authorized",
                                              subtitle: _e.statusMessage,
                                              context: context,
                                            );
                                          } else {
                                            FrappeAlert.errorAlert(
                                              title: "Error",
                                              subtitle: _e.statusMessage,
                                              context: context,
                                            );
                                          }
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  PasswordField({this.name, this.label});

  final String? name;
  final String? label;
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return buildDecoratedControl(
      control: Stack(
        alignment: Alignment.centerRight,
        children: [
          FormBuilderTextField(
            maxLines: 1,
            name: widget.name!,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
            obscureText: _hidePassword,
            decoration: Palette.formFieldDecoration(label: widget.label),
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
            ),
            child: Text(
              _hidePassword ? "Hiển thị" : "Ẩn",
              style: TextStyle(
                color: FrappePalette.grey[600],
              ),
            ),
            onPressed: () {
              setState(
                () {
                  _hidePassword = !_hidePassword;
                },
              );
            },
          )
        ],
      ),
      field: DoctypeField(fieldname: "password", label: null),
    );
  }
}

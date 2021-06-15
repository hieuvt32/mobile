import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/model/change_password_request.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/offline_storage.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

import 'base_view.dart';
import 'change_password_viewmodel.dart';
import 'login/login_view.dart';

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _fbKey,
                      child: Column(
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

                          // ),
                          PasswordField(),
                          FrappeFlatButton(
                            title: model.loginButtonLabel,
                            fullWidth: true,
                            height: 46,
                            buttonType: ButtonType.primary,
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(
                                FocusNode(),
                              );

                              if (_fbKey.currentState != null) {
                                if (_fbKey.currentState!.saveAndValidate()) {
                                  var formValue = _fbKey.currentState?.value;

                                  try {
                                    // formValue!["serverURL"] ??
                                    // await setBaseUrl('https://dpotech.vn');

                                    var usr =
                                        OfflineStorage.getItem('usr')["data"];
                                    var changePasswordRequest =
                                        ChangePasswordRequest(
                                            newPassword: formValue!["pwd"],
                                            usr: usr);

                                    var changePasswordResponse =
                                        await model.changePassword(
                                      changePasswordRequest,
                                    );

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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/utils/navigation_helper.dart';
import 'package:frappe_app/views/change_password_view.dart';
import 'package:frappe_app/views/login/login_view.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // elevation: 0.8,
          // title: Text(
          //   'Hồ sơ',
          // ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              // Get.back();
              // Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordView(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    FrappeIcon(
                      FrappeIcons.change_password,
                      color: hexToColor('#00478B'),
                      size: 73,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        color: hexToColor('#00478B'),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 108,
              ),
              const Divider(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                height: 1,
                thickness: 1,
                indent: 1,
                endIndent: 1,
              ),
              SizedBox(
                height: 108,
              ),
              GestureDetector(
                onTap: () async {
                  await clearLoginInfo();
                  NavigationHelper.clearAllAndNavigateTo(
                    context: context,
                    page: Login(),
                  );
                },
                child: Column(
                  children: [
                    FrappeIcon(
                      FrappeIcons.logout,
                      color: hexToColor('#00478B'),
                      size: 73,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text('Đăng xuất',
                        style: TextStyle(
                            color: hexToColor('#00478B'),
                            fontSize: 32,
                            fontWeight: FontWeight.w700))
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

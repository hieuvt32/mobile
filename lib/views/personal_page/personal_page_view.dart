import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/model/get_customer_by_code_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/change_password_view.dart';

import 'package:frappe_app/widgets/frappe_button.dart';

class PersonalPageView extends StatefulWidget {
  @override
  _PersonalPageViewState createState() => _PersonalPageViewState();
}

class _PersonalPageViewState extends State<PersonalPageView> {
  GetCustomerByCodeResponse _customerRespone = GetCustomerByCodeResponse();

  @override
  void initState() {
    String? userId = Config().userId;
    String customerCode = userId!.split("@")[0];
    locator<Api>().getCusomterByCode(code: customerCode).then((value) {
      setState(() {
        _customerRespone = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Customer? customer = _customerRespone.customer;

    return Scaffold(
        appBar: AppBar(
          title: Text('Trang cá nhân'),
        ),
        body: customer == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(top: 24),
                              child: Text(
                                customer.name,
                                style: TextStyle(
                                    color: hexToColor('#004716B'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )),
                          InfoColumn(
                            field: 'Mã khách hàng:',
                            iconPath: FrappeIcons.customer,
                            value: customer.code,
                          ),
                          InfoColumn(
                            field: 'Mã số thuế:',
                            iconPath: FrappeIcons.tax_code,
                            value: customer.taxId,
                          ),
                          InfoColumn(
                            field: 'Số điện thoại:',
                            iconPath: FrappeIcons.phone,
                            value: customer.phone,
                          ),
                          InfoColumn(
                            field: 'Email:',
                            iconPath: FrappeIcons.mail,
                            value: customer.email,
                          ),
                          InfoColumn(
                            field: 'Địa chỉ:',
                            iconPath: FrappeIcons.address,
                            value: '',
                          ),
                          ListAddressWidget(
                            listAddress: customer.address == null
                                ? []
                                : customer.address,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    FrappeFlatButton(
                      title: "Đổi mật khẩu",
                      fullWidth: false,
                      minWidth: 328,
                      height: 52,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePasswordView();
                            },
                          ),
                        );
                      },
                      buttonType: ButtonType.primary,
                    ),
                  ],
                )));
  }
}

class ListAddressWidget extends StatelessWidget {
  final List<Address>? listAddress;

  ListAddressWidget({required this.listAddress});

  @override
  Widget build(BuildContext context) {
    print(listAddress);
    return Column(
        children: listAddress!.asMap().entries.map<Widget>((
      entry,
    ) {
      Address address = this.listAddress![entry.key];

      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 9,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  address.diaChi,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
      );
    }).toList());
  }
}

class InfoColumn extends StatelessWidget {
  InfoColumn({
    required this.iconPath,
    required this.field,
    required this.value,
  });

  final String iconPath;
  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: FrappeIcon(this.iconPath)),
            ),
            Expanded(
                flex: 3,
                child: Container(
                    child: Text(
                  this.field,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: hexToColor('#14142B')),
                ))),
            Expanded(
                flex: 6,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.value,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: hexToColor('#14142B')),
                    )))
          ],
        ));
  }
}

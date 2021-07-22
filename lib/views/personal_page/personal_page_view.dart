import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/personal_page/personal_page_viewmodel.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

class PersonalPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<PersonalPageViewModel>(
        onModelReady: (model) {
          model.initValue();
        },
        builder: (context, model, child) => Builder(builder: (context) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Trang cá nhân'),
                  ),
                  body: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                model.enableEdit
                                    ? InfoColumn(
                                        field: 'Họ tên',
                                        iconPath: FrappeIcons.person,
                                        value: 'KH - 001',
                                        enableEdit: model.enableEdit,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: Text(
                                          'Phạm Văn Mạnh',
                                          style: TextStyle(
                                              color: hexToColor('#004716B'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                InfoColumn(
                                  field: 'Mã khách hàng:',
                                  iconPath: FrappeIcons.customer,
                                  value: 'KH - 001',
                                  enableEdit: model.enableEdit,
                                ),
                                InfoColumn(
                                  field: 'Mã số thuế:',
                                  iconPath: FrappeIcons.tax_code,
                                  value: '123256332',
                                  enableEdit: false,
                                ),
                                InfoColumn(
                                  field: 'Số điện thoại:',
                                  iconPath: FrappeIcons.phone,
                                  value: '09878383732',
                                  enableEdit: model.enableEdit,
                                ),
                                InfoColumn(
                                  field: 'Email:',
                                  iconPath: FrappeIcons.mail,
                                  value: 'mail@gmail.com',
                                  enableEdit: model.enableEdit,
                                ),
                                InfoColumn(
                                  field: 'Địa chỉ:',
                                  iconPath: FrappeIcons.address,
                                  value: '',
                                  enableEdit: model.enableEdit,
                                ),
                              ],
                            ),
                          ),
                          model.enableEdit
                              ? AddressEditingWidget(
                                  pageViewModel: model,
                                )
                              : SizedBox.shrink(),
                          model.enableEdit
                              ? Container(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                      onPressed: () {
                                        model.addAddress();
                                      },
                                      child: const Text('Thêm địa chỉ')),
                                )
                              : SizedBox(
                                  height: 24,
                                ),
                          FrappeFlatButton(
                            title:
                                model.enableEdit ? "Lưu" : "Cập nhật thông tin",
                            fullWidth: false,
                            minWidth: 328,
                            height: 52,
                            onPressed: () {
                              model.togggleEdit();
                            },
                            buttonType: ButtonType.primary,
                          ),
                          SizedBox(height: 18),
                          model.enableEdit
                              ? SizedBox.shrink()
                              : FrappeOutlinedButton(
                                  onPressed: () {},
                                  title: 'Đổi mật khẩu',
                                  fullWidth: false,
                                  minWidth: 328,
                                  height: 48,
                                  textStyle: TextStyle(
                                      color: hexToColor("#FF0F00"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                        ],
                      )));
            }));
  }
}

class AddressEditingWidget extends StatelessWidget {
  AddressEditingWidget({required this.pageViewModel});
  final PersonalPageViewModel pageViewModel;

  final List<String> fakeData = [
    'addres 1',
    'addres 2',
    'addres 3',
    'addres 4',
    'addres 5',
  ];

  Widget textEditField(String value, int index) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: hexToColor('#0072BC'),
          ),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: value,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          IconButton(
            icon: FrappeIcon(
              FrappeIcons.trash,
            ),
            onPressed: () {
              print(index);
              pageViewModel.removeAddress(index);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(pageViewModel.enableEdit);
    List<String>? listAddress = pageViewModel.address;
    return listAddress.length > 0
        ? Column(
            children: listAddress.asMap().entries.map<Widget>((entry) {
            return textEditField(entry.value, entry.key);
          }).toList())
        : SizedBox.shrink();
  }
}

class InfoColumn extends StatelessWidget {
  InfoColumn(
      {required this.iconPath,
      required this.field,
      required this.value,
      required this.enableEdit});

  final String iconPath;
  final String field;
  final String value;
  final bool enableEdit;

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
            this.enableEdit
                ? Expanded(
                    flex: 6,
                    child: Container(
                      height: 28,
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: hexToColor('#14142B')),
                        initialValue: value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: hexToColor("#0072BC"))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(color: hexToColor("#0072BC"))),
                        ),
                      ),
                    ))
                : Expanded(
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

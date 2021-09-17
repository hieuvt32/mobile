import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/phan_kho12.dart';
import 'package:frappe_app/model/response_data.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';

class SetThuKho12View extends StatefulWidget {
  const SetThuKho12View({Key? key}) : super(key: key);

  @override
  _SetThuKho12ViewState createState() => _SetThuKho12ViewState();
}

class _SetThuKho12ViewState extends State<SetThuKho12View> {
  @override
  void initState() {
    super.initState();

    getDSEmployeeByCompany();
    getPhanKho12();
    _thuKho1Selected = [];
    _thuKho2Selected = [];
  }

  List<Employee>? _employees;

  late PhanKho12? _phanKho12;

  late List<dynamic> _thuKho1Selected;

  late List<dynamic> _thuKho2Selected;

  void getDSEmployeeByCompany() {
    locator<Api>().getDSEmployeeByCompany().then((response) {
      setState(() {
        _employees = response != null && response.data != null
            ? (response.data as List<dynamic>)
                .map((e) => Employee.fromJson(e))
                .toList()
            : [];
      });
    });
  }

  void getPhanKho12() {
    locator<Api>().getKho12().then((response) {
      setState(() {
        _phanKho12 = response != null && response.data != null
            ? PhanKho12.fromJson(response.data)
            : null;
        if (_phanKho12 != null) {
          _thuKho1Selected =
              _phanKho12!.incharge1.map((e) => e.account).toList();
          _thuKho2Selected =
              _phanKho12!.incharge2.map((e) => e.account).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            // Get.back();
            Navigator.pop(context);
          },
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 24),
          //   child: GestureDetector(
          //     child: FrappeIcon(
          //       FrappeIcons.refresh,
          //       size: 20,
          //     ),
          //     onTap: () {
          //       setState(() {
          //         reloadScreen();
          //       });
          //     },
          //   ),
          // )
        ],
        title: Text(
          'Cấu hình quản kho',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        // bottom: ,
      ),
      // body: AnswerButton(),
      body: _employees != null
          ? Container(
              padding: EdgeInsets.fromLTRB(24, 26, 24, 26),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Thủ kho 1',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    MultiSelect(
                      //--------customization selection modal-----------
                      buttonBarColor: Colors.white,
                      cancelButtonText: "Thoát",
                      clearButtonText: "Làm rỗng",
                      saveButtonText: "Lưu",
                      hintTextColor: Colors.black,
                      titleText: "Thủ kho 1",
                      checkBoxColor: Colors.black,
                      titleTextColor: Colors.black,
                      selectedOptionsInfoText: "Chọn một người dùng để xóa",
                      selectedOptionsBoxColor: Colors.white,
                      hintText: "Chạm vào đây để chọn một hoặc nhiều",
                      searchBoxHintText: "Tìm kiếm",
                      maxLengthText: "(Lớn nhất 100)",
                      // auto: true,
                      maxLength: 100,
                      // optional
                      //--------end customization selection modal------------
                      validator: (dynamic value) {
                        // if (value == null) {
                        //   return 'Please select one or more option(s)';
                        // }
                        return null;
                      },
                      // errorText: 'Please select one or more option(s)',
                      dataSource: _employees!.map((e) => e.toJson()).toList(),
                      textField: 'employee_name',
                      valueField: 'user_id',
                      filterable: true,
                      required: true,
                      onSaved: (value) {
                        print('The saved values are $value');
                        setState(() {
                          _thuKho1Selected = value;
                        });
                      },
                      change: (value) {
                        print('The selected values are $value');
                        // _thuKho2Selected = value;
                      },
                      value: _thuKho1Selected,
                      initialValue: _thuKho1Selected,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Công việc thủ kho 1:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Tạo đơn hàng'),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Điền số lượng vỏ bình của đơn hàng'),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Điền số lượng sản phẩm của đơn hàng'),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    MultiSelect(
                      //--------customization selection modal-----------
                      buttonBarColor: Colors.white,
                      cancelButtonText: "Thoát",
                      clearButtonText: "Làm rỗng",
                      saveButtonText: "Lưu",
                      hintTextColor: Colors.black,
                      titleText: "Thủ kho 2",
                      checkBoxColor: Colors.black,
                      titleTextColor: Colors.black,
                      selectedOptionsInfoText: "Chọn một người dùng để xóa",
                      selectedOptionsBoxColor: Colors.white,
                      hintText: "Chạm vào đây để chọn một hoặc nhiều",
                      searchBoxHintText: "Tìm kiếm",
                      maxLengthText: "(Lớn nhất 100)",
                      // auto: true,
                      maxLength: 100,
                      // optional
                      //--------end customization selection modal------------
                      validator: (dynamic value) {
                        // if (value == null) {
                        //   return 'Please select one or more option(s)';
                        // }
                        return null;
                      },
                      // errorText: 'Please select one or more option(s)',
                      dataSource: _employees!
                          .where((element) =>
                              !_thuKho1Selected.contains(element.userId))
                          .map((e) => e.toJson())
                          .toList(),
                      textField: 'employee_name',
                      valueField: 'user_id',
                      filterable: true,
                      required: true,
                      onSaved: (value) {
                        print('The saved values are $value');
                        setState(() {
                          _thuKho2Selected = value;
                        });
                      },
                      change: (value) {
                        print('The selected values are $value');
                      },
                      value: _thuKho2Selected,
                      initialValue: _thuKho2Selected,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Công việc thủ kho 2:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Kiểm đếm số lương đơn hàng'),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Xác nhận đơn chờ'),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Xác nhận đơn đã giao'),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: hexToColor('#FF0F00'),
                            // side: BorderSide(
                            //   width: 1.0,
                            // ),
                            minimumSize: Size(120, 32),
                            // padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              // side: BorderSide(
                              //   color: hexToColor('#0072BC'),
                              // ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Hủy',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: hexToColor('#0072BC'),
                            // side: BorderSide(
                            //   width: 1.0,
                            // ),

                            minimumSize: Size(120, 32),
                            // padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              // side: BorderSide(
                              //   color: hexToColor('#FF0F00'),
                              // ),
                            ),
                          ),
                          onPressed: () async {
                            var response = await locator<Api>().setKho12(
                              PhanKho12(
                                "",
                                _employees!
                                    .where((element) => _thuKho1Selected
                                        .contains(element.userId))
                                    .map((e) => PhanKho12Members(
                                        e.userId, e.employeeName, e.name))
                                    .toList(),
                                _employees!
                                    .where((element) => _thuKho2Selected
                                        .contains(element.userId))
                                    .map((e) => PhanKho12Members(
                                        e.userId, e.employeeName, e.name))
                                    .toList(),
                              ),
                            );

                            if (response.code == 200) {
                              FrappeAlert.successAlert(
                                  title: "Thông báo",
                                  subtitle: "Phân thủ kho thành công.",
                                  context: context);
                            } else {
                              FrappeAlert.successAlert(
                                  title: "Lỗi",
                                  subtitle: "Phân thủ kho không thành công!",
                                  context: context);
                            }
                          },
                          child: Text(
                            "Lưu",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

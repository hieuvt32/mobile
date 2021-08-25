import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/giao_viec_signature.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/coordination_views/datetime_picker.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';

class CoordinationEditView extends StatefulWidget {
  final String? name;
  final bool isReadOnly;
  CoordinationEditView({
    Key? key,
    this.name,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  _CoordinationEditViewState createState() => _CoordinationEditViewState();
}

class _CoordinationEditViewState extends State<CoordinationEditView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
      onModelReady: (model) async {
        model.setName(widget.name);
        model.init();
        await model.initPreData();
        // this.initTab();
      },
      onModelClose: (model) {
        model.disposed();
        // _tabController.dispose();
        // _secondTabController.dispose();
        // _scrollController.dispose();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomizeAppBar(
          model.title,
          leftAction: () {
            Navigator.pop(context);
          },
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Center(
                child: Text(
                  model.orderStatus,
                  style: TextStyle(
                    color: hexToColor('#0072BC'),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        body: model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EditOrderHeader(
                                    isDieuPhoi: true,
                                  ),
                                  ListProductLocationView(),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Visibility(
                                    child: Container(
                                      width: double.infinity,
                                      color: hexToColor('#F2F8FC'),
                                      height: 40,
                                      // onPressed: () {},
                                      child: GestureDetector(
                                        child: DottedBorder(
                                          color:
                                              Color.fromRGBO(0, 114, 188, 0.3),
                                          strokeWidth: 2,
                                          // borderType: BorderType.Circle,
                                          radius: Radius.circular(8),
                                          child: Center(
                                              child: Text(
                                            'Thêm địa chỉ',
                                            style: TextStyle(fontSize: 16),
                                          )),
                                        ),
                                        onTap: () {
                                          if (["", null, false, 0]
                                              .contains(model.customerValue)) {
                                            FrappeAlert.warnAlert(
                                                title: 'Thông báo',
                                                context: context,
                                                subtitle:
                                                    'Xin hãy chọn một khách hàng');
                                            return;
                                          }

                                          model.addAddress();
                                          model.changeState();
                                        },
                                      ),
                                    ),
                                    visible: !model.readOnlyView,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Phân công',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FieldData(
                                              value: 'Lái xe: ',
                                              fieldType: 3,
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  checkNullEmpty(
                                                          model.giaoViec.name)
                                                      ? FieldData(
                                                          // value: 'Sản phẩm: ',
                                                          fieldType: 0,
                                                          values: model
                                                              .employees
                                                              .map((e) => FieldValue(
                                                                  text: e
                                                                      .employeeName,
                                                                  value:
                                                                      e.name))
                                                              .toList(),
                                                          value: model.giaoViec
                                                              .employee,
                                                          selectionHandler:
                                                              (value) {
                                                            model.giaoViec
                                                                    .employee =
                                                                value;
                                                            model.changeState();
                                                          },
                                                        )
                                                      : FieldData(
                                                          fieldType: 3,
                                                          value: model.giaoViec
                                                                  .employee ??
                                                              '',
                                                        ),
                                                  // Visibility(
                                                  //     visible: false,
                                                  //     child: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 5),
                                                  //       child: Text(
                                                  //         "Chọn lái xe",
                                                  //         style: TextStyle(
                                                  //             color: Colors
                                                  //                 .redAccent
                                                  //                 .shade700,
                                                  //             fontSize: 12.0),
                                                  //       ),
                                                  //     ))
                                                ],
                                              ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FieldData(
                                              value: 'Phụ xe: ',
                                              fieldType: 3,
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                              flex: 8,
                                              child: Column(
                                                children: [
                                                  checkNullEmpty(
                                                          model.giaoViec.name)
                                                      ? FieldData(
                                                          // enabled: values[i]
                                                          //     .enabledVatTu,
                                                          // value: 'Sản phẩm:s ',
                                                          fieldType: 0,
                                                          values: model
                                                              .employees
                                                              .map((e) => FieldValue(
                                                                  text: e
                                                                      .employeeName,
                                                                  value:
                                                                      e.name))
                                                              .toList(),
                                                          value: model.giaoViec
                                                              .supportEmployee,
                                                          selectionHandler:
                                                              (value) {
                                                            model.giaoViec
                                                                    .supportEmployee =
                                                                value;
                                                            model.changeState();
                                                          },
                                                        )
                                                      : FieldData(
                                                          fieldType: 3,
                                                          value: model.giaoViec
                                                              .supportEmployee,
                                                        ),
                                                  // Visibility(
                                                  //     visible: false,
                                                  //     child: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 5),
                                                  //       child: Text(
                                                  //         "Chọn vật tư",
                                                  //         style: TextStyle(
                                                  //             color: Colors
                                                  //                 .redAccent
                                                  //                 .shade700,
                                                  //             fontSize: 12.0),
                                                  //       ),
                                                  //     ))
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FieldData(
                                              value: 'Biển số xe: ',
                                              fieldType: 3,
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                              flex: 8,
                                              child: Column(
                                                children: [
                                                  checkNullEmpty(
                                                          model.giaoViec.name)
                                                      ? FieldData(
                                                          // enabled: values[i]
                                                          //     .enabledVatTu,
                                                          // value: 'Sản phẩm:s ',
                                                          fieldType: 0,
                                                          values: model
                                                              .bienSoXes
                                                              .map((e) =>
                                                                  FieldValue(
                                                                      text: e
                                                                          .name,
                                                                      value: e
                                                                          .name))
                                                              .toList(),
                                                          value: model.giaoViec
                                                                      .plate ==
                                                                  ""
                                                              ? null
                                                              : model.giaoViec
                                                                  .plate,
                                                          selectionHandler:
                                                              (value) {
                                                            model.giaoViec
                                                                .plate = value;
                                                            model.changeState();
                                                          },
                                                        )
                                                      : FieldData(
                                                          fieldType: 3,
                                                          value: model
                                                              .giaoViec.plate,
                                                        ),
                                                  // Visibility(
                                                  //     visible: false,
                                                  //     child: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 5),
                                                  //       child: Text(
                                                  //         "Chọn vật tư",
                                                  //         style: TextStyle(
                                                  //             color: Colors
                                                  //                 .redAccent
                                                  //                 .shade700,
                                                  //             fontSize: 12.0),
                                                  //       ),
                                                  //     ))
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FieldData(
                                              value: 'Thời gian: ',
                                              fieldType: 3,
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                              flex: 8,
                                              child: Column(
                                                children: [
                                                  checkNullEmpty(
                                                          model.giaoViec.name)
                                                      ? DateTimePicker((value) {
                                                          model.giaoViec
                                                                  .deliverDate =
                                                              value;
                                                        })
                                                      : FieldData(
                                                          fieldType: 3,
                                                          value: model.giaoViec
                                                              .deliverDate,
                                                        ),
                                                  // Visibility(
                                                  //     visible: false,
                                                  //     child: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 5),
                                                  //       child: Text(
                                                  //         "Chọn vật tư",
                                                  //         style: TextStyle(
                                                  //             color: Colors
                                                  //                 .redAccent
                                                  //                 .shade700,
                                                  //             fontSize: 12.0),
                                                  //       ),
                                                  //     ))
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              )),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                    Visibility(
                      visible: checkNullEmpty(model.giaoViec.name),
                      child: EditOrderBottom(
                        isDieuPhoi: true,
                      ),
                    ),
                    Visibility(
                      visible: !checkNullEmpty(model.giaoViec.name),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          visible: true,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: hexToColor('#FF0F00'),
                              // side: BorderSide(
                              //   width: 1.0,
                              // ),
                              minimumSize: Size(double.infinity, 48),
                              // padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                // side: BorderSide(
                                //   color: hexToColor('#0072BC'),
                                // ),
                              ),
                            ),
                            onPressed: () async {
                              model.giaoViec = GiaoViec(
                                  deliverDate: DateTime.now().toString(),
                                  plate: null,
                                  supportEmployee: null,
                                  order: model.giaoViec.order,
                                  employee: null);
                              model.updateOrder(context, status: "Đã đặt hàng");
                              model.changeState();
                            },
                            child: Text(
                              'Hủy giao hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  bool checkNullEmpty(value) {
    return ["", null, false, 0].contains(value);
  }
}

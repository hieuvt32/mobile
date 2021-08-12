import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_not_sell_in_warehouse.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_sell_in_warehouse.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';
import 'package:frappe_app/views/edit_order/customer/customer_main_view.dart';
import 'package:frappe_app/views/edit_order/customer/customer_order_header.dart';

class CustomerOrderView extends StatefulWidget {
  final String name;
  final bool haveDelivery;
  CustomerOrderView({
    Key? key,
    this.name = '',
    this.haveDelivery = false,
  }) : super(key: key);

  @override
  _CustomerOrderViewState createState() => _CustomerOrderViewState();
}

class _CustomerOrderViewState extends State<CustomerOrderView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
        onModelReady: (model) {
          model.initState();
          model.initPreData();
          model.setHaveDelivery(true);
        },
        onModelClose: (model) {},
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomizeAppBar(
                "Tạo đơn hàng",
                leftAction: () {
                  Navigator.pop(context);
                },
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Center(
                      child: Text(
                        "Đang giao",
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
              body: Padding(
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
                child: Column(
                  children: [
                    Expanded(
                        flex: 9,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomerOrderHeader(),
                              ListProductLocationView(),
                              Visibility(
                                child: Container(
                                  width: double.infinity,
                                  color: hexToColor('#F2F8FC'),
                                  height: 40,
                                  // onPressed: () {},
                                  child: GestureDetector(
                                    child: DottedBorder(
                                      color: Color.fromRGBO(0, 114, 188, 0.3),
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
                                      model.addAddress();
                                      model.changeState();
                                    },
                                  ),
                                ),
                                visible: true,
                              )
                            ],
                          ),
                        )),
                    EditOrderBottom()
                  ],
                ),
              ));
        });
  }
}

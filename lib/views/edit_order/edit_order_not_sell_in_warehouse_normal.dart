import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';
import 'package:frappe_app/views/edit_order/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';

class EditOrderNotSellInWareHouseNormal extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderNotSellInWareHouseNormal({Key? key}) : super(key: key);

  @override
  _EditOrderNotSellInWareHouseNormalState createState() =>
      _EditOrderNotSellInWareHouseNormalState();
}

class _EditOrderNotSellInWareHouseNormalState
    extends State<EditOrderNotSellInWareHouseNormal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditOrderHeader(),
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
                          if (["", null, false, 0]
                              .contains(widget.model.customerValue)) {
                            FrappeAlert.warnAlert(
                                title: 'Thông báo',
                                context: context,
                                subtitle: 'Xin hãy chọn một khách hàng');
                            return;
                          }

                          widget.model.addAddress();
                          widget.model.changeState();
                        },
                      ),
                    ),
                    visible: !widget.model.readOnlyView,
                  )
                ],
              ),
            ),
            flex: 9,
          ),
          EditOrderBottom()
        ],
      ),
    );
  }
}

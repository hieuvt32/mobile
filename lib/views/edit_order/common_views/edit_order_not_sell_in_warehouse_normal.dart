import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';

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
    Iterable<Product> filteredList = widget.model.productForLocations.where(
        (element) =>
            element.actualQuantity != null &&
            element.actualQuantity != 0 &&
            element.actualQuantity != element.quantity);
    var totalHoanTra = filteredList.fold<int>(
        0, (sum, item) => sum + (item.quantity - item.actualQuantity));
    var totalNhapKho =
        widget.model.nhapKhos.fold<int>(0, (sum, item) => sum + item.amount);
    var totalTraVe =
        widget.model.traVes.fold<int>(0, (sum, item) => sum + item.amount);

    var totalXe = totalHoanTra + totalNhapKho;
    return Padding(
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
                        EditOrderHeader(),
                        Visibility(
                          visible:
                              widget.model.orderState == OrderState.Delivered,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thống kê xe về',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(36.0, 0, 24.0, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tổng xe về',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.65),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$totalXe',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Sản phảm trả về ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.65),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$totalHoanTra',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Vỏ nhập',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.65),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$totalNhapKho',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Vỏ trả khách ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.65),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$totalTraVe',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tổng nhập ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.65),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${totalNhapKho - totalTraVe}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: hexToColor('#FF2D1F'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
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
                ),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
          EditOrderBottom()
        ],
      ),
    );
  }
}

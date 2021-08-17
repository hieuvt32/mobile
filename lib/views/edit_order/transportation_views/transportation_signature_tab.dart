import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:signature/signature.dart';

import 'transportation_detail.dart';

class TransportationSignatureTab extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final TransportationKey address;
  final bool isLatest;
  TransportationSignatureTab({
    Key? key,
    required this.address,
    this.isLatest = false,
  }) : super(key: key);

  @override
  _TransportationSignatureTabState createState() =>
      _TransportationSignatureTabState();
}

class _TransportationSignatureTabState
    extends State<TransportationSignatureTab> {
  bool readOnly = false;
  @override
  Widget build(BuildContext context) {
    var giaoViewSig =
        widget.model.getGiaoViecSignatureByAddress(widget.address.address);
    readOnly = giaoViewSig != null && giaoViewSig.status == "Đã giao hàng";
    var attachImageCustomer =
        giaoViewSig != null ? giaoViewSig.attachSignatureCustomerImage : '';
    var attachImageDeliver =
        giaoViewSig != null ? giaoViewSig.attachSignatureDeliverImage : '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
      child: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Khách hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // color: hexToColor('#00478B'),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: hexToColor('#B3D5EB'),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Visibility(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    child: FrappeIcon(
                                      FrappeIcons.refresh,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      widget.model.clearSignatureCustomer();
                                    },
                                  ),
                                ),
                                visible: !readOnly,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                width: double.infinity,
                                child: readOnly
                                    ? Image.network(
                                        '${widget.model.config!.baseUrl}$attachImageCustomer')
                                    : Signature(
                                        controller: widget
                                            .model.signatureCustomerController,
                                        backgroundColor: Colors.white,
                                        height: 110,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                30,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Nhà cung cấp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // color: hexToColor('#00478B'),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: hexToColor('#B3D5EB'),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Visibility(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    child: FrappeIcon(
                                      FrappeIcons.refresh,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      widget.model.clearSignatureSupplier();
                                    },
                                  ),
                                ),
                                visible: !readOnly,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                width: double.infinity,
                                child: readOnly
                                    ? Image.network(
                                        '${widget.model.config!.baseUrl}$attachImageDeliver')
                                    : Signature(
                                        controller: widget
                                            .model.signatureSupplierController,
                                        backgroundColor: Colors.white,
                                        height: 110,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                30,
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
              SizedBox(
                height: 80,
              )
            ],
          ),
          // _buildBottomButton(model),

          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
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
                      await widget.model.updateOrder(context,
                          status: widget.isLatest
                              ? "Đã giao hàng"
                              : widget.model.order!.status);
                      await widget.model.updateGiaoViecSignature(context,
                          address: widget.address.address,
                          status: "Đã giao hàng");
                    },
                    child: Text(
                      widget.model.sellInWarehouse
                          ? 'Hoàn thành'
                          : (widget.model.orderState == OrderState.PreNewOrder
                              ? 'Tạo đơn'
                              : 'Lưu'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

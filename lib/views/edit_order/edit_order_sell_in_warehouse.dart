import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/tabs/product_tab.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_tab.dart';
import 'package:frappe_app/views/edit_order/tabs/signature_tab.dart';
import 'package:uuid/uuid.dart';

class EditOrderSellInWareHouse extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderSellInWareHouse({Key? key}) : super(key: key);

  @override
  _EditOrderSellInWareHouseState createState() =>
      _EditOrderSellInWareHouseState();
}

class _EditOrderSellInWareHouseState extends State<EditOrderSellInWareHouse>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  final List<Widget> mainTabs = [
    Tab(
      child: Text('Vỏ nhận',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          )),
    ),
    Tab(
        child: Text('Sản phẩm',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ))),
    Tab(
      child: Text(
        'Ký xác nhận',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 25, 24, 0),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: EditOrderHeader(
                  widget.model.customerValue,
                  widget.model.sellInWarehouse,
                  widget.model.customerSelect,
                  widget.model.sellInWarehouseSelection,
                  customers: widget.model.customers,
                  readOnlyView: widget.model.readOnlyView,
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: hexToColor('#FF0F00'),
                  // isScrollable: true,
                  labelStyle: TextStyle(
                    color: hexToColor('#FF0F00'),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelColor: hexToColor('#00478B'),
                  indicatorColor: Colors.transparent,
                  tabs: mainTabs,
                ),
              ),
            ];
          },
          body: Container(
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ReceivingShellTab(),
                      ProductTab(),
                      SignatureTab(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: true,
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
                              // setState(() {
                              //   //_isReadOnly = true;
                              // });

                              // // TODO: sửa ở đây
                              // var txt = Uuid().v1().toString();
                              // var bytes = await model.signatureCustomerController.toPngBytes();
                              // if (bytes != null) {
                              //   locator<Api>().uploadFilesForBytes(
                              //     doctype: 'HLGas_HoaDonMuaBan',
                              //     name: 'B-160721-0088',
                              //     files: [
                              //       GasFile(
                              //         file: bytes,
                              //         fileName: '$txt.png',
                              //       )
                              //     ],
                              //   ).then((value) {
                              //     print(value);
                              //   });
                              // }

                              // if (["", null, false, 0].contains(widget.name)) {
                              //   List<Customer>? customers = _responseGetCustomers != null &&
                              //           _responseGetCustomers!.customers != null
                              //       ? _responseGetCustomers!.customers
                              //       : [];

                              //   var elements = customers!
                              //       .where((element) => element.name == _khSelection)
                              //       .toList();

                              //   if (elements != null && elements.length > 0) {
                              //     _order!.email = elements[0].email;
                              //     _order!.paymentStatus = 'Chưa thanh toán';
                              //     _order!.phone = elements[0].phone;
                              //     _order!.products =
                              //         _sellInWarehouse ? _products : _productForLocations;
                              //     _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
                              //     _order!.status = _sellInWarehouse ? "Đã đặt hàng" : "Đã giao hàng";
                              //     _order!.taxId = elements[0].taxId;
                              //     _order!.totalCost = 0;
                              //     _order!.vendor = elements[0].name;

                              //     _order!.vendorAddress = '';

                              //     _order!.vendorName = elements[0].realName;

                              //     locator<Api>().createHoaDonMuaBan(_order!).then((value) {
                              //       setState(() {
                              //         var response = value;

                              //         if (response != null && response.responseData != null) {
                              //           _donNhapKho!.codeOrders = response.responseData.data;
                              //           _donNhapKho!.status = _order!.status;
                              //           _donNhapKho!.listShell = [...nhapKhos, ...traVes];
                              //           widget.name = response.responseData.data;
                              //           locator<Api>()
                              //               .createDonNhapKho(_donNhapKho!)
                              //               .then((value) {
                              //             setState(() {
                              //               var responseCreateDonNhapKho = value;
                              //               if (responseCreateDonNhapKho != null &&
                              //                   responseCreateDonNhapKho.responseData != null) {
                              //                 FrappeAlert.successAlert(
                              //                     title: 'Tạo đơn thành công',
                              //                     context: context,
                              //                     subtitle: 'Tạo đơn hàng thành công.');
                              //               }
                              //             });
                              //           });

                              //           if (_order!.status == 'Đã giao hàng') {
                              //             _isReadOnly = true;
                              //           }

                              //           locator<Api>()
                              //               .getSingleHoaDonBanHang(widget.name!)
                              //               .then((value) {
                              //             setState(() {
                              //               var response = value;

                              //               if (response != null && response.order != null) {
                              //                 _order = response.order;
                              //               }
                              //             });
                              //           });

                              //           locator<Api>()
                              //               .getSingleDonNhapKho(widget.name!)
                              //               .then((value) {
                              //             setState(() {
                              //               var response = value;
                              //               if (response != null &&
                              //                   response.donNhapKho != null) {
                              //                 _donNhapKho = response.donNhapKho;
                              //               }
                              //             });
                              //           });
                              //         } else {
                              //           FrappeAlert.errorAlert(
                              //               title: 'Lỗi xảy ra',
                              //               context: context,
                              //               subtitle: 'Không tạo được đơn hàng!');
                              //         }
                              //       });
                              //     });
                              //   } else {
                              //     FrappeAlert.errorAlert(
                              //         title: 'Lỗi xảy ra',
                              //         context: context,
                              //         subtitle:
                              //             'Không có khách hàng, xin hãy chọn khách hàng!');
                              //   }
                              // } else {
                              //   List<Customer>? customers = _responseGetCustomers != null &&
                              //           _responseGetCustomers!.customers != null
                              //       ? _responseGetCustomers!.customers
                              //       : [];

                              //   var elements = customers!
                              //       .where((element) => element.name == _order!.vendor)
                              //       .toList();

                              //   if (elements != null && elements.length > 0) {
                              //     _order!.email = elements[0].email;
                              //     _order!.paymentStatus = 'Chưa thanh toán';
                              //     _order!.phone = elements[0].phone;
                              //     _order!.products =
                              //         _sellInWarehouse ? _products : _productForLocations;
                              //     _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
                              //     _order!.status = _sellInWarehouse ? "Đã đặt hàng" : "Đã giao hàng";
                              //     _order!.taxId = elements[0].taxId;
                              //     _order!.totalCost = 0;
                              //     _order!.vendor = elements[0].name;

                              //     _order!.vendorAddress = '';

                              //     _order!.vendorName = elements[0].realName;

                              //     locator<Api>().updateHoaDonMuaBan(_order!).then((value) {
                              //       setState(() {
                              //         var response = value;

                              //         if (response != null && response.responseData != null) {
                              //           _donNhapKho!.codeOrders = widget.name!;
                              //           _donNhapKho!.status = _order!.status;
                              //           _donNhapKho!.listShell = [...nhapKhos, ...traVes];
                              //           locator<Api>()
                              //               .updateDonNhapKho(_donNhapKho!)
                              //               .then((value) {
                              //             setState(() {
                              //               var responseUpdateDonNhapKho = value;
                              //               if (responseUpdateDonNhapKho != null &&
                              //                   responseUpdateDonNhapKho.responseData != null) {
                              //                 FrappeAlert.successAlert(
                              //                     title: 'Cập nhật thành công',
                              //                     context: context,
                              //                     subtitle: 'Cập nhật đơn hàng thành công.');
                              //               }
                              //             });
                              //           });
                              //         } else {
                              //           FrappeAlert.errorAlert(
                              //               title: 'Lỗi xảy ra',
                              //               context: context,
                              //               subtitle: 'Không tạo được đơn hàng!');
                              //         }
                              //       });
                              //     });
                              //   } else {
                              //     FrappeAlert.errorAlert(
                              //         title: 'Lỗi xảy ra',
                              //         context: context,
                              //         subtitle:
                              //             'Không có khách hàng, xin hãy chọn khách hàng!');
                              //   }
                              // }
                            },
                            child: Text(
                              'Tạo đơn',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

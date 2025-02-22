import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/get_roles_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/services/background_location_service.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/utils/navigation_helper.dart';
import 'package:frappe_app/views/barcode_scanner/barcode_scanner_view.dart';
import 'package:frappe_app/views/coordination_views/coordination_edit.dart';
import 'package:frappe_app/views/coordination_views/coordination_list.dart';
import 'package:frappe_app/views/customer_list_order/customer_list_order_view.dart';
import 'package:frappe_app/views/edit_gas_broken/list_broken_gas_address.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_view.dart';
import 'package:frappe_app/views/login/login_view.dart';
import 'package:frappe_app/views/reports/Incoming_and_spending_view.dart';
import 'package:frappe_app/views/reports/asset_report_view.dart';
import 'package:frappe_app/views/reports/manufacturing_report_view.dart';
import 'package:frappe_app/views/reports/profit_report_view.dart';
import 'package:frappe_app/views/reports/warehouse_report_search_view.dart';
import 'package:frappe_app/views/set_thukho12/set_thukho12.dart';
import 'package:frappe_app/views/transportation_views/transportation_list.dart';
import 'package:frappe_app/views/home/Item.dart';
import 'package:frappe_app/views/inventory/inventory_view.dart';
import 'package:frappe_app/views/liability_report/liability_report.dart';
import 'package:frappe_app/views/list_broken_order/list_broken_order_view.dart';
import 'package:frappe_app/views/list_order/list_order_view.dart';
import 'package:frappe_app/views/mnvl/mnvl_edit.dart';
import 'package:frappe_app/views/mnvl/mnvl_list.dart';
import 'package:frappe_app/views/production_report/production_report_view.dart';
import 'package:frappe_app/views/search/search_view.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeChildView extends StatefulWidget {
  const HomeChildView({Key? key}) : super(key: key);

  @override
  _HomeChildViewState createState() => _HomeChildViewState();
}

class _HomeChildViewState extends State<HomeChildView> {
  var _ischidren = false;
  final baseItems = [
    Item(
      icon: FrappeIcons.shopping_cart,
      childrens: [
        Item(
          icon: FrappeIcons.list_order_remake,
          view: (context) {
            return ListOrderView(
              type: 'stocker',
            );
          },
          text: "Danh sách đơn hàng",
          visible: true,
          roles: ["Giám Đốc", "Thủ Kho"],
        ),
        Item(
          icon: FrappeIcons.ban_hang,
          text: "Tạo đơn hàng",
          visible: true,
          roles: ["Giám Đốc", "Thủ Kho"],
          view: (context) {
            return EditOrderView(
              isCreateScreen: true,
            );
          },
        )
      ],
      // view: SearchView(),
      text: "Bán hàng",
      roles: ["Giám Đốc", "Thủ Kho"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.clipboard_text,
      childrens: [],
      view: (context) {
        return InventoryView();
      },
      text: "Kiểm kho",
      roles: ["Giám Đốc", "Thủ Kho"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.gear_six,
      childrens: [
        Item(
          icon: FrappeIcons.barcode_remake,
          text: "Quét mã vạch",
          visible: true,
          roles: ["Giám Đốc", "Quản Đốc"],
        ),
        Item(
          icon: FrappeIcons.search_red,
          view: (context) {
            return SearchView();
          },
          text: "Tra cứu",
          visible: true,
          roles: ["Giám Đốc", "Quản Đốc"],
        ),
        Item(
          icon: FrappeIcons.giaovan_remake,
          view: (context) {
            return ProductionReportView();
          },
          text: "Báo cáo sản xuất",
          visible: true,
          roles: ["Giám Đốc", "Quản Đốc"],
        ),
      ],
      view: (context) {
        return InventoryView();
      },
      text: "Sản xuất",
      roles: ["Giám Đốc", "Quản Đốc"],
      visible: true,
    ),
    Item(icon: FrappeIcons.don_hang, visible: true, text: "Đơn hàng", roles: [
      "Khách Hàng"
    ], childrens: [
      Item(
          icon: FrappeIcons.list_order,
          text: "Danh sách đơn hàng",
          visible: true,
          roles: ["Khách Hàng"],
          view: (context) {
            return CustomerListOrderView();
          }),
      Item(
        icon: FrappeIcons.ban_hang,
        text: "Tạo đơn hàng",
        visible: true,
        roles: ["Khách Hàng"],
        view: (context) {
          return EditOrderView(
            haveDelivery: true,
            isCreateScreen: true,
          );
        },
      )
    ]),
    Item(
      icon: FrappeIcons.truck,
      childrens: [],
      view: (context) {
        return TransportationList();
      },
      text: "Giao vận",
      roles: ["Giám Đốc", "Giao Vận"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.chart_pie_slice,
      view: (context) {
        return LiabilityReportView();
      },
      text: "Báo cáo",
      roles: ["Khách Hàng"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.bao_binh_loi,
      visible: true,
      text: "Báo bình lỗi",
      childrens: [
        Item(
          icon: FrappeIcons.danh_sach_don_loi,
          visible: true,
          text: "Danh sách đơn lỗi",
          view: (context) {
            return ListBrokenOrderView();
          },
        ),
        Item(
            icon: FrappeIcons.bao_binh_loi,
            visible: true,
            text: "Báo bình lỗi",
            view: (context) {
              return ListBrokenGasAddress();
            }),
      ],
      roles: ["Khách Hàng"],
    ),
    Item(
      icon: FrappeIcons.users,
      childrens: [
        Item(
          icon: FrappeIcons.danh_sach_don_loi,
          visible: true,
          text: "Danh sách đơn điều phối",
          view: (context) {
            return CoordinationListView();
          },
        ),
        Item(
          icon: FrappeIcons.bao_binh_loi,
          visible: true,
          text: "Tạo đơn điều phối",
          view: (context) {
            return CoordinationEditView();
          },
        ),
      ],
      // view: (context) {
      //   return ListOrderView();
      // },
      text: "Điều phối",
      roles: [
        "Giám Đốc",
      ],
      visible: true,
    ),
    Item(
      visible: true,
      icon: FrappeIcons.shopping_bag,
      childrens: [
        Item(
          icon: FrappeIcons.danh_sach_don_loi,
          visible: true,
          text: "Danh sách đơn lỗi",
          view: (context) {
            return ListOrderView();
          },
        ),
        Item(
            icon: FrappeIcons.bao_binh_loi,
            visible: true,
            text: "Báo bình lỗi"),
        Item(
            icon: FrappeIcons.danh_sach_don_loi,
            visible: true,
            text: "Báo cáo công nợ",
            view: (context) {
              return LiabilityReportView();
            }),
      ],
    ),

    Item(
      icon: FrappeIcons.chart_pie_slice,
      childrens: [
        Item(
          icon: FrappeIcons.hexagon,
          text: "Báo cáo sản xuất",
          roles: [
            "Giám Đốc",
          ],
          visible: true,
          view: (context) => ManufacturingReportView(),
        ),
        Item(
            icon: FrappeIcons.line_chart,
            text: "Báo cáo lợi nhuận",
            roles: [
              "Giám Đốc",
            ],
            visible: true,
            view: (context) => ProfitReportView()),
        Item(
            icon: FrappeIcons.column_chart,
            text: "Báo cáo thu chi",
            roles: [
              "Giám Đốc",
            ],
            visible: true,
            view: (context) => IncomingAndSpendingView()),
        Item(
            icon: FrappeIcons.gas,
            text: "Báo cáo tài sản",
            roles: [
              "Giám Đốc",
            ],
            visible: true,
            view: (context) => AssetReportView()),
        Item(
            icon: FrappeIcons.note_book,
            text: "Báo cáo kho",
            roles: [
              "Giám Đốc",
            ],
            visible: true,
            view: (context) => WarehouseReportSearchView()),
      ],
      view: (context) {
        return LiabilityReportView();
      },
      text: "Báo cáo",
      roles: [
        "Giám Đốc",
      ],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.mua_nvl,
      childrens: [
        Item(
          icon: FrappeIcons.clipboard_text,
          visible: true,
          text: "Danh sách đơn mua",
          view: (context) {
            return MnvlListView();
          },
        ),
        Item(
          icon: FrappeIcons.tao_mnvl,
          visible: true,
          text: "Tạo đơn mua NVL",
          view: (context) {
            return MnvlEditView();
          },
        ),
      ],
      // view: CreateOrderView(),
      text: "Mua nguyên vật liệu",
      roles: ["Giám Đốc"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.account_box,
      view: (context) {
        return SetThuKho12View();
      },
      text: "Cấu hình quản kho",
      roles: [
        "Điều Phối Viên",
      ],
      visible: true,
    ),
    Item(
        view: (context) {
          return CustomerListOrderView();
        },
        icon: FrappeIcons.don_hang,
        visible: true,
        text: "Đơn hàng",
        roles: ["Điều Phối Viên"],
        childrens: []),
    Item(
      icon: FrappeIcons.users,
      childrens: [
        Item(
          icon: FrappeIcons.danh_sach_don_loi,
          visible: true,
          text: "Danh sách đơn điều phối",
          view: (context) {
            return CoordinationListView();
          },
        ),
        Item(
          icon: FrappeIcons.bao_binh_loi,
          visible: true,
          text: "Tạo đơn điều phối",
          view: (context) {
            return CoordinationEditView();
          },
        ),
      ],
      view: (context) {
        return ListOrderView();
      },
      text: "Điều phối",
      roles: [
        "Điều Phối Viên",
      ],
      visible: true,
    ),
    // Item(
    //   icon: FrappeIcons.book,
    //   childrens: [],
    //   view: (context) {
    //     return ListOrderView();
    //   },
    //   text: "Danh sách trả lại",
    //   roles: [
    //     "Điều Phối Viên",
    //   ],
    //   visible: true,
    // ),
    Item(
      icon: FrappeIcons.binh_loi,
      childrens: [],
      view: (context) {
        return ListBrokenOrderView();
      },
      text: "Đơn bình báo lỗi",
      roles: [
        "Điều Phối Viên",
      ],
      visible: true,
    ),
  ];

  GetRolesResponse? _response;

  bool _isGranted = false;

  // Future<void> startBarcodeScanStream() async {
  //   FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //           '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
  //       .listen((barcode) => print(barcode));
  // }

  // Future<void> scanQR() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {});
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);

  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //     FrappeAlert.errorAlert(
  //       title: "Quét barcode không thành công",
  //       subtitle: "Failed to get platform version.",
  //       context: context,
  //     );
  //   }

  //   // // If the widget was removed from the tree while the asynchronous platform
  //   // // message was in flight, we want to discard the reply rather than calling
  //   // // setState to update our non-existent appearance.
  //   // if (!mounted) return;

  //   // setState(() {});
  // }

  void _requestMobilePermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  storeUserRoles(List<String> userRoles) {
    Config.set("roles", jsonEncode(userRoles));

    if (userRoles.contains("Giao Vận")) {
      BackgroundLocationService().startLocationService();
    }
  }

  List<Item> items = [];
  @override
  void initState() {
    items = baseItems;

    locator<Api>().getRoles().then((value) {
      if (value.roles != null && value.roles!.length > 0) {
        storeUserRoles(value.roles ?? []);
      }

      setState(() {
        _response = value;
        if (_response != null && _response!.roles != null) {
          if (_response!.roles!.length == 1 &&
              _response!.roles!.contains("Guest")) {
            NavigationHelper.clearAllAndNavigateTo(
              context: context,
              page: Login(),
            );
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maxIndex = items.length - 1;

    // items = baseItems;
    if (_response != null && _response!.roles != null) {
      for (var item in baseItems) {
        if ((item.roles ?? [])
            .any((role) => _response!.roles!.contains(role))) {
          // Lists have at rleast one common element
          item.visible = true;
        } else {
          // Lists DON'T have any common element
          item.visible = false;
        }
      }
    }

    TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      _requestMobilePermission();
    } else {
      setState(() {
        _isGranted = true;
      });
    }

    return Scaffold(
      appBar: _ischidren
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Visibility(
                visible: _ischidren,
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _ischidren = false;
                      items = baseItems;
                    });
                  },
                ),
              ),
            )
          : null,
      body: _response != null
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 32,
                    // ),
                    Container(
                      height: 254,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Image(
                            image: AssetImage("assets/home_footer.png"),
                            fit: BoxFit.fill,
                          );
                        },
                        itemCount: 3,
                        pagination: new SwiperPagination(
                          builder: new DotSwiperPaginationBuilder(
                              color: Colors.white,
                              activeColor: hexToColor('#FF0F00')),
                        ),
                        control: new SwiperControl(),
                        itemHeight: 50,
                        containerHeight: 50,
                        // indicatorLayout: PageIndicatorLayout.COLOR,
                      ),
                    ),
                    // SizedBox(
                    //   height: 4,
                    // ),
                    Wrap(
                      children: [
                        ...items
                            .asMap()
                            .map((i, item) {
                              return MapEntry(
                                i,
                                Visibility(
                                  visible: item.visible,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (item.childrens != null &&
                                            item.childrens!.length > 0) {
                                          setState(() {
                                            items = item.childrens!;
                                            _ischidren = true;
                                          });
                                        } else {
                                          if (item.icon ==
                                              FrappeIcons.barcode_remake) {
                                            // scanBarcodeNormal();
                                            if (_isGranted) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BarcodeScannerView(
                                                        // barcode: barcodeScanRes,
                                                        );
                                                  },
                                                ),
                                              );
                                            } else {
                                              FrappeAlert.errorAlert(
                                                  title: "Thông báo",
                                                  context: context,
                                                  subtitle:
                                                      "Bạn chưa cáp quyền camera cho ứng dụng!");
                                            }
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: item.view!,
                                              ),
                                            );
                                          }
                                        }
                                      });
                                    },
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: new Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 25,
                                          ),
                                          SizedBox(
                                            child: new Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child: FrappeIcon(
                                                  item.icon,
                                                  color: hexToColor('#FF0F00'),
                                                  size: 48,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                // border: Border.all(
                                                //   color: hexToColor('#FF0F00'),
                                                //   width: 1,
                                                // ),
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromRGBO(
                                                        255, 15, 0, 0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        1), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                            ),
                                            height: 112,
                                            width: 112,
                                          ),
                                          new Padding(
                                            padding:
                                                new EdgeInsets.only(top: 6.0),
                                            child: new Text(
                                              item.text ?? "",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: hexToColor('#FF0F00')),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          i > (maxIndex - 1)
                                              ? SizedBox(
                                                  height: 60,
                                                )
                                              : SizedBox.shrink()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                            .values
                            .toList(),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      backgroundColor: Colors.white,
    );
  }
}

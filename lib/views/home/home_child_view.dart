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
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/barcode_scanner/barcode_scanner_view.dart';
import 'package:frappe_app/views/edit_gas_broken/list_broken_gas_address.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_view.dart';
import 'package:frappe_app/views/home/Item.dart';
import 'package:frappe_app/views/inventory/inventory_view.dart';
import 'package:frappe_app/views/liability_report/liability_report.dart';
import 'package:frappe_app/views/list_broken_order/list_broken_order_view.dart';
import 'package:frappe_app/views/list_order/list_order_view.dart';
import 'package:frappe_app/views/production_report/production_report_view.dart';
import 'package:frappe_app/views/search/search_view.dart';

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
          icon: FrappeIcons.clipboard_text,
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
            return EditOrderView();
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
          icon: FrappeIcons.giao_van,
          view: (context) {
            return ProductionReportView();
          },
          text: "Báo cáo sản xuất",
          visible: true,
          roles: ["Giám Đốc", "Quản Đốc"],
        ),
        Item(
          icon: FrappeIcons.barcode_red,
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
        )
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
            return ListOrderView();
          }),
      Item(
        icon: FrappeIcons.ban_hang,
        text: "Tạo đơn hàng",
        visible: true,
        roles: ["Khách Hàng"],
        view: (context) {
          return EditOrderView();
        },
      )
    ]),
    Item(
      icon: FrappeIcons.truck,
      childrens: [],
      // view: ProductionReportView(),
      text: "Giao vận",
      roles: ["Giám Đốc", "Giao Vận"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.chart_pie_slice,
      childrens: [],
      view: (context) {
        return LiabilityReportView();
      },
      text: "Báo cáo",
      roles: ["Giám Đốc", "Khách Hàng"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.bao_binh_loi,
      visible: true,
      text: "Báo bình lỗi",
      roles: ["Khách Hàng"],
    ),
    Item(
      icon: FrappeIcons.users,
      childrens: [],
      view: (context) {
        return ListOrderView();
      },
      text: "Điều phối",
      roles: ["Giám Đốc"],
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
    ),
    Item(
      icon: FrappeIcons.mua_hang,
      childrens: [],
      // view: CreateOrderView(),
      text: "Mua hàng",
      roles: ["Giám Đốc"],
      visible: true,
    ),
  ];

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  GetRolesResponse? _response;

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return BarcodeScannerView(
              barcode: barcodeScanRes,
            );
          },
        ),
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      FrappeAlert.errorAlert(
        title: "Quét barcode không thành công",
        subtitle: "Failed to get platform version.",
        context: context,
      );
    }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {});
  }

  List<Item> items = [];
  @override
  void initState() {
    items = baseItems;
    super.initState();

    locator<Api>().getRoles().then((value) {
      var roles = jsonEncode(value.roles);
      Config.set("roles", roles);
      var rolesDecode = jsonDecode(roles);
      print(rolesDecode);
      setState(() {
        _response = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var maxIndex = items.length - 1;

    // items = baseItems;
    if (_response != null && _response!.roles != null) {
      for (var item in baseItems) {
        if (item.roles!.any((role) => _response!.roles!.contains(role))) {
          // Lists have at least one common element
          item.visible = true;
        } else {
          // Lists DON'T have any common element
          item.visible = false;
        }
      }
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
                                              FrappeIcons.barcode_red) {
                                            scanBarcodeNormal();
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
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
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
                                              item.text!,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: hexToColor('#FF0F00')),
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

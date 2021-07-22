import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/get_roles_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/barcode_scanner/barcode_scanner_view.dart';
import 'package:frappe_app/views/edit_order/edit_order_view.dart';
import 'package:frappe_app/views/home/Item.dart';
import 'package:frappe_app/views/inventory/inventory_view.dart';
import 'package:frappe_app/views/liability_report/liability_report.dart';
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
      icon: FrappeIcons.giao_van,
      childrens: [],
      // view: ProductionReportView(),
      text: "Giao vận",
      roles: ["Giám Đốc", "Giao Vận"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.ban_hang,
      childrens: [
        Item(
          icon: FrappeIcons.giao_van,
          view: ListOrderView(),
          text: "Danh sách bán hàng",
          visible: true,
          roles: ["Giám Đốc", "Thủ Kho"],
        ),
        Item(
          icon: FrappeIcons.ban_hang,
          text: "Tạo đơn hàng",
          visible: true,
          roles: ["Giám Đốc", "Thủ Kho"],
          view: EditOrderView(
            name: "",
            coGiaoVanVien: false,
          ),
        )
      ],
      // view: SearchView(),
      text: "Bán hàng",
      roles: ["Giám Đốc", "Thủ Kho"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.kiem_kho,
      childrens: [],
      view: InventoryView(),
      text: "Kiểm kho",
      roles: ["Giám Đốc", "Thủ Kho"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.star,
      childrens: [
        Item(
          icon: FrappeIcons.barcode_red,
          text: "Quét mã vạch",
          visible: true,
          roles: ["Giám Đốc", "Quản Đốc"],
        ),
        Item(
          icon: FrappeIcons.search_red,
          view: SearchView(),
          text: "Tra cứu",
          visible: true,
          roles: ["Giám Đốc", "Quản Đốc"],
        )
      ],
      view: InventoryView(),
      text: "Sản xuất",
      roles: ["Giám Đốc", "Quản Đốc"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.report,
      childrens: [],
      view: ListOrderView(),
      text: "Báo cáo",
      roles: ["Giám Đốc"],
      visible: true,
    ),
    Item(
      icon: FrappeIcons.mua_hang,
      childrens: [
        Item(
            icon: FrappeIcons.danh_sach_don_loi,
            visible: true,
            text: "Danh sách đơn lỗi",
            view: ListOrderView()),
        Item(
            icon: FrappeIcons.bao_binh_loi,
            visible: true,
            text: "Báo bình lỗi"),
        Item(
            icon: FrappeIcons.danh_sach_don_loi,
            visible: true,
            text: "Báo cáo công nợ",
            view: LiabilityReportView()),
      ],
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
      appBar: AppBar(
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
      ),
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
                                                builder: (context) {
                                                  return item.view!;
                                                },
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
                                        // mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 44,
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
                                                border: Border.all(
                                                  color: hexToColor('#FF0F00'),
                                                  width: 1,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
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
                                                  color: hexToColor('#FF0F00')),
                                            ),
                                          ),
                                          i > (maxIndex - 3)
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

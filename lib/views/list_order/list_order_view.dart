import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_view.dart';
import 'package:intl/intl.dart';

class ListOrderView extends StatefulWidget {
  final String type;
  ListOrderView({Key? key, this.type = 'customer'}) : super(key: key);

  @override
  _ListOrderViewState createState() => _ListOrderViewState();
}

class _ListOrderViewState extends State<ListOrderView>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  List<Widget> myTabs = [];
  late TabController _tabController;
  late ScrollController _scrollController;
  late bool fixedScroll;

  // final List<Store> stores = [
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0)
  //   // Tab(text: 'fixed'),
  // ];

  Widget getFirstTab() {
    return Text(
      widget.type == "customer" ? "Đơn mẫu" : 'Đơn chờ',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }

  _ListOrderViewState() {
    _scrollController = ScrollController();
  }

  ListOrderResponse? _responseDaDatHang;

  ListOrderResponse? _responseDangGiaoHang;

  ListOrderResponse? _responseDaGiaoHang;

  ListOrderResponse? _responseDonCho;

  ListOrderResponse? _responseDonMau;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    myTabs = [
      Tab(
        child: getFirstTab(),
      ),
      Tab(
        child: Text(
          'Đã đặt hàng',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          'Đang giao hàng',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          'Đã giao hàng',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ];
    // fixedScroll = true;

    super.initState();

    reloadScreen();
  }

  void reloadScreen() {
    _responseDaDatHang = null;

    _responseDangGiaoHang = null;

    _responseDaGiaoHang = null;

    _responseDonCho = null;

    _responseDonMau = null;

    locator<Api>().getListOrder(5).then((value) {
      setState(() {
        _responseDonCho = value;
      });
    });

    locator<Api>().getListOrder(6).then((value) {
      setState(() {
        _responseDonMau = value;
      });
    });

    locator<Api>().getListOrder(0).then((value) {
      setState(() {
        _responseDaDatHang = value;
      });
    });

    locator<Api>().getListOrder(1).then((value) {
      setState(() {
        _responseDangGiaoHang = value;
      });
    });

    locator<Api>().getListOrder(2).then((value) {
      setState(() {
        _responseDaGiaoHang = value;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    // if (fixedScroll) {
    //   _scrollController.jumpTo(0);
    // }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      //fixedScroll = _tabController.index == 2;
    });
  }

  _buildTabContext(int type) {
    switch (type) {
      case 5:
        return _buildContentTab(_responseDonCho, type);
      case 0:
        return _buildContentTab(_responseDaDatHang, type);
      case 1:
        return _buildContentTab(_responseDangGiaoHang, type);
      case 2:
        return _buildContentTab(_responseDaGiaoHang, type);
      case 6:
        return _buildContentTab(_responseDonMau, type);
      default:
    }
  }

  Widget buildLimitTextLength(String content) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(fontSize: 10.0),
      text: TextSpan(
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          text: content),
    );
  }

  Widget buildCardContent(String type, Order order) {
    if (type == "customer") {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text("Địa chỉ"),
                  flex: 1,
                ),
                Flexible(
                    flex: 1,
                    child: buildLimitTextLength(
                        "A very long text A very long textA very long textA very long textA very long text")),
                Text(
                  "5.200.000",
                  style: TextStyle(
                      color: hexToColor("#FF0F00"),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text("Địa chỉ"),
                  flex: 1,
                ),
                Flexible(
                    flex: 1, child: buildLimitTextLength("Ngõ 59 Láng Hạ")),
                Text(
                  "5.200.000",
                  style: TextStyle(
                      color: hexToColor("#FF0F00"),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text("Khách hàng:"),
                  flex: 1,
                ),
                Flexible(
                  flex: 1,
                  child: buildLimitTextLength(order.vendorName),
                ),
                Flexible(
                  flex: 1,
                  child: buildLimitTextLength('-'),
                ),
                Text(
                  order.vendor,
                  style: TextStyle(
                      color: hexToColor("#FF0F00"),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Visibility(
              child: SizedBox(height: 16),
              visible: !["", null, false, 0].contains(order.employeeName),
            ),
            Visibility(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text("Giao vận viên:"),
                    flex: 1,
                  ),
                  Flexible(
                    flex: 1,
                    child: buildLimitTextLength(order.employeeName),
                  ),
                  Flexible(
                    flex: 1,
                    child: buildLimitTextLength('-'),
                  ),
                  Text(
                    order.plate,
                    style: TextStyle(
                        color: hexToColor("#FF0F00"),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              visible: !["", null, false, 0].contains(order.employeeName),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildContentTab(ListOrderResponse? response, int type) {
    List<Order>? stores =
        response != null && response.orders != null ? response.orders! : [];

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Divider(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            height: 1,
            thickness: 1,
            indent: 1,
            endIndent: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                double paddingTop = index == 0 ? 12 : 0;
                return GestureDetector(
                  child: Container(
                    color: hexToColor("#B3D5EB"),
                    padding: EdgeInsets.fromLTRB(8, paddingTop, 8, 12),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                                color: getColorByType(type)),
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            height: 32,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(stores[index].name,
                                    style: TextStyle(
                                        color: hexToColor("#14142B"),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(stores[index].creation),
                                    style: TextStyle(
                                        color: hexToColor("#14142B"),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10))
                              ],
                            ),
                          ),
                          buildCardContent(widget.type, stores[index])
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return EditOrderView(
                            name: stores[index].name,
                            haveDelivery: !["", null, false, 0]
                                .contains(stores[index].employeeName),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              itemCount: stores.length,
            ),
          ),
          // SizedBox(
          //   height: 16,
          // )
        ],
      ),
    );
  }

  Color getColorByType(int type) {
    switch (type) {
      case 5:
        return hexToColor('#FFEC44');
      case 6:
        return hexToColor('#FFEC44');
      case 0:
        return hexToColor('#0072BC');
      case 1:
        return hexToColor('#FF0F00');
      default:
        return hexToColor('#1BBD5C');
    }
  }

  String getTextByType(int type) {
    switch (type) {
      case 5:
        return 'Đơn chờ';
      case 6:
        return 'Đơn mẫu';
      case 0:
        return 'Đã đặt hàng';
      case 1:
        return 'Đang giao hàng';
      default:
        return 'Đã giao hàng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                child: FrappeIcon(
                  FrappeIcons.refresh,
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    reloadScreen();
                  });
                },
              ),
            )
          ],
          title: Text(
            'Danh sách đơn bán hàng',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          // bottom: ,
        ),
        // body: AnswerButton(),
        body: _responseDaDatHang != null &&
                _responseDangGiaoHang != null &&
                _responseDaDatHang != null &&
                _responseDonCho != null
            ? Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, value) {
                    return [
                      //SliverToBoxAdapter(child: _buildCarousel()),
                      SliverToBoxAdapter(
                        child: TabBar(
                          automaticIndicatorColorAdjustment: true,
                          controller: _tabController,
                          labelColor: hexToColor('#FF0F00'),
                          isScrollable: true,
                          labelStyle: TextStyle(
                            color: hexToColor('#FF0F00'),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelColor: hexToColor('#00478B'),
                          indicatorColor: Colors.transparent,
                          tabs: myTabs,
                        ),
                      ),
                    ];
                  },
                  body: Container(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContext(widget.type == "customer" ? 6 : 5),
                      _buildTabContext(0),
                      _buildTabContext(1),
                      _buildTabContext(2)
                    ],
                  )),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_view.dart';
import 'package:frappe_app/views/mnvl/mnvl_edit.dart';
import 'package:intl/intl.dart';

class MnvlListView extends StatefulWidget {
  final String type;
  MnvlListView({Key? key, this.type = 'customer'}) : super(key: key);

  @override
  _MnvlListViewState createState() => _MnvlListViewState();
}

class _MnvlListViewState extends State<MnvlListView>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(
      child: Text(
        'Đã đặt hàng',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    Tab(
      child: Text(
        'Đã nhận hàng',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];
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

  _MnvlListViewState() {
    _scrollController = ScrollController();
  }

  ListOrderResponse? _responseDaDatHang;

  ListOrderResponse? _responseDaGiaoHang;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    // fixedScroll = true;

    super.initState();

    reload();
  }

  void reload() {
    _responseDaDatHang = null;

    _responseDaGiaoHang = null;

    locator<Api>().getListOrder(0, type: 'M').then((value) {
      setState(() {
        _responseDaDatHang = value;
      });
    });

    locator<Api>().getListOrder(2, type: 'M').then((value) {
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
      case 0:
        return _buildContentTab(_responseDaDatHang, type);
      case 2:
        return _buildContentTab(_responseDaGiaoHang, type);
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text("Nhà cung cấp:"),
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
                    color: hexToColor("#FF0F00"), fontWeight: FontWeight.bold),
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

  Widget _buildContentTab(ListOrderResponse? response, int type) {
    List<Order>? stores =
        response != null && response.orders != null ? response.orders! : [];

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
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
                return GestureDetector(
                  child: Container(
                    color: hexToColor("#B3D5EB"),
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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
                                    DateFormat('dd/MM/yyyy HH:mm')
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
                          return MnvlEditView(
                            name: stores[index].name,
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
      case 0:
        return hexToColor('#0072BC');
      default:
        return hexToColor('#1BBD5C');
    }
  }

  String getTextByType(int type) {
    switch (type) {
      case 0:
        return 'Đã đặt hàng';
      default:
        return 'Đã giao hàng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    reload();
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
        body: _responseDaDatHang != null && _responseDaDatHang != null
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
                          // isScrollable: true,
                          labelStyle: TextStyle(
                            color: hexToColor('#FF0F00'),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelColor: hexToColor('#00478B'),
                          indicatorColor: hexToColor("#FF2D1F"),
                          tabs: myTabs,
                        ),
                      ),
                    ];
                  },
                  body: Container(
                      child: TabBarView(
                    controller: _tabController,
                    children: [_buildTabContext(0), _buildTabContext(2)],
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

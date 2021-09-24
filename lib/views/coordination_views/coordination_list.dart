import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/coordination_views/coordination_edit.dart';
import 'package:frappe_app/views/item_cart_order.dart';
import 'package:frappe_app/widgets/limit_text_length.dart';
import 'package:intl/intl.dart';

class CoordinationListView extends StatefulWidget {
  const CoordinationListView({Key? key}) : super(key: key);

  @override
  _CoordinationListViewState createState() => _CoordinationListViewState();
}

class _CoordinationListViewState extends State<CoordinationListView>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(
      child: Text(
        'Chờ điều phối',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    Tab(
      child: Text(
        'Đã điều phối',
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

  _CoordinationListViewState() {
    _scrollController = ScrollController();
  }

  ListOrderResponse? _responseChuaDieuPhoi;

  ListOrderResponse? _responseDaDieuPhoi;

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
    _responseChuaDieuPhoi = null;

    _responseDaDieuPhoi = null;

    locator<Api>().getListOrderDieuPhois(0).then((value) {
      setState(() {
        _responseChuaDieuPhoi = value;
      });
    });

    locator<Api>().getListOrderDieuPhois(1).then((value) {
      setState(() {
        _responseDaDieuPhoi = value;
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
        return _buildContentTab(_responseChuaDieuPhoi, type);
      case 2:
        return _buildContentTab(_responseDaDieuPhoi, type);
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

  Widget buildCardContent(List<MapEntry<String, int>> addresses) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4))),
        child: Column(
          children: [
            ...addresses
                .map((value) => Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Địa chỉ:"),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text(value.key != null ? value.key : ""),
                            flex: 7,
                          ),
                          // Expanded(
                          //     child: LimitTextLength(
                          //   text: "${value.value}",
                          //   textAlign: TextAlign.end,
                          // )),
                        ],
                      ),
                    ))
                .toList()
          ],
        ));
  }

  Widget _buildContentTab(ListOrderResponse? response, int type) {
    List<Order>? stores =
        response != null && response.orders != null ? response.orders! : [];

    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: stores.length,
          itemBuilder: (ctx, index) {
            Order item = stores[index];
            List<MapEntry<String, int>> addresses = [];
            groupBy<Product, String>(item.products, (obj) => obj.diaChi)
                .map((key, value) {
              addresses.add(MapEntry(key, value.length));
              return MapEntry(key, value);
            });

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CoordinationEditView(
                        name: item.name,
                      );
                    },
                  ),
                );
              },
              child: ItemCardOrder(
                cartContent: buildCardContent(
                  addresses,
                ),
                leftHeaderText: item.name,
                rightHeaderText:
                    DateFormat('dd/MM/yyyy HH:mm').format(item.creation),
                headerColor: getHeaderColor(item.status),
              ),
            );
          }),
    );
  }

  Color getHeaderColor(String status) {
    switch (status) {
      case "Đã đặt hàng":
        return Color.fromRGBO(0, 114, 188, 1);
      case "Đang giao hàng":
        return Color.fromRGBO(255, 15, 0, 1);
      case "Đã giao hàng":
        return Color.fromRGBO(27, 189, 92, 1);
      default:
    }

    return Color.fromRGBO(0, 114, 188, 1);
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
            ),
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
        body: _responseChuaDieuPhoi != null && _responseChuaDieuPhoi != null
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

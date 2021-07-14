import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/edit_order_view.dart';
import 'package:intl/intl.dart';

class ListOrderView extends StatefulWidget {
  const ListOrderView({Key? key}) : super(key: key);

  @override
  _ListOrderViewState createState() => _ListOrderViewState();
}

class _ListOrderViewState extends State<ListOrderView>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(
      child: Text('Đã đặt hàng',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          )),
    ),
    Tab(
        child: Text('Đang giao hàng',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ))),
    Tab(
      child: Text(
        'Đã giao hàng',
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

  _ListOrderViewState() {
    _scrollController = ScrollController();
  }

  ListOrderResponse? _responseDaDatHang;

  ListOrderResponse? _responseDangGiaoHang;

  ListOrderResponse? _responseDaGiaoHang;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    // fixedScroll = true;

    super.initState();

    _responseDaDatHang = null;

    _responseDangGiaoHang = null;

    _responseDaGiaoHang = null;

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
      case 0:
        return _buildContentTab(_responseDaDatHang, type);
      case 1:
        return _buildContentTab(_responseDangGiaoHang, type);
      case 2:
        return _buildContentTab(_responseDaGiaoHang, type);
      default:
    }
  }

  Widget _buildContentTab(ListOrderResponse? response, int type) {
    List<Order>? stores =
        response != null && response.orders != null ? response.orders! : [];

    return Container(
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
          SizedBox(
            height: 24,
          ),
          Container(
            height: 500,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Tên khách hàng: ${stores[index].vendorName}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Ngày tạo đơn: ${DateFormat('dd/MM/yyyy').format(stores[index].creation)}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Visibility(
                                    visible: !(["", null, false, 0]
                                        .contains(stores[index].employeeName)),
                                    child: Text(
                                      'Giao vận viên: ${stores[index].employeeName}',
                                      style: TextStyle(fontSize: 13),
                                    )),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: getColorByType(type),
                                  ),
                                  child: Text(
                                    getTextByType(type),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  padding: EdgeInsets.fromLTRB(20, 6, 20, 6),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Mã đơn: ${stores[index].name}',
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Visibility(
                                  child: Text(
                                    stores[index].plate,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: hexToColor('#FF0F00'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  visible: !(["", null, false, 0]
                                      .contains(stores[index].plate)),
                                ),
                                Visibility(
                                    child: SizedBox(
                                      height: 12,
                                    ),
                                    visible: !(["", null, false, 0]
                                        .contains(stores[index].plate))),
                              ],
                            ),
                          ),
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
                            coGiaoVanVien: !(["", null, false, 0]
                                .contains(stores[index].employeeName)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              itemCount: stores.length,
            ),
          )
        ],
      ),
    );
  }

  Color getColorByType(int type) {
    switch (type) {
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
      length: 3,
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
          actions: [],
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
                _responseDaDatHang != null
            ? Padding(
                padding: const EdgeInsets.only(top: 12),
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, value) {
                    return [
                      //SliverToBoxAdapter(child: _buildCarousel()),
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
                          tabs: myTabs,
                        ),
                      ),
                    ];
                  },
                  body: Container(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
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

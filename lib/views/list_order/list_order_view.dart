import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

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
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    fixedScroll = true;

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      fixedScroll = _tabController.index == 2;
    });
  }

  _buildTabContext(int type) => Container(
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
                  return Padding(
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
                                  'Tên khách hàng: Nguyễn Thị A',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Ngày tạo đơn: 22/6/2021',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Giao vận viên: Lê Bảo Bình',
                                  style: TextStyle(fontSize: 13),
                                ),
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
                                    'Đã đặt hàng',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  padding: EdgeInsets.fromLTRB(26, 6, 26, 6),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Mã đơn: T2106202',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '34K9-1741',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: hexToColor('#FF0F00'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            )
          ],
        ),
      );

  Color getColorByType(int type) {
    switch (type) {
      case 1:
        return hexToColor('#0072BC');
      case 2:
        return hexToColor('#FF0F00');

      default:
        return hexToColor('#1BBD5C');
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
        body: Padding(
          padding: const EdgeInsets.only(top: 28),
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
                _buildTabContext(1),
                _buildTabContext(2),
                _buildTabContext(3)
              ],
            )),
          ),
        ),
      ),
    );
  }
}

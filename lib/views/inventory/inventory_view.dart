import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/inventory/store.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({Key? key}) : super(key: key);

  @override
  _InventoryViewState createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(text: 'Vật tư'),
    Tab(text: 'Vật phẩm'),
    // Tab(text: 'fixed'),
  ];
  late TabController _tabController;
  late ScrollController _scrollController;
  late bool fixedScroll;

  final List<Store> stores = [
    Store(name: 'Van A', system: 30, reality: 0),
    Store(name: 'Van A', system: 30, reality: 0),
    Store(name: 'Van A', system: 30, reality: 0),
    Store(name: 'Van A', system: 30, reality: 0),
    Store(name: 'Van A', system: 30, reality: 0)
    // Tab(text: 'fixed'),
  ];

  // _InventoryViewState() {
  //   _scrollController = ScrollController();
  // }
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

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

  _buildTabContext(int lineCount) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Tên',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Hệ thống',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Thực tế',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color.fromRGBO(0, 0, 0, 0.5))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${stores[index].name}',
                                style: TextStyle(color: hexToColor('#14142B'))
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${stores[index].name}',
                                style: TextStyle(color: hexToColor('#14142B'))
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                // width: 64,
                                height: 32,
                                child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      // suffixIcon: Icon(Icons.search),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      // labelText: 'Mã vạch, Mã chế tạo',
                                      // labelStyle: TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w400,
                                      //     color: Color.fromRGBO(
                                      //         20, 20, 43, 0.5)),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      height: 1,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: stores.length,
              ),
            ),
            ElevatedButton(
              child: Text('Xác nhận'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: hexToColor('#FF0F00'),
                  side: BorderSide(
                    width: 1.0,
                  ),
                  minimumSize: Size(120, 40),
                  padding: EdgeInsets.fromLTRB(118, 13, 118, 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: hexToColor('#FF0F00')))),
            ),
          ],
        ),
      );

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
              'Kiểm kho (21/6/2021)',
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
                children: [_buildTabContext(200), _buildTabContext(2)],
              )),
            ),
          ),
        ));
  }
}

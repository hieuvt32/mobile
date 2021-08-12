import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bang_thong_ke_kho.dart';
import 'package:frappe_app/model/get_kiem_kho_response.dart';
import 'package:frappe_app/model/report_quy_chuan_thong_tin.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/inventory/store.dart';
import 'package:intl/intl.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({Key? key}) : super(key: key);

  @override
  _InventoryViewState createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(
      child: Text("Vật tư",
          style: TextStyle(color: hexToColor('#14142B'))
              .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
    ),
    Tab(
        child: Text('Thành phẩm',
            style: TextStyle(color: hexToColor('#14142B'))
                .copyWith(fontSize: 14, fontWeight: FontWeight.w600))),
    // Tab(text: 'fixed'),
  ];
  //TODO: Button xác nhận không fix cứng phải scroll hết mới đến
  late TabController _tabController;
  late ScrollController _scrollController;
  late bool fixedScroll;

  GetKiemKhoResponse? _responseVatTu;

  GetKiemKhoResponse? _responseThanhPham;

  // final List<Store> stores = [
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0)
  //   // Tab(text: 'fixed'),
  // ];

  // _InventoryViewState() {
  //   _scrollController = ScrollController();
  // }
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    fixedScroll = false;
    _responseVatTu = null;
    _responseThanhPham = null;

    super.initState();
    locator<Api>().getKiemKho(0).then((value) {
      setState(() {
        _responseVatTu = value;
      });
    });

    locator<Api>().getKiemKho(1).then((value) {
      setState(() {
        _responseThanhPham = value;
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

  _buildTabContext(int type) {
    switch (type) {
      case 0:
        return buidVatTu(_responseVatTu, type);
      default:
        return buidVatTu(_responseThanhPham, type);
    }
  }

  Widget buidVatTu(GetKiemKhoResponse? response, int type) {
    var stores = (response!.thongKeKhos != null ? response.thongKeKhos : [])
        as List<BangThongKeKho>;
    return Container(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(
          //   height: 12,
          // ),
          // const Divider(
          //   color: Color.fromRGBO(0, 0, 0, 0.3),
          //   height: 1,
          //   thickness: 1,
          //   indent: 1,
          //   endIndent: 1,
          // ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Tên',
                    textAlign: TextAlign.center,
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
                  flex: 3,
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
          SizedBox(
            height: 16,
          ),
          Container(
            height: 432,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: Color.fromRGBO(0, 0, 0, 0.5))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${stores[index].customName}',
                              style: TextStyle(color: hexToColor('#14142B'))
                                  .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${stores[index].quantity}',
                              style: TextStyle(color: hexToColor('#14142B'))
                                  .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              // width: 64,
                              height: 24,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  // suffixIcon: Icon(Icons.search),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
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
                                  fontSize: 13.0,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  setState(() {
                                    stores[index].actualCount = int.parse(text);
                                  });
                                },
                                onSubmitted: (text) {
                                  setState(() {
                                    stores[index].actualCount = int.parse(text);
                                  });
                                },
                              ),
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
            child: Text(
              'Xác nhận',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              locator<Api>().updateBienBanKiemKho(type, stores).then((value) {
                FrappeAlert.successAlert(
                  title: "Cập nhật thành công",
                  subtitle: "Quy chuẩn thông tin đã được cập nhật.",
                  context: context,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              primary: hexToColor('#FF0F00'),
              // side: BorderSide(
              //   width: 1.0,
              // ),
              minimumSize: Size(120, 40),
              padding: EdgeInsets.fromLTRB(118, 13, 118, 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: hexToColor('#FF0F00'),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
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
          actions: [],
          title: Text(
            'Kiểm kho ($formattedDate)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          // bottom: ,
        ),
        // body: AnswerButton(),
        body: _responseVatTu != null && _responseThanhPham != null
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
                    children: [_buildTabContext(0), _buildTabContext(1)],
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

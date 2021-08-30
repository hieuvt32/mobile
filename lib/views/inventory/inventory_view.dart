import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bang_thong_ke_kho.dart';
import 'package:frappe_app/model/bien_ban_kiem_kho.dart';
import 'package:frappe_app/model/get_bien_ban_kiem_kho_response.dart';
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
          style:
              TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
    ),
    Tab(
        child: Text('Thành phẩm',
            style: TextStyle()
                .copyWith(fontSize: 14, fontWeight: FontWeight.w600))),
    // Tab(text: 'fixed'),
  ];
  //TODO: Button xác nhận không fix cứng phải scroll hết mới đến
  late TabController _tabController;
  late ScrollController _scrollController;
  late bool fixedScroll;

  // GetKiemKhoResponse? _responseVatTu;

  // GetKiemKhoResponse? _responseThanhPham;

  //GetBienBanKiemKhoResponse? _responsebienBanKiemKho;
  var _readOnly = false;

  List<BangThongKeKho> _vatTus = [];
  List<BangThongKeKho> _thanhPhams = [];

  BienBanKiemKho? _bienBanKiemKho = null;

  final List<bool> _loading = [];

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

    _readOnly = false;

    super.initState();
    locator<Api>().getKiemKho(type: 0).then((value) {
      setState(() {
        _vatTus = (value.thongKeKhos != null ? value.thongKeKhos : []) ?? [];
        _loading.add(true);
      });
    });

    locator<Api>().getKiemKho(type: 1).then((value) {
      setState(() {
        _thanhPhams =
            (value.thongKeKhos != null ? value.thongKeKhos : []) ?? [];
        _loading.add(true);
      });
    });

    locator<Api>().getBienBanKiemKho().then((value) {
      setState(() {
        if (value != null && value.bienBanKiemKho != null) {
          _bienBanKiemKho = value.bienBanKiemKho;
          _readOnly = true;
        }
        _loading.add(true);
      });
    });
  }

  KiemKhoDanhSach? getDetailBienBanKiemKho(int type, String name) {
    if (_bienBanKiemKho != null) {
      if (type == 0) {
        if (_bienBanKiemKho!.materialList.length > 0) {
          var data = _bienBanKiemKho!.materialList
              .where((element) => element.realName == name);
          if (data.length > 0) return data.first;
        }
      }
      if (_bienBanKiemKho!.semiProductList.length > 0) {
        var data = _bienBanKiemKho!.semiProductList
            .where((element) => element.realName == name);
        if (data.length > 0) return data.first;
      }
    }
    return null;
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
        return buidVatTu(type);
      default:
        return buidVatTu(type);
    }
  }

  Widget buidVatTu(int type) {
    var stores = type == 0 ? _vatTus : _thanhPhams;

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
            height: 450,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                var bienBanKiemKho =
                    getDetailBienBanKiemKho(type, stores[index].realName);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: Color.fromRGBO(0, 0, 0, 0.5))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                !_readOnly
                                    ? Container(
                                        width: 80,
                                        height: 32,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text:
                                                  "${stores[index].actualCount}"),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // suffixIcon: Icon(Icons.search),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
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
                                            fontSize: 20.0,
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                          onChanged: (text) {
                                            stores[index].actualCount =
                                                int.tryParse(text) ?? 0;
                                          },
                                          onSubmitted: (text) {
                                            stores[index].actualCount =
                                                int.tryParse(text) ?? 0;
                                          },
                                        ),
                                      )
                                    : Text(
                                        "${bienBanKiemKho != null ? bienBanKiemKho.actualCount : stores[index].actualCount}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                                color: hexToColor('#14142B'))
                                            .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                      )
                              ],
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
          Visibility(
              visible: !_readOnly,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      locator<Api>()
                          .updateBienBanKiemKho(type, stores)
                          .then((value) {
                        setState(() {
                          _readOnly = true;
                        });
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
                      // minimumSize: Size(120, 40),
                      // padding: EdgeInsets.fromLTRB(118, 13, 118, 13),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(
                          color: hexToColor('#FF0F00'),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
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
        body: _loading.where((item) => item).length == 3
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

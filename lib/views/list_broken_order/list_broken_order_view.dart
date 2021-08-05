import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/don_bao_binh_loi.dart';
import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_gas_broken/list_broken_gas_address.dart';
import 'package:frappe_app/views/item_cart_order.dart';
import 'package:frappe_app/widgets/limit_text_length.dart';
import 'package:intl/intl.dart';

enum BrokenOrderStatus { responded, notResponded }

class ListBrokenOrderView extends StatefulWidget {
  @override
  _ListBrokenOrderViewState createState() => _ListBrokenOrderViewState();
}

class _ListBrokenOrderViewState extends State<ListBrokenOrderView>
    with SingleTickerProviderStateMixin {
  final List<Widget> myTabs = [
    Tab(
      child: Text(
        'Đã phản hồi',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    Tab(
      child: Text(
        'Chưa phản hồi',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];

  late TabController _tabController;
  late ScrollController _scrollController;

  Widget buildCardContent(List<String> addresses) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4))),
        child: Column(
          children: addresses
              .map((value) => Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Địa chỉ:"),
                        SizedBox(
                          width: 8,
                        ),
                        LimitTextLength(
                          text: value,
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ));
  }

  List<DonBaoBinhLoi>? listOrderResponded;
  List<DonBaoBinhLoi>? listOrderNotResponded;

  Widget _buildTabContent(
    BrokenOrderStatus status,
  ) {
    List<DonBaoBinhLoi> list;

    if (status == BrokenOrderStatus.responded) {
      list = listOrderResponded ?? [];
    } else {
      list = listOrderNotResponded ?? [];
    }

    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (ctx, index) {
            DonBaoBinhLoi item = list[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ListBrokenGasAddress(
                        id: item.id,
                      );
                    },
                  ),
                );
              },
              child: ItemCardOrder(
                cartContent: buildCardContent(item.addresses),
                leftHeaderText: item.id,
                rightHeaderText:
                    DateFormat('dd/MM/yyyy').format(item.createdDate),
              ),
            );
          }),
    );
  }

  _onTabListener() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );
  }

  _onFetchData() {
    String? userId = Config().userId;
    String customerCode = userId!.split("@")[0];

    locator<Api>()
        .getListDonBaoBinhLoi(customerCode, "Đã phản hồi")
        .then((value) {
      setState(() {
        listOrderResponded = value.listDonBaoBinhLoi;
      });
    }).catchError((err) {
      setState(() {
        listOrderResponded = [];
      });
    });

    locator<Api>()
        .getListDonBaoBinhLoi(
      customerCode,
      "Chờ phản hồi",
    )
        .then((value) {
      setState(() {
        listOrderNotResponded = value.listDonBaoBinhLoi;
      });
    }).catchError((err) {
      listOrderNotResponded = [];
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {});

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabListener);

    _onFetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dánh sách đơn bình báo lỗi"),
          ),
          body: NestedScrollView(
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
              body: listOrderResponded != null && listOrderNotResponded != null
                  ? Container(
                      child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent(
                          BrokenOrderStatus.responded,
                        ),
                        _buildTabContent(
                          BrokenOrderStatus.notResponded,
                        ),
                      ],
                    ))
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
        ));
  }
}

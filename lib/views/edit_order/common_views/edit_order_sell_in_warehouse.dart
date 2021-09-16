import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/tabs/product_tab.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_tab.dart';
import 'package:frappe_app/views/edit_order/tabs/signature_tab.dart';
import 'package:uuid/uuid.dart';

class EditOrderSellInWareHouse extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderSellInWareHouse({Key? key}) : super(key: key);

  @override
  _EditOrderSellInWareHouseState createState() =>
      _EditOrderSellInWareHouseState();
}

class _EditOrderSellInWareHouseState extends State<EditOrderSellInWareHouse>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    _scrollController = new ScrollController();
    super.initState();
  }

  Map<String, dynamic> rebuildWidget() {
    List<Widget> mainTabs;
    List<Widget> body;
    int length;
    if ([
          HiddenOrderState.Temporary,
          // HiddenOrderState.WaitingOrderAccept1,
          HiddenOrderState.Waiting1,
          HiddenOrderState.WaitingOrderReject1,
        ].contains(widget.model.hiddenOrderState) ||
        (widget.model.isThuKho2 &&
            [
              HiddenOrderState.WaitingOrderAccept1,
            ].contains(widget.model.hiddenOrderState))) {
      mainTabs = [
        Tab(
          child: Text(
            'Vỏ nhận',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Sản phẩm',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        // Tab(
        //   child: Text(
        //     'Ký xác nhận',
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.w700,
        //     ),
        //   ),
        // ),
      ];
      body = [
        ReceivingShellTab(),
        ProductTab(),
        // SignatureTab(),
      ];
      length = 2;
    } else {
      mainTabs = [
        Tab(
          child: Text(
            'Vỏ nhận',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Sản phẩm',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Ký xác nhận',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ];
      body = [
        ReceivingShellTab(),
        ProductTab(),
        SignatureTab(),
      ];

      length = 3;
      // _tabController.length = 3;
    }
    // var tabLength = 2;
    // if ([
    //   HiddenOrderState.WaitingOrderAccept1,
    //   HiddenOrderState.Waiting2,
    //   HiddenOrderState.WaitingOrderAccept2,
    //   HiddenOrderState.WaitingOrderReject2,
    // ].contains(widget.model.hiddenOrderState) ) {
    //   tabLength = 3;
    // }
    _tabController = TabController(length: length, vsync: this);

    return {
      "tabs": mainTabs,
      "body": body,
      "length": length,
    };
  }

  @override
  Widget build(BuildContext context) {
    var data = rebuildWidget();
    return DefaultTabController(
      length: data["length"],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: EditOrderHeader(),
              ),
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
                  tabs: data["tabs"],
                ),
              ),
            ];
          },
          body: Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: data["body"],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
                EditOrderBottom(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

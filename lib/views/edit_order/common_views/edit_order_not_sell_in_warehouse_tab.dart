import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_delivered_tab.dart';

class EditOrderSellNotInWareHouseTab extends StatefulWidget {
  const EditOrderSellNotInWareHouseTab({Key? key}) : super(key: key);

  @override
  _EditOrderSellNotInWareHouseTabState createState() =>
      _EditOrderSellNotInWareHouseTabState();
}

class _EditOrderSellNotInWareHouseTabState
    extends State<EditOrderSellNotInWareHouseTab>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  final List<Widget> mainTabs = [
    Tab(
        child: Text('Sản phẩm',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ))),
    Tab(
      child: Text('Vỏ nhận',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          )),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                  tabs: mainTabs,
                ),
              ),
            ];
          },
          body: Container(
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      ListProductLocationView(),
                      ReceivingShellDeliveredTab(),
                    ],
                  ),
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

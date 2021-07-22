import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/tabs/product_tab.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_tab.dart';
import 'package:frappe_app/views/edit_order/tabs/signature_tab.dart';

class EditOrderSellInWareHouse extends StatefulWidget {
  final EditOrderViewModel model;
  const EditOrderSellInWareHouse(this.model, {Key? key}) : super(key: key);

  @override
  _EditOrderSellInWareHouseState createState() =>
      _EditOrderSellInWareHouseState();
}

class _EditOrderSellInWareHouseState extends State<EditOrderSellInWareHouse>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  final List<Widget> mainTabs = [
    Tab(
      child: Text('Vỏ nhận',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          )),
    ),
    Tab(
        child: Text('Sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ))),
    Tab(
      child: Text(
        'Ký xác nhận',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: EditOrderHeader(
                  widget.model.customerValue,
                  widget.model.sellInWarehouse,
                  widget.model.customerSelect,
                  widget.model.sellInWarehouseSelection,
                  customers: widget.model.customers,
                  readOnlyView: widget.model.readOnlyView,
                ),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                ReceivingShellTab(),
                ProductTab(),
                SignatureTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

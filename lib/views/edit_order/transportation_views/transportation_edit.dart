import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/transportation_views/order_detail_tab.dart';
import 'package:frappe_app/views/edit_order/transportation_views/transportation_detail.dart';

import '../../base_view.dart';
import '../../customize_app_bar.dart';
import 'transportation_signature_tab.dart';

class TransportationEdit extends StatefulWidget {
  final TransportationKey address;
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final bool isLatest;
  TransportationEdit({Key? key, required this.address, this.isLatest = false})
      : super(key: key);

  @override
  _TransportationEditState createState() => _TransportationEditState();
}

class _TransportationEditState extends State<TransportationEdit>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  final List<Widget> mainTabs = [
    Tab(
      child: Text(
        'Chi tiết đơn',
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

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
      onModelReady: (model) {
        // this.initTab();
      },
      onModelClose: (model) {
        // model.disposed();
        // _tabController.dispose();
        // _secondTabController.dispose();
        // _scrollController.dispose();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomizeAppBar(
            widget.address.diaChi,
            leftAction: () {
              Navigator.pop(context);
            },
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 24),
              //   child: Center(
              //     child: Text(
              //       model.orderStatus,
              //       style: TextStyle(
              //         color: hexToColor('#0072BC'),
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          body: DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    // SliverToBoxAdapter(
                    //   child: EditOrderHeader(),
                    // ),
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
                            OrderDetailTab(
                              address: widget.address,
                            ),
                            TransportationSignatureTab(
                              address: widget.address,
                              isLatest: widget.isLatest,
                            ),
                          ],
                        ),
                      ),
                      // EditOrderBottom(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

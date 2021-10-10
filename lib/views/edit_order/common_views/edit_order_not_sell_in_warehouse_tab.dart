import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_delivered_tab.dart';

class EditOrderSellNotInWareHouseTab extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderSellNotInWareHouseTab({Key? key}) : super(key: key);

  @override
  _EditOrderSellNotInWareHouseTabState createState() =>
      _EditOrderSellNotInWareHouseTabState();
}

class _EditOrderSellNotInWareHouseTabState
    extends State<EditOrderSellNotInWareHouseTab>
    with TickerProviderStateMixin {
  // late ScrollController _scrollController;
  // late TabController _tabController;
  // final List<Widget> mainTabs = [
  //   Tab(
  //       child: Text('Sản phẩm',
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w700,
  //           ))),
  //   Tab(
  //     child: Text('Vỏ nhận',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w700,
  //         )),
  //   ),
  // ];

  @override
  void initState() {
    // _tabController = TabController(length: 2, vsync: this);
    // _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Product> filteredList = widget.model.productForLocations.where(
        (element) =>
            element.actualQuantity != null &&
            element.actualQuantity != 0 &&
            element.actualQuantity != element.quantity);
    var totalHoanTra = filteredList.fold<int>(
        0, (sum, item) => sum + (item.quantity - item.actualQuantity));
    var totalNhapKho =
        widget.model.nhapKhos.fold<int>(0, (sum, item) => sum + item.amount);
    var totalTraVe =
        widget.model.traVes.fold<int>(0, (sum, item) => sum + item.amount);

    var totalXe = totalHoanTra + totalNhapKho;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
      child:
          // NestedScrollView(
          //   controller: _scrollController,
          //   headerSliverBuilder: (context, value) {
          //     return [
          //       SliverToBoxAdapter(
          //         child: EditOrderHeader(),
          //       ),
          //       SliverToBoxAdapter(
          //         child: TabBar(
          //           controller: _tabController,
          //           labelColor: hexToColor('#FF0F00'),
          //           // isScrollable: true,
          //           labelStyle: TextStyle(
          //             color: hexToColor('#FF0F00'),
          //             fontSize: 20,
          //             fontWeight: FontWeight.w700,
          //           ),
          //           unselectedLabelColor: hexToColor('#00478B'),
          //           indicatorColor: Colors.transparent,
          //           tabs: mainTabs,
          //         ),
          //       ),
          //     ];
          //   },
          //   body:
          // ),
          Container(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EditOrderHeader(),
                            Text(
                              'Thống kê xe về',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(36.0, 0, 24.0, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tổng xe về',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.65),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$totalXe',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sản phảm trả về ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.65),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$totalHoanTra',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Vỏ nhập',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.65),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$totalNhapKho',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Vỏ trả khách ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.65),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '$totalTraVe',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tổng nhập ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.65),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${totalNhapKho - totalTraVe}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: hexToColor('#FF2D1F'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListProductLocationView(),
                          ],
                        ),
                      )
                      // TabBarView(
                      //   physics: NeverScrollableScrollPhysics(),
                      //   controller: _tabController,
                      //   children: [
                      //     ListProductLocationView(),
                      //     ReceivingShellDeliveredTab(),
                      //   ],
                      // ),
                      ),
                ),
                Visibility(
                  visible: !["Chờ xác nhận", "Hoàn thành"]
                      .contains(widget.model.donNhapKho!.status),
                  child: SizedBox(
                    height: 80,
                  ),
                ),
              ],
            ),
            Visibility(
              child: EditOrderBottom(),
              visible: !["Chờ xác nhận", "Hoàn thành"]
                  .contains(widget.model.donNhapKho!.status),
            ),
          ],
        ),
      ),
    );
  }
}

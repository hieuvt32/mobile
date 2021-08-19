import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/don_bao_binh_loi.dart';
import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_gas_broken/list_broken_gas_address.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_view.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/item_cart_order.dart';
import 'package:frappe_app/views/rating_view/rating_view.dart';
import 'package:frappe_app/widgets/limit_text_length.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

enum OrderStatus { awaitConfirm, ordered, delivery, delivered, cancelled }

final Map<OrderStatus, Color> mappingStatusColor = {
  OrderStatus.awaitConfirm: hexToColor("#FFEC44"),
  OrderStatus.ordered: hexToColor("#0072BC"),
  OrderStatus.delivery: hexToColor("#FF0F00"),
  OrderStatus.delivered: hexToColor("#1BBD5C"),
  OrderStatus.cancelled: hexToColor("#000000").withOpacity(0.3),
};

class CustomerListOrderView extends StatefulWidget {
  @override
  CustomerListOrderViewState createState() => CustomerListOrderViewState();
}

class CustomerListOrderViewState extends State<CustomerListOrderView>
    with SingleTickerProviderStateMixin {
  final List<Widget> myTabs = [
    "Chờ xác nhận",
    "Đã đặt",
    "Đang giao",
    "Đã giao",
    "Đã hủy"
  ].map((tabName) {
    return Tab(
      child: Text(
        tabName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }).toList();

  late TabController _tabController;
  late ScrollController _scrollController;

  // Color getColorByStatus(OrderStatus status  )  {
  //   switch(status ) {
  //     case OrderStatus.awaitConfirm
  //       return
  //   }
  // }

  Widget buildCardContent(List<Product> products, int sellInWarehouse) {
    Map<String, double> totalPriceByAddress = {};

    int totalQuantity = 0;
    double totalPrice = 0;

    products.forEach((product) {
      totalQuantity += product.quantity;
      totalPrice += product.unitPrice;

      totalPriceByAddress[product.diaChi] =
          totalPriceByAddress[product.diaChi] ?? 0 + product.unitPrice;
    });

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4))),
        child: sellInWarehouse == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Text("Số lượng"),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            totalQuantity.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "-",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(
                        totalPrice.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hexToColor("#FF0F00")),
                        textAlign: TextAlign.end,
                      ))
                ],
              )
            : Column(
                children: totalPriceByAddress.keys
                    .map((address) => Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Row(
                                    children: [
                                      Text("Địa chỉ:"),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      LimitTextLength(
                                        text: address,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    totalPriceByAddress[address].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: hexToColor("#FF0F00")),
                                    textAlign: TextAlign.end,
                                  ))
                            ],
                          ),
                        ))
                    .toList(),
              ));
  }

  Widget _buildTabContent(OrderStatus status, List<Order> listOrder) {
    Color headerColor = mappingStatusColor[status] ?? hexToColor("#FFEC44");

    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listOrder.length,
          itemBuilder: (ctx, index) {
            Order item = listOrder[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return EditOrderView(
                        name: listOrder[index].name,
                        haveDelivery: true,
                        isRated: listOrder[index].isRated ?? 0,
                      );
                    },
                  ),
                ).then((refresh) =>
                    (refresh != null && refresh) ? this._onFetchData() : false);
              },
              child: ItemCardOrder(
                headerColor: headerColor,
                cartContent:
                    buildCardContent(item.products, item.sellInWarehouse),
                leftHeaderText: item.name,
                rightHeaderText: DateFormat('dd/MM/yyyy').format(item.creation),
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

  ListOrderResponse? _awaitConfirmRespone;
  ListOrderResponse? _orderedResponse;
  ListOrderResponse? _deliveryResponse;
  ListOrderResponse? _deliveredResponse;
  ListOrderResponse? _canceledResponse;

  bool isLoading = true;

  Future _onFetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      String? userId = Config().userId;
      String customerCode = userId!.split("@")[0];

      List<ListOrderResponse> listResponse = await Future.wait([
        locator<Api>().getListOrder(
          0,
          customer: customerCode,
          type: "B",
        ),
        locator<Api>().getListOrder(
          1,
          customer: customerCode,
          type: "B",
        ),
        locator<Api>().getListOrder(
          2,
          customer: customerCode,
          type: "B",
        ),
        locator<Api>().getListOrder(
          3,
          customer: customerCode,
          type: "B",
        ),
        locator<Api>().getListOrder(
          4,
          customer: customerCode,
          type: "B",
        )
      ]);

      setState(() {
        _orderedResponse = listResponse[0];
        _deliveryResponse = listResponse[1];
        _deliveredResponse = listResponse[2];
        _awaitConfirmRespone = listResponse[3];
        _canceledResponse = listResponse[4];
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {});

    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabListener);

    _awaitConfirmRespone = ListOrderResponse(orders: []);
    _orderedResponse = ListOrderResponse(orders: []);
    _deliveryResponse = ListOrderResponse(orders: []);
    _deliveredResponse = ListOrderResponse(orders: []);
    _canceledResponse = ListOrderResponse(orders: []);

    _onFetchData();

    super.initState();
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
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dánh sách đơn hàng"),
          ),
          body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, value) {
                return [
                  //SliverToBoxAdapter(child: _buildCarousel()),
                  SliverToBoxAdapter(
                    child: TabBar(
                      isScrollable: true,
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
              body: !isLoading
                  ? Container(
                      child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent(OrderStatus.awaitConfirm,
                            _awaitConfirmRespone!.orders!),
                        _buildTabContent(
                            OrderStatus.ordered, _orderedResponse!.orders!),
                        _buildTabContent(
                            OrderStatus.delivery, _deliveryResponse!.orders!),
                        _buildTabContent(
                            OrderStatus.delivered, _deliveredResponse!.orders!),
                        _buildTabContent(
                            OrderStatus.cancelled, _canceledResponse!.orders!),
                      ],
                    ))
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
        ));
  }
}

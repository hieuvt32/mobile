import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/widgets/limit_text_length.dart';
import 'package:intl/intl.dart';

import '../../base_view.dart';
import '../../customize_app_bar.dart';
import '../../item_cart_order.dart';
import 'transportation_detail.dart';
import 'transportation_viewmodel.dart';

class TransportationList extends StatefulWidget {
  final TransportationViewModel model = locator<TransportationViewModel>();
  TransportationList({Key? key}) : super(key: key);

  @override
  _TransportationListState createState() => _TransportationListState();
}

class _TransportationListState extends State<TransportationList> {
  Widget buildCardContent(List<MapEntry<String, int>> addresses, Widget head) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4))),
        child: Column(
          children: [
            head,
            ...addresses
                .map((value) => Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text("Địa chỉ:")),
                          Expanded(
                            child: LimitTextLength(
                              text: value.key,
                            ),
                          ),
                          Expanded(
                              child: LimitTextLength(
                            text: "${value.value}",
                            textAlign: TextAlign.end,
                          )),
                        ],
                      ),
                    ))
                .toList()
          ],
        ));
  }

  Widget _buildTabContent() {
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.model.orders.length,
          itemBuilder: (ctx, index) {
            Order item = widget.model.orders[index];
            List<MapEntry<String, int>> addresses = [];
            groupBy<Product, String>(item.products, (obj) => obj.diaChi)
                .map((key, value) {
              addresses.add(MapEntry(key, value.length));
              return MapEntry(key, value);
            });

            return GestureDetector(
              onTap: () {
                if (item.status != "Đã đặt hàng") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return TransportationDetail(
                          name: item.name,
                        );
                      },
                    ),
                  );
                }
              },
              child: ItemCardOrder(
                cartContent: buildCardContent(
                    addresses,
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Khách hàng:"),
                          ),
                          Expanded(
                            child: LimitTextLength(
                              text: item.vendorName,
                            ),
                          ),
                          Expanded(
                              child: LimitTextLength(
                            text: item.vendor,
                            textAlign: TextAlign.end,
                          )),
                        ],
                      ),
                    )),
                leftHeaderText: item.name,
                rightHeaderText: DateFormat('dd/MM/yyyy').format(item.creation),
                headerColor: getHeaderColor(item.status),
              ),
            );
          }),
    );
  }

  Color getHeaderColor(String status) {
    switch (status) {
      case "Đã đặt hàng":
        return Color.fromRGBO(0, 114, 188, 1);
      case "Đang giao hàng":
        return Color.fromRGBO(255, 15, 0, 1);
      case "Đã giao hàng":
        return Color.fromRGBO(27, 189, 92, 1);
      default:
    }

    return Color.fromRGBO(0, 114, 188, 1);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<TransportationViewModel>(
      onModelReady: (model) async {
        // model.setName(widget.name);
        await model.init();
        // model.setHaveDelivery(widget.haveDelivery);
        // this.initTab();
      },
      onModelClose: (model) {
        // _tabController.dispose();
        // _secondTabController.dispose();
        // _scrollController.dispose();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomizeAppBar(
          "Danh sách đơn vận chuyển",
          leftAction: () {
            Navigator.pop(context);
          },
          actions: [],
        ),
        body: !model.isLoading
            ? _buildTabContent()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

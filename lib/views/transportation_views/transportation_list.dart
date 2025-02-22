import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/item_cart_order.dart';
import 'package:frappe_app/widgets/limit_text_length.dart';
import 'package:intl/intl.dart';

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
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(
          children: [
            head,
            ...addresses
                .map((value) => Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Text("Địa chỉ:")),
                          Expanded(
                            child: LimitTextLengthNoneFlexible(
                              text: value.key != null ? value.key : "",
                            ),
                          ),
                          Expanded(
                              child: LimitTextLengthNoneFlexible(
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
              addresses.add(MapEntry(
                  key, value.fold<int>(0, (sum, item) => sum + item.quantity)));
              return MapEntry(key, value);
            });

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return TransportationDetail(
                        name: item.name,
                      );
                    },
                  ),
                );
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
                            child: LimitTextLengthNoneFlexible(
                              text: item.vendorName != null
                                  ? item.vendorName
                                  : "",
                            ),
                          ),
                          Expanded(
                              child: LimitTextLengthNoneFlexible(
                            text: item.vendor != null ? item.vendor : "",
                            textAlign: TextAlign.end,
                          )),
                        ],
                      ),
                    )),
                leftHeaderText: item.name,
                rightHeaderText:
                    DateFormat('dd/MM/yyyy HH:mm').format(item.creation),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                child: FrappeIcon(
                  FrappeIcons.refresh,
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    model.init();
                  });
                },
              ),
            )
          ],
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

class LimitTextLengthNoneFlexible extends StatelessWidget {
  LimitTextLengthNoneFlexible(
      {required this.text, this.style, this.textAlign = TextAlign.start});

  final TextStyle? style;
  final String text;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(fontSize: 10.0),
      text: TextSpan(
          style: style == null
              ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
              : style,
          text: text),
      textAlign: this.textAlign,
    );
  }
}

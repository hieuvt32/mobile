import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_view.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:intl/intl.dart';

import 'transportation_bottom.dart';
import 'transportation_edit.dart';
import 'transportation_header.dart';

class TransportationDetail extends StatefulWidget {
  final String? name;
  TransportationDetail({Key? key, this.name}) : super(key: key);

  @override
  _TransportationDetailState createState() => _TransportationDetailState();
}

class TransportationKey {
  String diaChi;
  String address;
  TransportationKey(this.address, this.diaChi);
}

class _TransportationDetailState extends State<TransportationDetail> {
  Widget _buildTabContent(EditOrderViewModel model) {
    List<MapEntry<TransportationKey, List<Product>>> datas = [];
    groupBy<Product, String>(model.productForLocations, (obj) => obj.address)
        .map((key, value) {
      datas.add(MapEntry(
          TransportationKey(key, value.length > 0 ? value[0].diaChi : ''),
          value));
      return MapEntry(key, value);
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Thông tin đơn hàng",
                style: TextStyle(
                    // color: Color.fromRGBO(255, 15, 0, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 12,
            ),
            ...datas.map((e) {
              var giaoViewSig =
                  model.getGiaoViecSignatureByAddress(e.key.address);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text("Địa chỉ: ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text("${e.key.diaChi}",
                                    style: TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                flex: 8,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text("Thời gian: ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                    "${DateFormat('HH:mm - dd/MM/yyyy').format(model.order!.modified)}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                flex: 8,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text("Trạng thái: ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                    "${giaoViewSig != null ? giaoViewSig.status : model.order!.status}",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 71, 139, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                flex: 8,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 1,
                        color: Color.fromRGBO(0, 114, 188, 0.5),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (model.order!.status != "Đã giao hàng") {
                      var length = model.giaoViecSignatures
                          .where(
                              (element) => element.status == "Đang giao hàng")
                          .length;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return TransportationEdit(
                              // name: item.name,
                              address: e.key,
                              isLatest: length == datas.length - 1 ||
                                  datas.length == 1,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
      onModelReady: (model) async {
        model.setName(widget.name);
        model.init();
        await model.initPreData();
        // this.initTab();
      },
      onModelClose: (model) {
        model.disposed();
        // _tabController.dispose();
        // _secondTabController.dispose();
        // _scrollController.dispose();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomizeAppBar(
            model.title,
            leftAction: () {
              Navigator.pop(context);
            },
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Center(
                  child: Text(
                    model.orderStatus,
                    style: TextStyle(
                      color: hexToColor('#0072BC'),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: !model.isLoading
              ? Stack(
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
                                  TransportationHeader(),
                                  _buildTabContent(model),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                    TransportationBottom()
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}

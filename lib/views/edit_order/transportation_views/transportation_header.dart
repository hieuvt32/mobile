import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:intl/intl.dart';

class TransportationHeader extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  TransportationHeader({Key? key}) : super(key: key);

  @override
  _TransportationHeaderState createState() => _TransportationHeaderState();
}

class _TransportationHeaderState extends State<TransportationHeader> {
  @override
  Widget build(BuildContext context) {
    var actualQuantity = widget.model.productForLocations
        .fold<int>(0, (sum, item) => sum + item.actualQuantity);
    var quantity = widget.model.productForLocations
        .fold<int>(0, (sum, item) => sum + item.quantity);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Mã KH: ",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.75),
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          flex: 4,
                        ),
                        Expanded(
                            flex: 6,
                            child: Text("${widget.model.customerValue}"))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("SĐT: ",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.75),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            flex: 4),
                        Expanded(
                            flex: 6,
                            child: Text("${widget.model.order!.phone}"))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Mã đơn: ",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.75),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            flex: 4),
                        Expanded(
                            flex: 6, child: Text("${widget.model.order!.name}"))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Ngày tạo: ",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.75),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            flex: 4),
                        Expanded(
                          flex: 6,
                          child: Text(
                              "${DateFormat('dd/MM/yyyy').format(widget.model.order!.creation)}"),
                        )
                      ],
                    )
                  ],
                ),
                flex: 6,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text("Số lượng đã giao"),
                    Text("$actualQuantity",
                        style: TextStyle(
                            color: Color.fromRGBO(33, 33, 33, 1),
                            fontSize: 24,
                            fontWeight: FontWeight.w700)),
                    Container(
                      child: const Divider(
                        color: Colors.black,
                        height: 1,
                        thickness: 1,
                        indent: 1,
                        endIndent: 1,
                      ),
                      width: 52,
                    ),
                    Text("$quantity",
                        style: TextStyle(
                            color: Color.fromRGBO(255, 15, 0, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                flex: 4,
              ),
            ],
          )
        ],
      ),
    );
  }
}

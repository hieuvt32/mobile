import 'package:flutter/material.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/utils/helpers.dart';

class EditOrderHeader extends StatefulWidget {
  final List<Customer> customers;
  final bool readOnlyView;
  final String? customerValue;
  final bool sellInWareHouse;
  final Function(dynamic) customerSelection;
  final Function(bool?) sellInWarehouseSelection;
  const EditOrderHeader(
    this.customerValue,
    this.sellInWareHouse,
    this.customerSelection,
    this.sellInWarehouseSelection, {
    Key? key,
    required this.customers,
    required this.readOnlyView,
  }) : super(key: key);

  @override
  _EditOrderHeaderState createState() => _EditOrderHeaderState();
}

class _EditOrderHeaderState extends State<EditOrderHeader> {
  @override
  Widget build(BuildContext context) {
    var customerMap = Map.fromIterable(widget.customers,
        key: (v) => v.name, value: (v) => v.realName);

    return Container(
      padding: EdgeInsets.fromLTRB(28, 12, 28, 8),
      color: hexToColor('#FFE4E4'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên khách hàng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    !widget.readOnlyView
                        ? Container(
                            height: 36,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                items: widget.customers.map((e) {
                                  return DropdownMenuItem<dynamic>(
                                    child: Text(e.realName),
                                    value: e.name,
                                  );
                                }).toList(),
                                value: widget.customerValue,
                                onChanged: widget.customerSelection,

                                // keyboardType: this.keyboardType,
                                // decoration: InputDecoration(
                                //   enabledBorder:
                                //       const OutlineInputBorder(
                                //     borderRadius: BorderRadius.all(
                                //         Radius.circular(0.0)),
                                //     borderSide: const BorderSide(
                                //       color: Colors.grey,
                                //     ),
                                //   ),
                                // ),

                                style: TextStyle(
                                  fontSize: 13.0,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                // controller: controller,
                                // height: 10,
                              ),
                            ),
                          )
                        : Text(
                            customerMap[widget.customerValue],
                            style: TextStyle(fontSize: 14),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            checkColor: Colors.white,
                            splashRadius: 4,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: widget.sellInWareHouse,
                            onChanged: widget.sellInWarehouseSelection,
                          ),
                        ),

                        Expanded(
                          child: Text('Bán Hàng Tại Kho',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          flex: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(''),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã khách hàng',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(widget.customerValue != null
                        ? widget.customerValue!
                        : ''),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.black;
  }
}

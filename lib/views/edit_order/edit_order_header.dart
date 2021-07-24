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
      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
      // color: hexToColor('#FFE4E4'),
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
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
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
                                borderRadius: BorderRadius.circular(4)),
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
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            checkColor: Colors.white,
                            splashRadius: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: widget.sellInWareHouse,
                            onChanged: widget.sellInWarehouseSelection,
                          ),
                        ),

                        Text(
                          'Bán Hàng Tại Kho',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(0, 0, 0, 0.75),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.customerValue != null ? widget.customerValue! : '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                      ),
                    ),
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
    return Color.fromRGBO(0, 0, 0, 0.5);
  }
}

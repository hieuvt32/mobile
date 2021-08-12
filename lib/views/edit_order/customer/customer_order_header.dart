import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';

class CustomerOrderHeader extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  CustomerOrderHeader({
    Key? key,
  }) : super(key: key);

  @override
  _EditOrderHeaderState createState() => _EditOrderHeaderState();
}

class _EditOrderHeaderState extends State<CustomerOrderHeader> {
  @override
  Widget build(BuildContext context) {
    var customerMap = Map.fromIterable(widget.model.customers,
        key: (v) => v.code, value: (v) => v.name);

    String customerCode = Config().customerCode;

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
                    Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          customerMap[customerCode] ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 0.75),
                          ),
                        ),
                      ],
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
                            value: widget.model.sellInWarehouse,
                            onChanged: (checked) {},
                          ),
                        ),

                        Text(
                          'Lưu đơn mẫu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.model.orderState !=
                                    OrderState.PreNewOrder
                                ? hexToColor('#AAAAAA')
                                : Color.fromRGBO(0, 0, 0, 0.75),
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
                      customerCode,
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

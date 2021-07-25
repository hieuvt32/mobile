import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';

class EditOrderBottom extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderBottom({Key? key}) : super(key: key);

  @override
  _EditOrderBottomState createState() => _EditOrderBottomState();
}

class _EditOrderBottomState extends State<EditOrderBottom> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Visibility(
          visible: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: hexToColor('#FF0F00'),
                  // side: BorderSide(
                  //   width: 1.0,
                  // ),
                  minimumSize: Size(120, 32),
                  // padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    // side: BorderSide(
                    //   color: hexToColor('#0072BC'),
                    // ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: hexToColor('#0072BC'),
                  // side: BorderSide(
                  //   width: 1.0,
                  // ),

                  minimumSize: Size(120, 32),
                  // padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    // side: BorderSide(
                    //   color: hexToColor('#FF0F00'),
                    // ),
                  ),
                ),
                onPressed: () async {
                  await widget.model.createOrder(context);
                },
                child: Text(
                  widget.model.sellInWarehouse ? 'Hoàn thành' : 'Tạo đơn',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

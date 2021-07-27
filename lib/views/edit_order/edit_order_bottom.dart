import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/edit_order_not_confirm_modal.dart';
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
          child: _buildBottomButton(),
        ),
      ),
    );
  }

  _buildBottomButton() {
    switch (widget.model.orderState) {
      case OrderState.PreNewOrder:
      case OrderState.NewOrder:
        return Row(
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
                if (widget.model.orderState == OrderState.PreNewOrder)
                  await widget.model.createOrder(context);
                else {
                  await widget.model.updateOrder(context);
                }
              },
              child: Text(
                widget.model.sellInWarehouse
                    ? 'Hoàn thành'
                    : (widget.model.orderState == OrderState.PreNewOrder
                        ? 'Tạo đơn'
                        : 'Lưu'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      case OrderState.WaitingForShipment:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: hexToColor('#FF0F00'),
            // side: BorderSide(
            //   width: 1.0,
            // ),
            minimumSize: Size(double.infinity, 48),
            // padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              // side: BorderSide(
              //   color: hexToColor('#0072BC'),
              // ),
            ),
          ),
          onPressed: () async {
            await widget.model.updateOrder(context, status: 'Đang giao hàng');
          },
          child: Text(
            'Xác nhận xuất kho',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      case OrderState.Delivering:
        return Text('');
      case OrderState.Delivered:
        return widget.model.sellInWarehouse
            ? Text('')
            : Row(
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
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return GestureDetector(
                            onTap: () {},
                            child: EditOrderNotConfirmModal(),
                            behavior: HitTestBehavior.opaque,
                          );
                        },
                      );
                    },
                    child: Text(
                      'Không xác nhận',
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
                      if (widget.model.orderState == OrderState.PreNewOrder)
                        await widget.model.createOrder(context);
                      else {
                        await widget.model.updateOrder(context);
                      }
                    },
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              );
      default:
    }
  }
}

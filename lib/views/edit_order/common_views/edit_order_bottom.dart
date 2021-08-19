import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/dialog.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_not_confirm_modal.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/common_views/tracking_order_view.dart';
import 'package:frappe_app/views/rating_view/rating_view.dart';
import 'package:intl/intl.dart';

class EditOrderBottom extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderBottom({Key? key}) : super(key: key);

  @override
  _EditOrderBottomState createState() => _EditOrderBottomState();
}

class _EditOrderBottomState extends State<EditOrderBottom> {
  bool _isButtonLoading = false;

  Future onDeleteOrder() async {
    ConfirmDialog.showConfirmDialog(context, onCancel: () {
      Navigator.of(context, rootNavigator: true).pop();
    }, onConfirm: () async {
      setState(() {
        _isButtonLoading = true;
      });

      Navigator.of(context, rootNavigator: true).pop();
      await widget.model.deleteOrder(context, widget.model.order!.name);

      setState(() {
        _isButtonLoading = false;
      });
    }, content: "Bạn có chắc chắn muốn xóa đơn hàng này không?");
  }

  Future onCancelOrder() async {
    setState(() {
      _isButtonLoading = true;
    });

    ConfirmDialog.showConfirmDialog(context, onCancel: () {
      Navigator.of(context, rootNavigator: true).pop();
    }, onConfirm: () {
      Navigator.of(context, rootNavigator: true).pop();
      widget.model.cancelOrder(context);
    }, content: "Bạn có chắc chắn muốn hủy đơn hàng đã đặt này không?");

    setState(() {
      _isButtonLoading = false;
    });
  }

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
      case OrderState.WaitForComfirm:
        return Container(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: hexToColor("#FF0F00"))),
            height: 48,
            width: double.infinity,
            child: TextButton(
                onPressed: _isButtonLoading ? null : onCancelOrder,
                child: Text(
                  _isButtonLoading ? '...Loading' : "Hủy đơn hàng",
                  style: TextStyle(color: hexToColor("#FF0F00"), fontSize: 16),
                )),
          ),
        );

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
                widget.model.userRoles.contains(UserRole.KhachHang)
                    ? "Đặt hàng"
                    : widget.model.sellInWarehouse
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
        if (widget.model.isAvailableRoles([UserRole.KhachHang]))
          return SizedBox();

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
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: hexToColor("#0072BC")),
          height: 48,
          width: double.infinity,
          child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TrackingOrderView();
                }));
              },
              child: Text(
                "Tracking đơn hàng",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        );
      case OrderState.Delivered:
        if (widget.model.isAvailableRoles([UserRole.KhachHang])) {
          if (widget.model.isRated == 1) {
            return SizedBox();
          }
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor("#1BBD5C")),
            height: 48,
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return RatingView(
                      orderName: widget.model.order!.name,
                    );
                  }));
                },
                child: Text(
                  "Đánh giá dịch vụ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          );
        }
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
      case OrderState.Cancelled:
        return Column(
          children: [
            Row(
              children: [
                Text("Người hủy: "),
                Text(widget.model.order!.cancelPerson,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Text("Thời gian hủy: "),
                Text(
                    "${DateFormat('dd/MM/yyyy').format(widget.model.order!.cancelDate ?? DateTime.now())}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
            widget.model.order!.cancelReason != null
                ? Row(
                    children: [
                      Text("Lý do hủy: "),
                      Text(widget.model.order!.cancelReason,
                          style: TextStyle(
                            fontSize: 16,
                          ))
                    ],
                  )
                : SizedBox(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: hexToColor("#FF0F00"))),
              height: 48,
              width: double.infinity,
              child: TextButton(
                  onPressed: _isButtonLoading ? null : onDeleteOrder,
                  child: Text(
                    _isButtonLoading ? "...Loading" : "Xóa đơn hàng",
                    style:
                        TextStyle(color: hexToColor("#FF0F00"), fontSize: 16),
                  )),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}

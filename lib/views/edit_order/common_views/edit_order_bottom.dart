import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/dialog.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_not_confirm_modal.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/common_views/tracking_order_view.dart';
import 'package:frappe_app/views/rating_view/rating_view.dart';
import 'package:intl/intl.dart';

class EditOrderBottom extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();

  final bool isDieuPhoi;
  final bool isNhaCungCap;
  EditOrderBottom({
    Key? key,
    this.isNhaCungCap = false,
    this.isDieuPhoi = false,
  }) : super(key: key);

  @override
  _EditOrderBottomState createState() => _EditOrderBottomState();
}

class _EditOrderBottomState extends State<EditOrderBottom> {
  bool _isButtonLoading = false;
  TextEditingController dialogTextEditcontroller = TextEditingController();

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

    if (widget.model.isAvailableRoles([UserRole.KhachHang])) {
      ConfirmDialog.showConfirmDialog(context, onCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      }, onConfirm: () {
        Navigator.of(context, rootNavigator: true).pop();

        widget.model.cancelOrder(context: context);
      }, content: "Bạn có chắc chắn muốn hủy đơn hàng đã đặt này không?");
    } else if (widget.model.isAvailableRoles([UserRole.DieuPhoi])) {
      ConfirmDialog.showEditingDialog(context, onCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      }, onConfirm: () {
        Navigator.of(context, rootNavigator: true).pop();

        widget.model.cancelOrder(
            context: context, reason: dialogTextEditcontroller.value.text);
      }, title: "Lý do từ chối.", controller: dialogTextEditcontroller);
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Visibility(
        visible: true,
        child: _buildBottomButton(),
      ),
    );
  }

  _buildBottomButton() {
    switch (widget.model.orderState) {
      case OrderState.WaitForComfirm:
        if (widget.model.isAvailableRoles([UserRole.KhachHang])) {
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
                    style:
                        TextStyle(color: hexToColor("#FF0F00"), fontSize: 16),
                  )),
            ),
          );
        } else if (widget.model.isAvailableRoles([UserRole.DieuPhoi])) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: hexToColor('#FF0F00'),
                  minimumSize: Size(120, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: onCancelOrder,
                child: Text(
                  'Từ chối',
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
                  minimumSize: Size(120, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () async {
                  widget.model.confirmOrder(context);
                },
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        }

        return SizedBox();

      case OrderState.PreNewOrder:
      case OrderState.NewOrder:
        return generateButtons();
      case OrderState.WaitingForShipment:
        if (widget.model
            .isAvailableRoles([UserRole.KhachHang, UserRole.DieuPhoi]))
          return SizedBox();
        if (widget.model.order!.status == "Đã đặt hàng" &&
            (widget.model.donNhapKho!.status == "Đợi xác nhận xuất kho" ||
                widget.model.donNhapKho!.status == "Chờ nhập hàng"))
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
              if (widget.model.donNhapKho!.status == "Chờ nhập hàng" &&
                  widget.model.order!.status == "Đã đặt hàng") {
                await widget.model.updateOrder(context,
                    status: "Đã đặt hàng",
                    statusDonNhapKho: "Đợi xác nhận giao hàng");
              }

              if (widget.model.donNhapKho!.status == "Đợi xác nhận xuất kho" &&
                  widget.model.order!.status == "Đã đặt hàng") {
                await widget.model.updateOrder(context,
                    status: "Đang giao hàng",
                    statusDonNhapKho: "Đồng ý từ 2 bên");
              }
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

        return SizedBox();

      case OrderState.Delivering:
        if (widget.model.isAvailableRoles([UserRole.ThuKho])) return SizedBox();

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
        if (widget.isDieuPhoi) {
          return getButtonDieuPhoi();
        }

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
        } else if (widget.model.isAvailableRoles([UserRole.DieuPhoi])) {
          if (widget.model.donNhapKho!.reasonEdit != null &&
              widget.model.donNhapKho!.reasonEdit!.length > 0) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: hexToColor("#0072BC")),
              height: 48,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    widget.model.confirmEditingRequest(context);
                  },
                  child: Text(
                    "Xác nhận yêu cầu chỉnh sửa",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            );
          }
          return SizedBox();
        }
        return widget.model.sellInWarehouse || widget.isNhaCungCap
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
                        if (widget.model.sellInWarehouse) {
                          await widget.model.updateOrder(
                            context,
                            status: "Đã giao hàng",
                            statusDonNhapKho: "Hoàn thành",
                            isUpdateCongNoTienTaiKho: true,
                          );
                        } else {
                          await widget.model.updateOrder(
                            context,
                            status: "Đã giao hàng",
                            statusDonNhapKho: "Hoàn thành",
                            isUpdateCongNoTienKhongTaiKho: true,
                          );
                        }
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Text("Người hủy: "),
                Text(widget.model.order!.cancelPerson,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text("Thời gian hủy: "),
                Text(
                    "${DateFormat('dd/MM/yyyy HH:mm').format(widget.model.order!.cancelDate ?? DateTime.now())}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 8,
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
              margin: const EdgeInsets.only(top: 8),
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
      case OrderState.Waiting:
        return buildButtonThuKho12();
      default:
        return Container();
    }
  }

  Widget buildButtonThuKho12() {
    if (widget.model.isThuKho1) {
      if ([
        // HiddenOrderState.Temporary,
        // HiddenOrderState.WaitingOrderAccept1,
        HiddenOrderState.Waiting1,
        HiddenOrderState.Waiting2,
        HiddenOrderState.WaitingOrderAccept2,
      ].contains(widget.model.hiddenOrderState)) {
        return Container();
      }

      if ([
        // HiddenOrderState.Temporary,
        // HiddenOrderState.WaitingOrderAccept1,
        HiddenOrderState.WaitingOrderAccept1,
        HiddenOrderState.WaitingOrderReject1,
        HiddenOrderState.WaitingOrderReject2,
      ].contains(widget.model.hiddenOrderState)) {
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
              onPressed: () {
                // showModalBottomSheet(
                //   context: context,
                //   builder: (_) {
                //     return GestureDetector(
                //       onTap: () {},
                //       child: EditOrderNotConfirmModal(),
                //       behavior: HitTestBehavior.opaque,
                //     );
                //   },
                // );
              },
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
                  if ([
                    // HiddenOrderState.Temporary,
                    // HiddenOrderState.WaitingOrderAccept1,
                    HiddenOrderState.WaitingOrderAccept1,
                    // HiddenOrderState.WaitingOrderReject1,
                    HiddenOrderState.WaitingOrderReject2,
                  ].contains(widget.model.hiddenOrderState)) {
                    widget.model.hoaDonMuaBanHiddenStatus!.status = "Đơn chờ 2";
                    widget.model.hoaDonMuaBanHiddenStatus!.realName =
                        "Đơn chờ 2";
                  }

                  if ([
                    // HiddenOrderState.Temporary,
                    // HiddenOrderState.WaitingOrderAccept1,
                    HiddenOrderState.WaitingOrderReject1,
                    // HiddenOrderState.WaitingOrderReject1,
                    // HiddenOrderState.WaitingOrderReject2,
                  ].contains(widget.model.hiddenOrderState)) {
                    widget.model.hoaDonMuaBanHiddenStatus!.status = "Đơn chờ 1";
                    widget.model.hoaDonMuaBanHiddenStatus!.realName =
                        "Đơn chờ 1";
                  }
                  if ([
                    // HiddenOrderState.Temporary,
                    // HiddenOrderState.WaitingOrderAccept1,
                    HiddenOrderState.Waiting1,
                    HiddenOrderState.Waiting2,
                    // HiddenOrderState.WaitingOrderReject1,
                    // HiddenOrderState.WaitingOrderReject2,
                  ].contains(widget.model.hiddenOrderState)) {
                    await widget.model.updateOrder(context, status: "Đơn chờ");
                  }

                  await widget.model.updateHoaDonMuaBanHiddenStatus();
                  widget.model.changeState();
                }
              },
              child: Text(
                'Hoàn thành',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      }
    }

    if (widget.model.isThuKho2) {
      if ([
        // HiddenOrderState.Temporary,
        // HiddenOrderState.WaitingOrderAccept1,
        HiddenOrderState.Waiting1,
        HiddenOrderState.Waiting2,
        // HiddenOrderState.WaitingOrderAccept2,
      ].contains(widget.model.hiddenOrderState)) {
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
              onPressed: () async {
                // showModalBottomSheet(
                //   context: context,
                //   builder: (_) {
                //     return GestureDetector(
                //       onTap: () {},
                //       child: EditOrderNotConfirmModal(),
                //       behavior: HitTestBehavior.opaque,
                //     );
                //   },
                // );
                if ([
                  // HiddenOrderState.Temporary,
                  // HiddenOrderState.WaitingOrderAccept1,
                  HiddenOrderState.Waiting1,
                  // HiddenOrderState.WaitingOrderReject1,
                  // HiddenOrderState.WaitingOrderReject2,
                ].contains(widget.model.hiddenOrderState)) {
                  widget.model.hoaDonMuaBanHiddenStatus!.status =
                      "Đơn chờ không xác nhận 1";
                  widget.model.hoaDonMuaBanHiddenStatus!.realName =
                      "Đơn chờ không xác nhận 1";
                }

                if ([
                  // HiddenOrderState.Temporary,
                  // HiddenOrderState.WaitingOrderAccept1,
                  HiddenOrderState.Waiting2,
                  // HiddenOrderState.WaitingOrderReject1,
                  // HiddenOrderState.WaitingOrderReject2,
                ].contains(widget.model.hiddenOrderState)) {
                  widget.model.hoaDonMuaBanHiddenStatus!.status =
                      "Đơn chờ không xác nhận 2";
                  widget.model.hoaDonMuaBanHiddenStatus!.realName =
                      "Đơn chờ không xác nhận 2";
                }
                await widget.model.updateHoaDonMuaBanHiddenStatus();

                widget.model.changeState();
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
                  if ([
                    // HiddenOrderState.Temporary,
                    // HiddenOrderState.WaitingOrderAccept1,
                    HiddenOrderState.Waiting1,
                    // HiddenOrderState.WaitingOrderReject1,
                    // HiddenOrderState.WaitingOrderReject2,
                  ].contains(widget.model.hiddenOrderState)) {
                    widget.model.hoaDonMuaBanHiddenStatus!.status =
                        "Đơn chờ đã xác nhận 1";
                    widget.model.hoaDonMuaBanHiddenStatus!.realName =
                        "Đơn chờ đã xác nhận 1";
                  }

                  if ([
                    // HiddenOrderState.Temporary,
                    // HiddenOrderState.WaitingOrderAccept1,
                    HiddenOrderState.Waiting2,
                    // HiddenOrderState.WaitingOrderReject1,
                    // HiddenOrderState.WaitingOrderReject2,
                  ].contains(widget.model.hiddenOrderState)) {
                    widget.model.hoaDonMuaBanHiddenStatus!.status =
                        "Đơn chờ đã xác nhận 2";
                    widget.model.hoaDonMuaBanHiddenStatus!.realName =
                        "Đơn chờ đã xác nhận 2";
                    await widget.model.updateOrder(
                      context,
                      status: "Đã giao hàng",
                      isUpdateImage: false,
                      isUpdateCongNoTienTaiKho: true,
                    );
                  }
                  await widget.model.updateHoaDonMuaBanHiddenStatus();

                  widget.model.changeState();
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
      }

      // if ([
      //   // HiddenOrderState.Temporary,
      //   // HiddenOrderState.WaitingOrderAccept1,
      //   HiddenOrderState.WaitingOrderAccept1,
      //   HiddenOrderState.WaitingOrderAccept2,
      //   HiddenOrderState.WaitingOrderReject1,
      //   HiddenOrderState.WaitingOrderReject2,
      // ].contains(widget.model.hiddenOrderState)) {
      //   return Container();
      // }
    }
    return Container();
  }

  String getTextButtonPrimary() {
    if (widget.isDieuPhoi) return "Lưu";

    if (!widget.isNhaCungCap) {
      return widget.model.userRoles.contains(UserRole.KhachHang)
          ? "Đặt hàng"
          : widget.model.sellInWarehouse
              ? 'Hoàn thành'
              : (widget.model.orderState == OrderState.PreNewOrder
                  ? 'Tạo đơn'
                  : 'Lưu');
    } else {
      return "Tạo đơn mua";
    }
  }

  Widget generateButtons() {
    if (widget.isNhaCungCap) {
      switch (widget.model.orderState) {
        case OrderState.PreNewOrder:
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
                  if (widget.isNhaCungCap) {
                    if (widget.model.orderState == OrderState.PreNewOrder)
                      await widget.model.createOrder(context,
                          isNhaCungCap: widget.isNhaCungCap, type: "M");
                    else {
                      await widget.model.updateOrder(context,
                          status: "Đã giao hàng",
                          isNhaCungCap: widget.isNhaCungCap,
                          type: "M");
                    }
                  } else {
                    if (widget.model.orderState == OrderState.PreNewOrder) {
                      if (widget.model.sellInWarehouse) {
                        if (widget.model.isThuKho1) {
                          await widget.model.createOrder(
                            context,
                            status: "Đơn chờ",
                            isValidate: false,
                          );
                          widget.model.hoaDonMuaBanHiddenStatus!.status =
                              "Đơn chờ 1";
                          widget.model.hoaDonMuaBanHiddenStatus!.realName =
                              "Đơn chờ 1";
                          await widget.model.updateHoaDonMuaBanHiddenStatus();
                        }
                      } else {
                        await widget.model.createOrder(context);
                      }
                    } else {
                      await widget.model.updateOrder(context);
                    }
                  }
                },
                child: Text(
                  getTextButtonPrimary(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        case OrderState.NewOrder:
          return Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: hexToColor('#0072BC'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                // minimumSize: Size(double.infinity, 30),
              ),
              onPressed: () async {
                if (widget.isNhaCungCap) {
                  if (widget.model.orderState == OrderState.PreNewOrder)
                    await widget.model.createOrder(context,
                        isNhaCungCap: widget.isNhaCungCap, type: "M");
                  else {
                    await widget.model.updateOrder(context,
                        status: "Đã giao hàng",
                        isNhaCungCap: widget.isNhaCungCap,
                        type: "M");
                  }
                } else {
                  if (widget.model.orderState == OrderState.PreNewOrder)
                    await widget.model.createOrder(context);
                  else {
                    await widget.model.updateOrder(context);
                  }
                }
              },
              child: Text(
                "Đã nhận hàng",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        default:
          Text('');
          break;
      }
    }

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
            if (widget.isNhaCungCap) {
              if (widget.model.orderState == OrderState.PreNewOrder)
                await widget.model.createOrder(context,
                    isNhaCungCap: widget.isNhaCungCap, type: "M");
              else {
                await widget.model.updateOrder(context,
                    status: "Đã giao hàng",
                    isNhaCungCap: widget.isNhaCungCap,
                    type: "M");
              }
            } else {
              if (widget.model.orderState == OrderState.PreNewOrder) {
                if (widget.model.order!.status == "Đơn mẫu")
                  await widget.model
                      .updateOrder(context, status: "Chờ xác nhận");
                else if (widget.model.order!.status == "Đơn chờ")
                  await widget.model
                      .updateOrder(context, status: "Đã đặt hàng");
                else {
                  if (widget.model.sellInWarehouse) {
                    if (widget.model.isThuKho1) {
                      await widget.model.createOrder(
                        context,
                        status: "Đơn chờ",
                        isValidate: false,
                      );
                      widget.model.hoaDonMuaBanHiddenStatus!.status =
                          "Đơn chờ 1";
                      widget.model.hoaDonMuaBanHiddenStatus!.realName =
                          "Đơn chờ 1";
                      await widget.model.updateHoaDonMuaBanHiddenStatus();
                    } else {
                      FrappeAlert.errorAlert(
                          title: 'Không có quyền hạn',
                          context: context,
                          subtitle:
                              'Bạn cần có quyền thủ kho 1 để thực hiện tính năng này.');
                    }
                  } else {
                    if (widget.model.userRoles.contains(UserRole.KhachHang)) {
                      await widget.model
                          .createOrder(context, status: "Chờ xác nhận");
                    } else {
                      await widget.model.createOrder(context);
                    }
                  }
                }
              } else {
                await widget.model.updateOrder(context);
              }
            }

            if (widget.isDieuPhoi) await widget.model.updatePhanCong();

            widget.model.changeState();
          },
          child: Text(
            getTextButtonPrimary(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget getButtonDieuPhoi() {
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
            if (widget.isNhaCungCap) {
              if (widget.model.orderState == OrderState.PreNewOrder)
                await widget.model.createOrder(context,
                    isNhaCungCap: widget.isNhaCungCap, type: "M");
              else {
                await widget.model.updateOrder(context,
                    status: "Đã giao hàng",
                    isNhaCungCap: widget.isNhaCungCap,
                    type: "M");
              }
            } else {
              if (widget.model.orderState == OrderState.PreNewOrder)
                await widget.model.createOrder(context);
              else {
                await widget.model
                    .updateOrder(context, status: widget.model.order!.status);
              }
            }

            if (widget.isDieuPhoi) await widget.model.updatePhanCong();

            widget.model.changeState();
          },
          child: Text(
            getTextButtonPrimary(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

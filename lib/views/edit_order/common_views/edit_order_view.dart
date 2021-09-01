import 'package:flutter/material.dart';
import 'package:frappe_app/utils/dialog.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_not_sell_in_warehouse.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_sell_in_warehouse.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';

class EditOrderView extends StatefulWidget {
  final String name;
  final bool haveDelivery;
  final int isRated;
  final bool isCreateScreen;
  EditOrderView({
    Key? key,
    this.name = '',
    this.haveDelivery = false,
    this.isRated = 0,
    this.isCreateScreen = false,
  }) : super(key: key);

  @override
  _EditOrderViewState createState() => _EditOrderViewState();
}

class _EditOrderViewState extends State<EditOrderView>
    with TickerProviderStateMixin {
  Color getColorByStatus(String status) {
    switch (status) {
      case "Chờ xác nhận":
        return hexToColor("#FFEC44");
      case "Đã đặt hàng":
        return hexToColor("#0072BC");
      case "Đang giao hàng":
        return hexToColor("#FF0F00");
      case "Đã giao hàng":
        return hexToColor("#1BBD5C");
      case "Đã hủy":
        return hexToColor("#000000");
      case "Đơn chờ":
        return hexToColor("#FFEC44");
      default:
        return hexToColor("#000000");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
      onModelReady: (model) async {
        model.setName(widget.name);
        model.init();
        model.setHaveDelivery(widget.haveDelivery);
        model.setIsRated(widget.isRated);
        if (widget.isCreateScreen) {
          model.isCreateScreen = widget.isCreateScreen;
          // model.loadStoreData();
        }

        await model.initPreData();
        // this.initTab();
      },
      onModelClose: (model) {
        model.disposed();
        // _tabController.dispose();
        // _secondTabController.dispose();
        // _scrollController.dispose();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomizeAppBar(
          model.title,
          leftAction: () {
            if (widget.isCreateScreen) {
              model.isCreateScreen = widget.isCreateScreen;
              if (model.isSaved) {
                Navigator.pop(context);
              } else {
                if (model.sellInWarehouse) {
                  if (model.products.length > 0) {
                    ConfirmDialog.showConfirmDialog(context, onCancel: () {
                      Navigator.of(context, rootNavigator: true).pop(context);
                      Navigator.pop(context);
                    }, onConfirm: () async {
                      model.createOrder(
                        context,
                        status: 'Đơn chờ',
                        isValidateSingature: false,
                      );
                      Navigator.of(context, rootNavigator: true).pop(context);
                      Navigator.pop(context);
                    },
                        content:
                            "Bạn có muốn lưu lại đơn hiện tại làm đơn mẫu?");
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              }
            } else {
              Navigator.pop(context);
            }
          },
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Center(
                child: Text(
                  model.orderStatus,
                  style: TextStyle(
                    color: getColorByStatus(model.orderStatus),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        body: model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _buidMainView(model),
      ),
    );
  }

  Widget _buidMainView(EditOrderViewModel model) {
    if (model.sellInWarehouse) {
      return EditOrderSellInWareHouse();
    }

    return EditOrderSellNotInWareHouse();
  }
}

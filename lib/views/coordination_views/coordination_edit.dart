import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/list_product_location_view.dart';

class CoordinationEditView extends StatefulWidget {
  final String? name;
  CoordinationEditView({Key? key, this.name}) : super(key: key);

  @override
  _CoordinationEditViewState createState() => _CoordinationEditViewState();
}

class _CoordinationEditViewState extends State<CoordinationEditView> {
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
      builder: (context, model, child) => Scaffold(
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
        body: model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 16),
                child: Stack(
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
                                  EditOrderHeader(),
                                  ListProductLocationView(),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Visibility(
                                    child: Container(
                                      width: double.infinity,
                                      color: hexToColor('#F2F8FC'),
                                      height: 40,
                                      // onPressed: () {},
                                      child: GestureDetector(
                                        child: DottedBorder(
                                          color:
                                              Color.fromRGBO(0, 114, 188, 0.3),
                                          strokeWidth: 2,
                                          // borderType: BorderType.Circle,
                                          radius: Radius.circular(8),
                                          child: Center(
                                              child: Text(
                                            'Thêm địa chỉ',
                                            style: TextStyle(fontSize: 16),
                                          )),
                                        ),
                                        onTap: () {
                                          if (["", null, false, 0]
                                              .contains(model.customerValue)) {
                                            FrappeAlert.warnAlert(
                                                title: 'Thông báo',
                                                context: context,
                                                subtitle:
                                                    'Xin hãy chọn một khách hàng');
                                            return;
                                          }

                                          model.addAddress();
                                          model.changeState();
                                        },
                                      ),
                                    ),
                                    visible: !model.readOnlyView,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                    EditOrderBottom()
                  ],
                ),
              ),
      ),
    );
  }
}

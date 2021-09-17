import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_bottom.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_header.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/list_product_view.dart';

class MnvlEditView extends StatefulWidget {
  final String name;
  MnvlEditView({
    Key? key,
    this.name = '',
  }) : super(key: key);

  @override
  _MnvlEditViewState createState() => _MnvlEditViewState();
}

class _MnvlEditViewState extends State<MnvlEditView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
      onModelReady: (model) async {
        model.init();
        model.setName(widget.name);
        model.setIsNhaCungCap(true);
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
                                  EditOrderHeader(
                                    isNhaCungCap: true,
                                  ),
                                  Text('Thông tin đơn hàng',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ListProductView(
                                    isNhaCungCap: true,
                                  ),
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
                    EditOrderBottom(
                      isNhaCungCap: true,
                    )
                  ],
                ),
              ),
      ),
    );
    ;
  }
}

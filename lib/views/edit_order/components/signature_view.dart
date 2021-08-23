import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:signature/signature.dart';

class SignatureView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final String? address;

  SignatureView({Key? key, this.address}) : super(key: key);

  @override
  _SignatureViewState createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  @override
  Widget build(BuildContext context) {
    String attachImageCustomer;
    String attachImage;

    if (widget.address != null && widget.address!.length > 0) {
      var giaoViewSig =
          widget.model.getGiaoViecSignatureByAddress(widget.address!);
      attachImageCustomer =
          giaoViewSig != null ? giaoViewSig.attachSignatureCustomerImage : '';

      attachImage =
          giaoViewSig != null ? giaoViewSig.attachSignatureDeliverImage : '';
    } else {
      attachImageCustomer = widget.model.order!.attachSignatureCustomerImage;
      attachImage = widget.model.order!.attachSignatureSupplierImage;
    }

    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                'Khách hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  // color: hexToColor('#00478B'),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: hexToColor('#B3D5EB'),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Visibility(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            child: FrappeIcon(
                              FrappeIcons.refresh,
                              size: 16,
                            ),
                            onTap: () {
                              widget.model.clearSignatureCustomer();
                            },
                          ),
                        ),
                        visible: !widget.model.readOnlyView,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      widget.model.readOnlyView
                          ? Image.network(
                              '${widget.model.config!.baseUrl}${attachImageCustomer}')
                          : Signature(
                              controller:
                                  widget.model.signatureCustomerController,
                              backgroundColor: Colors.white,
                              height: 110,
                              width: MediaQuery.of(context).size.width - 30,
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                widget.address != null && widget.address!.length > 0
                    ? "Giao vận viên"
                    : "'Nhà cung cấp'",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  // color: hexToColor('#00478B'),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: hexToColor('#B3D5EB'),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Visibility(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            child: FrappeIcon(
                              FrappeIcons.refresh,
                              size: 16,
                            ),
                            onTap: () {
                              widget.model.clearSignatureSupplier();
                            },
                          ),
                        ),
                        visible: !widget.model.readOnlyView,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      widget.model.readOnlyView
                          ? Image.network(
                              '${widget.model.config!.baseUrl}${attachImage}')
                          : Signature(
                              controller:
                                  widget.model.signatureSupplierController,
                              backgroundColor: Colors.white,
                              height: 110,
                              width: MediaQuery.of(context).size.width - 30,
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 44,
              ),
              // _buildBottomButton(model),
            ],
          ),
        ),
      ),
    );
  }
}

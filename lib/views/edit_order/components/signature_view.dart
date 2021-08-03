import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:signature/signature.dart';

class SignatureView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  SignatureView({Key? key}) : super(key: key);

  @override
  _SignatureViewState createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  @override
  Widget build(BuildContext context) {
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
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          child: FrappeIcon(
                            FrappeIcons.refresh,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      // widget.model.order != null &&
                      //         widget.model.order!.attachSignatureImage != null
                      //     ? Image.network(
                      //         '${widget.model.config!.baseUrl}${widget.model.order!.attachSignatureImage}')
                      //     :

                      Signature(
                        controller: widget.model.signatureCustomerController,
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
                'Nhà cung cấp',
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
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          child: FrappeIcon(
                            FrappeIcons.refresh,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Signature(
                        controller: widget.model.signatureSupplierController,
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

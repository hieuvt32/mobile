import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/create_bao_nham_lan_request.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/widgets/frappe_bottom_sheet.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

class ReportMistakeView extends StatefulWidget {
  @override
  _ReportMistakeViewState createState() => _ReportMistakeViewState();
}

class _ReportMistakeViewState extends State<ReportMistakeView> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;

  Future<void> createDonBaoLoi(
      {required String reason, required String content}) async {
    setState(() {
      isLoading = true;
    });

    String customerCode = Config().customerCode;
    CreateBaoNhamLanRequest requestPayload = CreateBaoNhamLanRequest(
        content: content, reason: reason, customerCode: customerCode);

    locator<Api>().createBaoNhamLan(requestPayload).then((value) {
      FrappeAlert.successAlert(
          title: "Báo cáo nhầm lẫn thành công", context: context);

      _formKey.currentState!.reset();

      setState(() {
        isLoading = false;
      });
    }).catchError((er) {
      FrappeAlert.errorAlert(
          title: "Có lỗi xảy ra, vui lòng thử lại sau", context: context);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Báo nhầm lẫn"),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              reverse: true, // add this line in scroll view
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Tên khách hàng:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Phạm Văn Mạnh",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Mã khách hàng:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "KH - 01",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Loại báo nhầm lẫn:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: FormBuilderDropdown(
                                name: 'reason',
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent)),
                                ),
                                // initialValue: 'Male',
                                allowClear: true,
                                hint: Text(
                                  'Chọn lý do',
                                  style: TextStyle(fontSize: 14),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: "Hãy chọn lý do")
                                ]),
                                items: ["Nhầm lẫn chi tiêu", "Nhầm lẫn bình"]
                                    .map((reason) => DropdownMenuItem(
                                          value: reason,
                                          child: Text('$reason'),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FormBuilderTextField(
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: "Hãy nhập nội dung")
                          ]),
                          name: "content",
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: new InputDecoration(
                            hintText: "Nhập nội dung",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: FrappeFlatButton(
                    minWidth: 328,
                    height: 48,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String reason = _formKey.currentState!.value['reason'];
                        String content =
                            _formKey.currentState!.value['content'];
                        createDonBaoLoi(reason: reason, content: content);
                      } else {}
                    },
                    buttonType: ButtonType.primary,
                    title: "Báo cáo nhầm lẫn"),
              ),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/get_list_quy_chuan_thong_tin_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:intl/intl.dart';

class ProductionReportView extends StatefulWidget {
  const ProductionReportView({Key? key}) : super(key: key);

  @override
  _ProductionReportViewState createState() => _ProductionReportViewState();
}

class _ProductionReportViewState extends State<ProductionReportView> {
  @override
  void initState() {
    super.initState();
    _response = null;
    locator<Api>().getReportSanXuat().then((value) {
      setState(() {
        _response = value;
      });
    });
  }

  GetListQuyChuanThongTinResponse? _response;
  @override
  Widget build(BuildContext context) {
    int total = _response != null
        ? _response!.reportQuyChuanThongTins!
            .fold(0, (sum, item) => sum + item.total)
        : 0;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            // Get.back();
            Navigator.pop(context);
          },
        ),
        actions: [],
        title: Text(
          'Báo cáo sản xuất ($formattedDate)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // body: AnswerButton(),
      body: _response != null
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 16, 60, 0),
                      child: Row(
                        children: [
                          Text(
                            'Tổng số sản phẩm',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              // color: hexToColor('#00478B'),
                            ),
                          ),
                          Text(
                            total.toString(),
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: hexToColor('#FF0F00')),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    //   child: const Divider(
                    //     color: Color.fromRGBO(0, 0, 0, 0.3),
                    //     height: 1,
                    //     thickness: 1,
                    //     indent: 1,
                    //     endIndent: 1,
                    //   ),
                    // ),
                    SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 6, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            'Danh sách sản phẩm',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              // color: hexToColor('#00478B'),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(28.0, 0, 28, 12),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      width: 0.5)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 24, 8, 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                          'Tên sản phẩm: ${_response!.reportQuyChuanThongTins![index].product}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          'Loại vật tư: ${_response!.reportQuyChuanThongTins![index].material}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          'Số lượng: ${_response!.reportQuyChuanThongTins![index].total}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                    SizedBox(
                                      width: 55,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          'Kg:          ${_response!.reportQuyChuanThongTins![index].kg}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            // fontWeight: FontWeight.w700,
                                            // color: hexToColor('#FF0F00'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          'Đơn vị tính:  Bình',
                                          style: TextStyle(
                                            fontSize: 14,
                                            // fontWeight: FontWeight.w700,
                                            // color: hexToColor('#FF0F00'),
                                          ),
                                        )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _response!.reportQuyChuanThongTins!.length,
                      ),
                    )
                  ],
                ),
              ), /* add child content here */
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      backgroundColor: Colors.white,
    );
  }
}

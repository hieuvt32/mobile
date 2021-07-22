import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/get_quy_chuan_thong_tin_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  GetQuyChuanThongTinResponse? _response;
  int? _status = 1;
  @override
  Widget build(BuildContext context) {
    var event = (context) {
      setState(() {
        _status = context;
      });
    };
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
            'Tra cứu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: TextField(
//    ...,other fields
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(left: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    labelText: 'Mã vạch, Mã chế tạo',
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(20, 20, 43, 0.5)),
                  ),
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  onSubmitted: (text) {
                    locator<Api>().getTraCuuSanXuat(text).then((value) {
                      setState(() {
                        _response = value;
                        if (_response != null &&
                            _response!.quyChuanThongTin != null) {
                          setState(() {
                            switch (_response!.quyChuanThongTin!.status) {
                              case "Bình thường":
                                _status = 0;
                                break;
                              default:
                                _status = 2;
                            }
                          });
                        }
                      });
                    });
                  },
                  // controller: controller,
                ),
              ),
              const Divider(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                height: 1,
                thickness: 1,
                indent: 1,
                endIndent: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 28, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'Chi tiết sản phẩm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: hexToColor('#00478B'),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Tên sản phẩm',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            (_response != null &&
                                    _response!.quyChuanThongTin != null
                                ? _response!.quyChuanThongTin!.productContain
                                : "Không có thông tin"),
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
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
                          flex: 3,
                          child: Text(
                            'Loại vật tư',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            (_response != null &&
                                    _response!.quyChuanThongTin != null
                                ? _response!.quyChuanThongTin!.materialType
                                : "Không có thông tin"),
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
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
                          flex: 3,
                          child: Text(
                            'Mã chế tạo',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            _response != null &&
                                    _response!.quyChuanThongTin != null
                                ? _response!.quyChuanThongTin!.serial
                                : "Không có thông tin",
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trạng thái',
                          style: TextStyle(color: hexToColor('#14142B'))
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 48,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(0, 0, 0, 0.5))),
                            padding: EdgeInsets.all(12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem<dynamic>(
                                    child: Text('Bình thường'),
                                    value: 0,
                                  ),
                                  DropdownMenuItem<dynamic>(
                                    child: Text('Hỏng trả về'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem<dynamic>(
                                    child: Text('Hỏng lưu kho'),
                                    value: 2,
                                  )
                                ],
                                value: _status,
                                onChanged: event,

                                // keyboardType: this.keyboardType,
                                // decoration: InputDecoration(
                                //   enabledBorder:
                                //       const OutlineInputBorder(
                                //     borderRadius: BorderRadius.all(
                                //         Radius.circular(0.0)),
                                //     borderSide: const BorderSide(
                                //       color: Colors.grey,
                                //     ),
                                //   ),
                                // ),

                                style: TextStyle(
                                  fontSize: 13.0,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                // controller: controller,
                                // height: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
                child: Text(
                  'Cập nhật',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_response != null &&
                      _response!.quyChuanThongTin != null) {
                    locator<Api>()
                        .updateTrangThaiQuyChuan(
                            _response!.quyChuanThongTin!.name, _status!)
                        .then((value) {
                      FrappeAlert.successAlert(
                        title: "Cập nhật thành công",
                        subtitle: "Quy chuẩn thông tin đã được cập nhật.",
                        context: context,
                      );
                    });
                  } else {
                    FrappeAlert.errorAlert(
                      title: "Cập nhật không thành công",
                      subtitle:
                          "Cần tìm kiếm thông tin quy chuẩn, trước khi cập nhật.",
                      context: context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: hexToColor('#FF0F00'),
                    // side: BorderSide(
                    //   width: 1.0,
                    // ),
                    minimumSize: Size(120, 40),
                    padding: EdgeInsets.fromLTRB(118, 13, 118, 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: hexToColor('#FF0F00')))),
              ),
              SizedBox(
                height: 164,
              )
            ],
          ),
        ), /* add child content here */
      ),
      backgroundColor: Colors.white,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/get_quy_chuan_thong_tin_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';

class BarcodeScannerView extends StatefulWidget {
  final String barcode;
  const BarcodeScannerView({
    Key? key,
    required this.barcode,
  }) : super(key: key);

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  late GetQuyChuanThongTinResponse _response;
  @override
  void initState() {
    super.initState();
    _response = GetQuyChuanThongTinResponse();
    onLoad();
  }

  Future<void> onLoad() async {
    var response =
        await locator<Api>().getQuyChuanThongTinTaiSanBySerial(widget.barcode);
    if (response.quyChuanThongTin != null &&
        response.quyChuanThongTin?.status == 'Bình thường') {
      await locator<Api>().updateLichSuSanXuat(
          widget.barcode,
          response.quyChuanThongTin!.company,
          response.quyChuanThongTin!.productContain,
          response.quyChuanThongTin!.materialType,
          response.quyChuanThongTin!.serial,
          response.quyChuanThongTin!.status,
          response.quyChuanThongTin!.countByKG,
          response.quyChuanThongTin!.kg);
    }
    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            'Quét mã vạch',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 44, 28, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          (_response.quyChuanThongTin != null &&
                                  _response.quyChuanThongTin?.status ==
                                      'Bình thường')
                              ? 'Để camera vào gần mã vạch của sản phẩm để quét mã'
                              : 'Mã vạch của sản phẩm được quét bị lỗi !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: (_response.quyChuanThongTin != null &&
                                      _response.quyChuanThongTin?.status ==
                                          'Bình thường')
                                  ? hexToColor('#00478B')
                                  : hexToColor('#FF0F00')),
                        ),
                        SizedBox(
                          height: 82,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: IconTheme(
                            data: IconThemeData(
                              size: 56.0,
                            ),
                            child: Container(
                              child: FrappeIcon(FrappeIcons.barcode),
                              height: 150,
                              width: 120,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 113,
                        )

                        // ElevatedButton(
                        //     onPressed: () => scanBarcodeNormal(),
                        //     child: Text(
                        //         'Để camera vào gần mã vạch của sản phẩm để quét mã')),
                        // ElevatedButton(
                        //     onPressed: () => scanQR(),
                        //     child: Text('Start QR scan')),
                        // ElevatedButton(
                        //     onPressed: () => startBarcodeScanStream(),
                        //     child: Text('Start barcode scan stream')),
                        // Text('Scan result : $_scanBarcode\n',
                        //     style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 36,
                ),
                Visibility(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_response.quyChuanThongTin != null) {
                            await locator<Api>().updateLichSuSanXuat(
                                _response.quyChuanThongTin!.barcode,
                                _response.quyChuanThongTin!.company,
                                _response.quyChuanThongTin!.productContain,
                                _response.quyChuanThongTin!.materialType,
                                _response.quyChuanThongTin!.serial,
                                _response.quyChuanThongTin!.status,
                                _response.quyChuanThongTin!.countByKG,
                                _response.quyChuanThongTin!.kg);
                          }
                        },
                        child: Text(
                          'Xác nhận nạp',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 15, 0, 1),
                          // side: BorderSide(
                          //   width: 1.0,
                          // ),
                          minimumSize: Size(160, 52),
                          padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Hủy bỏ',
                          style: TextStyle(
                              color: hexToColor('#00478B'),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 255, 255, 1),
                          side: BorderSide(
                            width: 1.0,
                          ),
                          minimumSize: Size(160, 52),
                          padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: hexToColor('#00478B'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  visible: !(_response.quyChuanThongTin != null &&
                      _response.quyChuanThongTin?.status == 'Bình thường'),
                )
              ],
            ),
          ),
        ), /* add child content here */
      ),
      backgroundColor: Colors.white,
    );
  }
}

import 'dart:io';

import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/get_quy_chuan_thong_tin_response.dart';
import 'package:frappe_app/model/lich_su_san_xuat.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BarcodeScannerView extends StatefulWidget {
  // final String barcode;
  // final Function(String result) resultCallback;
  const BarcodeScannerView({
    Key? key,
    // required this.barcode,
    // required this.resultCallback,
  }) : super(key: key);

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  late GetQuyChuanThongTinResponse? _response;

  // late ScannerController _scannerController;
  // late CreatorController? _creatorController;

  late String barcode = "";
  late bool isLoading = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  late QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    // _creatorController = CreatorController();
    _response = GetQuyChuanThongTinResponse();
    // _scannerController = ScannerController(scannerResult: (result) {
    //   resultCallback(result);
    // }, scannerViewCreated: () {
    //   TargetPlatform platform = Theme.of(context).platform;
    //   if (TargetPlatform.iOS == platform) {
    //     Future.delayed(Duration(seconds: 2), () {
    //       _scannerController.startCamera();
    //       _scannerController.startCameraPreview();
    //     });
    //   } else {
    //     _scannerController.startCamera();
    //     _scannerController.startCameraPreview();
    //   }
    // });
    // onLoad();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    // _creatorController = null;
    // _scannerController.stopCameraPreview();
    // _scannerController.stopCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        barcode = result.code;
        await onLoad();
      });
    });
  }

  Future<void> onLoad() async {
    if (!["", null, false, 0].contains(barcode)) {
      var response = await locator<Api>().getTraCuuSanXuat(barcode);
      if (response.quyChuanThongTin != null &&
          response.quyChuanThongTin?.status == 'Bình thường') {
        await locator<Api>().updateLichSuSanXuat(
            barcode,
            response.quyChuanThongTin!.company,
            response.quyChuanThongTin!.productContain,
            response.quyChuanThongTin!.materialType,
            response.quyChuanThongTin!.serial,
            response.quyChuanThongTin!.status,
            response.quyChuanThongTin!.countByKG,
            response.quyChuanThongTin!.kg);
      }

      _response = response;
    }
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
      body: !isLoading
          ?
          // ? Container(
          //     width: double.infinity,
          //     height: double.infinity,
          //     child: SingleChildScrollView(
          //         child:
          //             //  Padding(
          //             //   padding: const EdgeInsets.fromLTRB(28, 44, 28, 0),
          //             //   child: ,
          //             // ),
          //             ), /* add child content here */
          //   )
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 28, 24, 28),
                  child: Text(
                    ["", null, false, 0].contains(barcode)
                        ? "Để camera vào gần mã vạch của sản phẩm để quét mã"
                        : (_response!.quyChuanThongTin != null &&
                                _response!.quyChuanThongTin?.status ==
                                    'Bình thường')
                            ? 'Quét mã vạch thành công'
                            : 'Mã vạch của sản phẩm được quét bị lỗi !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ["", null, false, 0].contains(barcode)
                            ? hexToColor('#00478B')
                            : (_response!.quyChuanThongTin != null &&
                                    _response!.quyChuanThongTin?.status ==
                                        'Bình thường')
                                ? hexToColor('#1BBD5C')
                                : hexToColor('#FF0F00')),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 28, 24, 28),
                    child:

                        // PlatformAiBarcodeCreatorWidget(
                        //   creatorController: _creatorController!,
                        //   initialValue: "11111111111111",
                        // )

                        Container(
                      // height: 45,
                      child: ["", null, false, 0].contains(barcode)
                          ? QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                            )
                          // PlatformAiBarcodeScannerWidget(
                          //     platformScannerController: _scannerController,
                          //   )
                          : IconTheme(
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
                  ),
                  flex: 3,
                ),
                // Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(),
                //     ),
                //     alignment: Alignment.center,
                //     child:
                // Padding(
                //     padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
                //     child:

                //  Flex(
                //   direction: Axis.vertical,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Text(
                //       (_response!.quyChuanThongTin != null &&
                //               _response!.quyChuanThongTin?.status ==
                //                   'Bình thường')
                //           ? 'Để camera vào gần mã vạch của sản phẩm để quét mã'
                //           : 'Mã vạch của sản phẩm được quét bị lỗi !',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.w700,
                //           color:
                //               (_response!.quyChuanThongTin != null &&
                //                       _response!.quyChuanThongTin
                //                               ?.status ==
                //                           'Bình thường')
                //                   ? hexToColor('#00478B')
                //                   : hexToColor('#FF0F00')),
                //     ),
                //     SizedBox(
                //       height: 82,
                //     ),
                //     GestureDetector(
                //       onTap: () {},
                //       child: IconTheme(
                //         data: IconThemeData(
                //           size: 56.0,
                //         ),
                //         child: Container(
                //           child: FrappeIcon(FrappeIcons.barcode),
                //           height: 150,
                //           width: 120,
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 113,
                //     )

                //     // ElevatedButton(
                //     //     onPressed: () => scanBarcodeNormal(),
                //     //     child: Text(
                //     //         'Để camera vào gần mã vạch của sản phẩm để quét mã')),
                //     // ElevatedButton(
                //     //     onPressed: () => scanQR(),
                //     //     child: Text('Start QR scan')),
                //     // ElevatedButton(
                //     //     onPressed: () => startBarcodeScanStream(),
                //     //     child: Text('Start barcode scan stream')),
                //     // Text('Scan result : $_scanBarcode\n',
                //     //     style: TextStyle(fontSize: 20))
                //   ],
                // ),
                // ),
                // ),
                SizedBox(
                  height: 36,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _response = GetQuyChuanThongTinResponse();
                                  Navigator.pop(context);
                                });
                                // if (!["", null, false, 0].contains(barcode)) {
                                //   if (_response != null &&
                                //       _response!.quyChuanThongTin != null) {
                                //     await locator<Api>().updateLichSuSanXuat(
                                //         barcode,
                                //         _response!.quyChuanThongTin!.company,
                                //         _response!
                                //             .quyChuanThongTin!.productContain,
                                //         _response!
                                //             .quyChuanThongTin!.materialType,
                                //         _response!.quyChuanThongTin!.serial,
                                //         _response!.quyChuanThongTin!.status,
                                //         _response!.quyChuanThongTin!.countByKG,
                                //         _response!.quyChuanThongTin!.kg);

                                //     FrappeAlert.successAlert(
                                //       title: "Cập nhật thành công",
                                //       subtitle:
                                //           "Cập nhật lịch sử sản xuất thành công",
                                //       context: context,
                                //     );
                                //   }
                                // }
                              },
                              child: Text(
                                'Kết thúc',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(255, 15, 0, 1),
                                // side: BorderSide(
                                //   width: 1.0,
                                // ),
                                minimumSize: Size(120, 32),
                                padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // if (_response != null &&
                                //     _response!.quyChuanThongTin != null) {
                                //   await locator<Api>().updateLichSuSanXuat(
                                //       barcode,
                                //       _response!.quyChuanThongTin!.company,
                                //       _response!
                                //           .quyChuanThongTin!.productContain,
                                //       _response!.quyChuanThongTin!.materialType,
                                //       _response!.quyChuanThongTin!.serial,
                                //       "Hủy",
                                //       _response!.quyChuanThongTin!.countByKG,
                                //       _response!.quyChuanThongTin!.kg);

                                //   FrappeAlert.successAlert(
                                //     title: "Cập nhật thành công",
                                //     subtitle:
                                //         "Cập nhật lịch sử sản xuất thành công",
                                //     context: context,
                                //   );
                                // }

                                setState(() {
                                  barcode = "";
                                  _response = GetQuyChuanThongTinResponse();
                                });
                              },
                              child: Text(
                                'Tiếp tục',
                                style: TextStyle(
                                    color: hexToColor('#FFFFFF'),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: hexToColor("#0072BC"),
                                side: BorderSide(
                                  width: 0.0,
                                ),
                                minimumSize: Size(120, 32),
                                padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                    color: hexToColor('#00478B'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      visible: !(_response!.quyChuanThongTin != null),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      backgroundColor: Colors.white,
    );
  }
}

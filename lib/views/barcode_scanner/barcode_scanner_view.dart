import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({Key? key}) : super(key: key);

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  String _scanBarcode = 'Unknown';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
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
            padding: const EdgeInsets.fromLTRB(28, 92, 28, 156),
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
                          'Để camera vào gần mã vạch của sản phẩm để quét mã',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: hexToColor('#00478B')),
                        ),
                        SizedBox(
                          height: 82,
                        ),
                        GestureDetector(
                          onTap: () {
                            scanBarcodeNormal();
                          },
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
                  height: 64,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => scanBarcodeNormal(),
                      child: Text('Xác nhận nạp'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 15, 0, 1),
                          side: BorderSide(
                            width: 1.0,
                          ),
                          minimumSize: Size(120, 40),
                          // padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.red))),
                    ),
                    ElevatedButton(
                      onPressed: () => scanBarcodeNormal(),
                      child: Text(
                        'Hủy bỏ',
                        style: TextStyle(color: hexToColor('#00478B')),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(255, 255, 255, 1),
                          side: BorderSide(
                            width: 1.0,
                          ),
                          minimumSize: Size(120, 40),
                          // padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: hexToColor('#00478B')))),
                    )
                  ],
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

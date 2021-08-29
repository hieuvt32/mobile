import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';

class TransportationBottom extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  TransportationBottom({Key? key}) : super(key: key);

  @override
  _TransportationBottomState createState() => _TransportationBottomState();
}

class _TransportationBottomState extends State<TransportationBottom> {
  Future onUpdateUserLocation() async {
    await requestLocationPermission();

    await BackgroundLocation.startLocationService(distanceFilter: 200);

    locator<Api>().updateCarLocation(
        order: widget.model.order!.name,
        longitude: -122.084,
        latitude: 37.4219983);

    BackgroundLocation.getLocationUpdates((location) {
      locator<Api>().updateCarLocation(
          order: widget.model.order!.name,
          longitude: location.longitude!,
          latitude: location.latitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Visibility(
        visible: widget.model.order!.status == "Đã đặt hàng",
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: hexToColor('#FF0F00'),
                // side: BorderSide(
                //   width: 1.0,
                // ),
                // minimumSize: Size(120, 32),
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  // side: BorderSide(
                  //   color: hexToColor('#0072BC'),
                  // ),
                ),
              ),
              onPressed: () async {
                onUpdateUserLocation();
                await widget.model
                    .updateOrder(context, status: "Đang giao hàng");
              },
              child: Text(
                'Giao hàng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

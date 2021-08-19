import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingOrderView extends StatefulWidget {
  @override
  State<TrackingOrderView> createState() => MapSampleState();
}

class MapSampleState extends State<TrackingOrderView> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  Set<Marker> _makers = new Set();

  @override
  void initState() {
    final String query = "Ngõ 59, Láng Hạ, Đống Đa, Hà Nội";
    Geocoder.local.findAddressesFromQuery(query).then((value) {
      Coordinates first = value.first.coordinates;

      Set<Marker> list = _makers;
      list.add(Marker(
          markerId: MarkerId(
            'Lang Ha',
          ),
          position: LatLng(first.latitude, first.longitude)));

      CameraPosition _kNew = CameraPosition(
        target: LatLng(first.latitude, first.longitude),
        zoom: 14.4746,
      );

      setState(() {
        _makers = list;
        _kGooglePlex = _kNew;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_makers);

    return new Scaffold(
      body: GoogleMap(
        markers: _makers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To !'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

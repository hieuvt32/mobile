import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingOrderView extends StatefulWidget {
  @override
  MapSampleState createState() => MapSampleState();
}

class MapSampleState extends State<TrackingOrderView> {
  late GoogleMapController _controller;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.0084906, 105.81720639999999),
    zoom: 14.4746,
  );

  Location _location = Location();

  Set<Marker> _makers = new Set();

  @override
  void initState() {
    final String query = "Ngõ 59, Láng Hạ, Đống Đa, Hà Nội";
    Geocoder.local.findAddressesFromQuery(query).then((value) {
      Coordinates first = value.first.coordinates;
      _location.getLocation().then((value) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude ?? 0, value.longitude ?? 0),
            zoom: 14)));
      });
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

  void onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    _location.onLocationChanged.listen((l) {
      _cntlr.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  l.latitude ?? 21.0084906, l.longitude ?? 105.81720639999999),
              zoom: 15),
        ),
      );
    });
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
        onMapCreated: onMapCreated,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To !'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }
}

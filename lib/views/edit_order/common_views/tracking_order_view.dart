import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingOrderView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();

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

  Set<Marker> _markers = Set<Marker>();

  bool _loading = false;

  Future onSetupMarkers() async {
    setState(() {
      _loading = true;
    });

    Iterable<Future<List<Address>>> listAsync =
        widget.model.editAddresses.map((e) => e.diaChi).toSet().map((element) {
      return Geocoder.local.findAddressesFromQuery(element);
    });

    List<List<Address>> addressResponse = await Future.wait(listAsync);

    Set<Marker> markers = new Set();
    markers = addressResponse.asMap().entries.map((entry) {
      String markerId = widget.model.editAddresses[entry.key].name ??
          entry.value.first.addressLine;
      Coordinates coordinates = entry.value.first.coordinates;
      LatLng lat = LatLng(coordinates.latitude, coordinates.longitude);
      return Marker(
        markerId: MarkerId(markerId),
        position: lat,
      );
    }).toSet();

    setState(() {
      _markers = markers;
      _loading = false;
    });
  }

  @override
  void initState() {
    onSetupMarkers();
    super.initState();
  }

  void onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    // _location.onLocationChanged.listen((l) {
    //   _cntlr.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //           target: LatLng(21.0084906, 105.81720639999999), zoom: 15),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              markers: _markers,
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

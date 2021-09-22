import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/giao_van_location_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingOrderView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();

  @override
  MapSampleState createState() => MapSampleState();
}

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class MapSampleState extends State<TrackingOrderView> {
  GoogleMapController? _controller;

  String googleAPIKey = "AIzaSyBt24cVH1Bw-lMnQMXX0ODuamU1nkcUH18";

  BitmapDescriptor? sourceIcon;

  LocationData? currentLocation;

  Location? location;

  Set<Marker> _markers = Set<Marker>();

  bool _loading = false;

  CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(21.0084906, 105.81720639999999),
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING);

  Future onGetCoordinates(String address) async {
    List<Address> listAddress =
        await Geocoder.local.findAddressesFromQuery(address);
    return listAddress.first;
  }

  Future onSetupMarkers() async {
    setState(() {
      _loading = true;
    });

    List<Address> addressResponse = [];

    List<String> queries =
        widget.model.editAddresses.map((e) => e.diaChi).toSet().toList();

    for (int i = 0; i < queries.length; i++) {
      try {
        Address address = await onGetCoordinates(queries[i]);
        addressResponse.add(address);
      } catch (err) {}
    }

    Set<Marker> markers = new Set();
    addressResponse.asMap().entries.forEach((entry) {
      String markerId = queries[entry.key];

      Coordinates coordinates = entry.value.coordinates;
      LatLng lat = LatLng(coordinates.latitude, coordinates.longitude);

      markers.add(Marker(
        markerId: MarkerId(markerId),
        position: lat,
      ));
    });

    setState(() {
      _markers = markers;
      _loading = false;
    });
  }

  void setSourceIcon() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/driving_pin.png');
  }

  Future<void> onGetOrderLocation() async {
    try {
      OrderLocationResponse orderLocationResponse =
          await locator<Api>().getLocationByOrder(widget.model.order!.name);

      List<OrderLocation> listLocation = orderLocationResponse.listLocations;

      OrderLocation orderLocation =
          listLocation.firstWhere((element) => element.address == "Xe");

      List<Marker> listMarker = _markers.toList();
      int deliverIndex =
          listMarker.indexWhere((element) => element.markerId.value == "Xe");

      LatLng lat = LatLng(double.parse(orderLocation.latitude),
          double.parse(orderLocation.longitude));

      Marker newMarker =
          Marker(markerId: MarkerId("Xe"), position: lat, icon: sourceIcon!);
      if (deliverIndex != -1) {
        listMarker[deliverIndex] = newMarker;
      } else {
        listMarker.add(newMarker);
      }

      CameraPosition newCameraPosition = CameraPosition(
          target: lat,
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);

      if (_controller != null) {
        _controller!
            .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
      }

      setState(() {
        _markers = listMarker.toSet();
      });
    } catch (err) {
      print(err);
    }
  }

  Timer? timer;

  @override
  void initState() {
    onSetupMarkers();
    setSourceIcon();

    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      onGetOrderLocation();
    });

    location = new Location();

    location!.onLocationChanged.listen((event) {
      currentLocation = event;
    });

    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  void onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;

    onGetOrderLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: GoogleMap(
                  buildingsEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                  rotateGesturesEnabled: false,
                  markers: _markers,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: onMapCreated,
                ),
              )
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: Text('To !'),
        //   icon: Icon(Icons.directions_boat),
        // ),
        );
  }
}

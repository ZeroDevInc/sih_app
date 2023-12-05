//'AIzaSyCAYnuFO2kwBTN2qpa22yV51fglehTdnP8'
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

PageController polymapPageController = PageController();
const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(30.7333, 76.7794),
  zoom: 14.4746,
);
List<LatLng> polyLineCoordinates = [];
BitmapDescriptor? greenIcon;
BitmapDescriptor? redIcon;

class PolyMap extends StatefulWidget {
  final LatLng sourceLocation;

  final LatLng destinationLocation;

  const PolyMap(
      {super.key,
      required this.sourceLocation,
      required this.destinationLocation});

  @override
  State<PolyMap> createState() => _PolyMapState();
}

class _PolyMapState extends State<PolyMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Future<void> _fitBounds() async {
    GoogleMapController controller = await _controller.future;
    LatLngBounds bounds = LatLngBounds(
      southwest: polyLineCoordinates.reduce(
        (value, element) => LatLng(
          value.latitude < element.latitude ? value.latitude : element.latitude,
          value.longitude < element.longitude
              ? value.longitude
              : element.longitude,
        ),
      ),
      northeast: polyLineCoordinates.reduce(
        (value, element) => LatLng(
          value.latitude > element.latitude ? value.latitude : element.latitude,
          value.longitude > element.longitude
              ? value.longitude
              : element.longitude,
        ),
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyD3OLpdS16LeC0faQh05X5TzMfZDyeAHcU',
        PointLatLng(
            widget.sourceLocation.latitude, widget.sourceLocation.longitude),
        PointLatLng(widget.destinationLocation.latitude,
            widget.destinationLocation.longitude));

    if (result.points.isNotEmpty) {
      polyLineCoordinates = [];
      print(result);
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
    await _fitBounds();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getPolyPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height - 350,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                    polylineId: PolylineId("route"),
                    points: polyLineCoordinates,
                    color: Color(0xFF4F68DF),
                    width: 6)
              },
              markers: {
                Marker(
                  markerId: MarkerId("source"),
                  position: widget.sourceLocation,
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: widget.destinationLocation,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

LatLngBounds _getBounds(Set<Polyline> polylines) {
  var minLat, maxLat, minLng, maxLng;

  for (Polyline polyline in polylines) {
    for (LatLng point in polyline.points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }
  }

  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}

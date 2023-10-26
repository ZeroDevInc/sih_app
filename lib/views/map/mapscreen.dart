import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sih_app/helpers/navigator_helper.dart';
import 'package:sih_app/views/booking/bookscreen.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> locs;

  const MapScreen({super.key, required this.locs});
  @override
  _MapScreenState createState() => _MapScreenState();
}

Marker? selectedMarker;
MarkerId? selectedPoint;
InfoWindow customInfoWindow = InfoWindow(
  title: 'Marker Title', // Replace with your title data
  snippet: 'Marker Snippet',
  onTap: () {}, // Replace with your snippet data
);

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  // List<Map<String, dynamic>> locations
  // = [
  //   {
  //     "name": "Chaitanya Parking",
  //     "my_id": "ps1",
  //     "coordinates": [30.7649, 76.7868],
  //   },

  //   {
  //     "name": "Shreyansh Parking",
  //     "my_id": "ps3",
  //     "coordinates": [30.75, 76.78],
  //   },
  //   {
  //     "name": "New Parking3",
  //     "my_id": "ps6",
  //     "coordinates": [30.765145, 76.78994]
  //   }
  //   // Add more locations here
  // ];

  // Define a set to store the markers.
  Set<Marker> _markers = Set<Marker>();

  // Function to execute when a marker is tapped.
  void _onMarkerTapped({required MarkerId markerId, required Marker marker}) {
    // Implement your logic here.
    print('Marker tapped: $markerId');
    setState(() {
      selectedPoint = markerId;
      selectedMarker = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    // Convert the JSON data to markers
    for (var location in widget.locs) {
      String name = location['name'];
      String myId = location['my_id'];
      List<double> coordinates = location['coordinates'].cast<double>();
      LatLng latLng = LatLng(coordinates[0], coordinates[1]);
      Marker marker = Marker(markerId: MarkerId("0"));
      marker = Marker(
        markerId: MarkerId(myId),
        position: latLng,
        infoWindow: InfoWindow(
          title: name,
        ),
        onTap: () => _onMarkerTapped(
          markerId: MarkerId(myId),
          marker: marker, // Pass the marker object here
        ),
      );

      _markers.add(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  30.7649, 76.7868), // Set your initial map center coordinates.
              zoom: 12.0, // Set the initial zoom level.
            ),
            markers: _markers,
            onTap: (LatLng latLng) {
              // You can add markers when the map is tapped.
              final MarkerId markerId =
                  MarkerId('marker${_markers.length + 1}');
              // final Marker marker = Marker(
              //   markerId: markerId,
              //   position: latLng,
              //   infoWindow: customInfoWindow,
              //   onTap: () => _onMarkerTapped(markerId),
              // );

              // setState(() {
              //   _markers.add(marker);
              // });
            },
          ),
          Visibility(
            visible: selectedPoint != null,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          NavigationHelper.navigateToSecondRoute(
                              context, BookingScreen(marker: selectedMarker!));
                        },
                        child: Text("Book Now")),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

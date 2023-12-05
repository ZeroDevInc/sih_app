import 'dart:convert';
import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sih_app/api/api.dart';
import 'package:sih_app/helpers/navigator_helper.dart';
import 'package:sih_app/models/parkings.dart';
import 'package:sih_app/models/test.dart';
import 'package:sih_app/views/booking/bookscreen.dart';
import 'package:sih_app/views/login/pages/login_page.dart';
import 'package:time_machine/time_machine.dart';

import '../../main.dart';

PageController? bottompagecontroller = PageController(initialPage: 0);
List<Map<String, dynamic>> locs = [];
late List<Parking> mapslist = [];
Parking? selectedParking;
int selectedindex = -1;
TimeOfDay? selectedTime = TimeOfDay.now();
TextEditingController timeTextController = TextEditingController();
TextEditingController vehicleNumberController = TextEditingController();
Duration selectedDuration = Duration(hours: 1);

calculateEndTime() {}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
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

  // Define a set to store the markers.
  Set<Marker> _markers = Set<Marker>();

  // Function to execute when a marker is tapped.
  void _onMarkerTapped(
      {required MarkerId markerId,
      required Marker marker,
      required Parking parking}) {
    // Implement your logic here.
    print('Marker tapped: $markerId');
    setState(() {
      selectedParking = parking;
      selectedPoint = markerId;
      selectedMarker = marker;
    });
  }

  Parking? searchParking(parking_id) {
    Parking? parking =
        mapslist.firstWhere((element) => element.email == parking_id);
    if (parking != null) {
      return parking;
    } else {
      return null;
    }
  }

  getParkings(BuildContext context) async {
    final String locations = await API().getAllParkings();
    print(locations);
    List<dynamic> jsonList = jsonDecode(locations);

    mapslist = jsonList.map((e) => Parking.fromMap(e)).toList();

    mapslist.forEach((element) {
      Marker marker = Marker(markerId: MarkerId("0"));
      marker = Marker(
        markerId: MarkerId(element.email),
        infoWindow: InfoWindow(
          title: element.parkingName,
          snippet: element.address.toString(),
        ),
        position: LatLng(element.location.first, element.location.last),
        onTap: () => _onMarkerTapped(
          parking: element,

          markerId: MarkerId(element.email),
          marker: marker, // Pass the marker object here
        ),
      );
      _markers.add(marker);
    });

    setState(() {});
  }

  @override
  void initState() {
    getParkings(context);
    super.initState();

    // Convert the JSON data to markers
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var boxDecoration = BoxDecoration(
        color: Color.fromARGB(255, 255, 247, 102),
        borderRadius: BorderRadius.circular(10));
    return Scaffold(
      appBar: AppBar(
        title: Text("Check parkings near you!"),
        actions: [
          IconButton(
              onPressed: () {
                getParkings(context);
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () async {
                await auth.signOut();
                NavigationHelper.navigateToSecondRoute(context, LoginPage());
              },
              icon: Icon(Icons.logout))
        ],
      ),
      drawer: MyDrawer(),
      body: mounted == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              GoogleMap(
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      30.7641, 76.780345), // Replace with your initial position
                  zoom: 12, // Replace with your initial zoom level
                ),
              ),
              if (selectedParking != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ExpandablePageView(
                        controller: bottompagecontroller,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: height * 0.3,
                            width: width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Parking Name: ${selectedMarker?.infoWindow.title}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${selectedParking?.address.street}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        selectedindex = 0;
                                        setState(() {});
                                      },
                                      child: VehicleStatsContainer(
                                          myindex: 0,
                                          boxDecoration: boxDecoration,
                                          available:
                                              "${selectedParking!.truck.available.length}",
                                          name: "BIKE",
                                          selectedindex: selectedindex),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        selectedindex = 1;
                                        setState(() {});
                                      },
                                      child: VehicleStatsContainer(
                                          myindex: 1,
                                          boxDecoration: boxDecoration,
                                          available:
                                              "${selectedParking!.car.available.length}",
                                          name: "CAR",
                                          selectedindex: selectedindex),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        selectedindex = 2;
                                        setState(() {});
                                      },
                                      child: VehicleStatsContainer(
                                          myindex: 2,
                                          boxDecoration: boxDecoration,
                                          available:
                                              "${selectedParking!.truck.available.length}",
                                          name: "TRUCK",
                                          selectedindex: selectedindex),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      bottompagecontroller!.animateToPage(1,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeIn);
                                    },
                                    child: Text("Book Now"))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: height * 0.3,
                            width: width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Enter your vehicle details",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                  controller: vehicleNumberController,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: "Enter your vehicle number"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());
                                    timeTextController.text =
                                        pickedTime!.format(context).toString();
                                  },
                                  child: TextField(
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: "Enter your vehicle number"),
                                    enabled: false,
                                    controller: timeTextController,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      if (vehicleNumberController
                                              .text.isEmpty ||
                                          timeTextController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please enter all the details")));
                                        return;
                                      }
                                      if (timeTextController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please enter all the details")));
                                        return;
                                      }
                                    },
                                    child: Text("Book Now"))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: height * 0.32,
                            width: width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Enter duration",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                DropdownButton<Duration>(
                                  value: selectedDuration,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDuration = value!;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: Duration(hours: 1),
                                      child: Text('1 hour'),
                                    ),
                                    DropdownMenuItem(
                                      value: Duration(hours: 2),
                                      child: Text('2 hours'),
                                    ),
                                    DropdownMenuItem(
                                      value: Duration(hours: 3),
                                      child: Text('3 hours'),
                                    ),
                                    DropdownMenuItem(
                                      value: Duration(hours: 4),
                                      child: Text('4 hours'),
                                    ),
                                    DropdownMenuItem(
                                      value: Duration(hours: 5),
                                      child: Text('5 hours'),
                                    ),
                                    DropdownMenuItem(
                                      value: Duration(hours: 6),
                                      child: Text('6 hours'),
                                    ),

                                    // Add more duration options as needed
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {}, child: Text("Book Now"))
                              ],
                            ),
                          ),
                        ]),
                  ],
                )
            ]),
    );
  }
}

class VehicleStatsContainer extends StatefulWidget {
  VehicleStatsContainer({
    super.key,
    required this.boxDecoration,
    required this.available,
    required this.selectedindex,
    required this.myindex,
    required this.name,
  });

  BoxDecoration boxDecoration;
  final String available;
  final String name;
  final int selectedindex;
  final int myindex;
  Function? onTap;

  @override
  State<VehicleStatsContainer> createState() => _VehicleStatsContainerState();
}

class _VehicleStatsContainerState extends State<VehicleStatsContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedindex == widget.myindex) {
      widget.boxDecoration = BoxDecoration(
          color: Color.fromARGB(255, 255, 247, 102),
          borderRadius: BorderRadius.circular(10));
    } else {
      widget.boxDecoration = BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10));
    }
    return Container(
      decoration: widget.boxDecoration,
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${widget.name.toUpperCase()}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.available}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              // Handle navigation to home page
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              // Handle navigation to profile page
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Handle navigation to settings page
            },
          ),
        ],
      ),
    );
  }
}

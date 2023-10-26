import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sih_app/helpers/navigator_helper.dart';
import 'package:sih_app/views/booking/VehicleInfoScreen.dart';

class BookingScreen extends StatefulWidget {
  final Marker marker;

  BookingScreen({required this.marker});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Duration selectedDuration = Duration(hours: 1); // Default duration is 1 hour
  late int startTime;
  late int endTime;

  void calculateEndTime() {
    final now = DateTime.now();
    final startDateTime = now.toUtc();
    final endDateTime = startDateTime.add(selectedDuration);

    startTime = startDateTime.millisecondsSinceEpoch;
    endTime = endDateTime.millisecondsSinceEpoch;
  }

  @override
  void initState() {
    super.initState();
    calculateEndTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Screen for ${widget.marker.markerId.value}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Duration:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<Duration>(
                value: selectedDuration,
                onChanged: (value) {
                  setState(() {
                    selectedDuration = value!;
                    calculateEndTime();
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
                  // Add more duration options as needed
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Start Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                formatEpochTime(startTime),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'End Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                formatEpochTime(endTime),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  NavigationHelper.navigateToSecondRoute(
                      context,
                      BookingDetailsPage(
                          marker: widget.marker,
                          startTime: startTime,
                          endTime: endTime));
                  // Handle booking logic here
                  print('Booking button pressed');
                  print('Start Time: ${formatEpochTime(startTime)}');
                  print('End Time: ${formatEpochTime(endTime)}');
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatEpochTime(int epochMilliseconds) {
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(epochMilliseconds, isUtc: true));
    return formattedDate;
  }
}

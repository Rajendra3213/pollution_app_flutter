//form Entry Report

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../utilities/dropdown_pollutiontype.dart';
import '../utilities/dropdown_severity.dart';
import 'map_upload.dart';
import '../utilities/buildMarker.dart';

class MapPage1 extends StatefulWidget {
  final List<LatLng> points;
  final String address;
  final double latitude;
  final double longitude;
  final List<int> ids;
  const MapPage1(this.points, this.address, this.latitude, this.longitude, {super.key, required this.ids});

  @override
  State<MapPage1> createState() => _MapPage1State();
}

class _MapPage1State extends State<MapPage1> {
  @override
  Widget build(BuildContext context) {
    return _MapPage1(widget.points, widget.address, widget.latitude, widget.longitude,widget.ids);
  }
}

class _MapPage1 extends StatelessWidget {
  final List<LatLng> points;
  final String address;
  final double latitude;
  final double longitude;
  final List<int>ids;
  _MapPage1(this.points, this.address, this.latitude, this.longitude, this.ids);

  String pollutionDescription = '';
  String selectedSeverity = 'very_minimum';
  String currentLocation ='';
  void updateDescription(String description) {
    pollutionDescription = description;
  }

  void updateSeverity(String selectedValue) {
    selectedSeverity = selectedValue;
    print(selectedSeverity);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height, // Full height
            width: MediaQuery.of(context).size.width, // Full width
            child: FlutterMap(
              options: MapOptions(
                center: points.isNotEmpty ? points[0] : LatLng(latitude, longitude), // Corrected variable name
                zoom: 16.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: points.isEmpty
                      ? [
                    Marker(
                      point: LatLng(latitude, longitude),
                      width: 400,
                      height: 400,
                      child: const Icon(
                        Icons.person_pin_circle_rounded,
                        color: Colors.red,
                      ),
                    )
                  ]
                      : buildMarkers(context,points, ids),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.65, // Adjust as needed
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pollution Entry",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Your location",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9D9D9D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: const Color(0xff9D9D9D).withOpacity(0.5), // Color of the line
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Pollution Tag",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9D9D9D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Icon(Icons.circle, color: Colors.blue, size: 14),
                                SizedBox(width: 5),
                                Text("Solid Waste", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Pollution Type",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9D9D9D),
                              ),
                            ),
                            const PollutionOption(),
                            const SizedBox(height: 15),
                            const Text(
                              "Pollution Severity",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9D9D9D),
                              ),
                            ),
                            SeverityOption(
                              onChanged: updateSeverity
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9D9D9D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: (value) {
                                updateDescription(value);
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Enter Pollution Description',
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Colors.black12.withOpacity(0.5)),
                                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapPage3(
                                          pollutionDescription: pollutionDescription,
                                          latitude:latitude,
                                          longitude:longitude,
                                          address:address,
                                          points:points,
                                          severitylevel:selectedSeverity,
                                          ids: ids,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Change button color
                                    elevation: 5, // Add elevation for a raised look
                                  ),
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

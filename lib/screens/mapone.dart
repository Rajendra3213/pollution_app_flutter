import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'maptwo.dart';
import '../utilities/buildMarker.dart';
import '../utilities/buildCircle.dart';
class MapPage2 extends StatefulWidget {
  final List<LatLng> points;
  final String address;
  final double latitude;
  final double longitude;
  final List<int> ids;

  const MapPage2(this.points, this.address, this.latitude, this.longitude, this.ids, {super.key});

  @override
  _MapPage2State createState() => _MapPage2State();
}

class _MapPage2State extends State<MapPage2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height, // Full height
              width: MediaQuery.of(context).size.width, // Full width
              color: Colors.white, // Set background color to white
              child: FlutterMap(
                options: MapOptions(
                  center: widget.points[0], // Corrected variable name
                  zoom: 16.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CircleLayer(
                    circles: buildCircles(widget.points),
                  ),
                  MarkerLayer(
                    markers: buildMarkers(context,widget.points, widget.ids),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.4, // 40% of screen height
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pollution Entry",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.address,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff9D9D9D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "", // Replace with your location
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: const Color(0xff9D9D9D)
                              .withOpacity(0.5), // Color of the line
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
                            Icon(Icons.circle,
                                color: Colors.blue, size: 14),
                            SizedBox(width: 5),
                            Text("Solid Waste",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MapPage1(widget.points, widget.address, widget.latitude, widget.longitude,ids: widget.ids,)),
                                );
                                // Send location data to backend and navigate to next page
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                // Change button color
                                elevation: 5,
                                // Add elevation for a raised look
                              ),
                              child: const Text(
                                'Report Pollution Area',
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
          ],
        ),
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MalPage2 extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;
  final int severity_data;

  const MalPage2(this.address, this.latitude, this.longitude, this.severity_data, {super.key});

  @override
  _MalPage2State createState() => _MalPage2State();
}

class _MalPage2State extends State<MalPage2> {
  String severity_level = " ";
  @override
  void initState() {
    super.initState();
    if (widget.severity_data == 2) {
      severity_level = "high";
    }
    else if(widget.severity_data == 0){
      severity_level = "low";
    }
    else if(widget.severity_data == 1){
      severity_level = "moderate";
    }
    else{
      severity_level = "Very minimum";
    }
  }



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
                  center: LatLng(widget.latitude,widget.longitude), // Corrected variable name
                  zoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(widget.latitude,widget.longitude) ,
                        radius: 20,
                        useRadiusInMeter: true,
                        color: Colors.blue.withOpacity(0.5),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2,
                      ),
                    ]
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
                          "Pollution Type",
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
                        const SizedBox(height: 10),
                        Text('Pollution Severity: $severity_level')
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

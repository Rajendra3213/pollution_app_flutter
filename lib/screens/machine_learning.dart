import 'dart:convert';
import 'package:finalwatewatchnepal/utilities/findCurrentLocation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'machine_learning2.dart';


class MachineLearningPage extends StatefulWidget {
  const MachineLearningPage({super.key});

  @override
  State<MachineLearningPage> createState() => _MachineLearningPageState();
}

class _MachineLearningPageState extends State<MachineLearningPage> {
  double? _latitude;
  double? _longitude;
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() async {
    try {
      // Fetch location
      LocationService1 locationService = LocationService1();
      Map<String, dynamic> locationData = await locationService.getCurrentLocation();

      if (locationData.containsKey('error')) {
        throw Exception(locationData['error']);
      } else {
        setState(() {
          _latitude = locationData['latitude'];
          _longitude = locationData['longitude'];
          _address = locationData['address'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching location: $e');
    }
  }

  void _sendLocationToBackend(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    // Check if authToken is available
    // Send data to backend
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/predict/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken', // Add authorization token
      },
      body: jsonEncode(<String, dynamic>{
        'longitude': longitude,
        'latitude': latitude,
      }),
    );

    if (response.statusCode == 200) {
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        var severityData = json.decode(response.body)['severity'];
        print(severityData.runtimeType);
        print(severityData);
        // Navigate to the next page with the points data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MalPage2(_address!,_latitude!,_longitude!,severityData.toInt(), key: null,)),
        );
      } else {
        // If the server did not return a 200 OK response, show an error message
        print('Failed to load data from the backend: ${response.statusCode}');
      }
    } else {
      // If the server did not return a 200 OK response, show an error message
      print('Failed to send data to the backend: ${response.statusCode}');
    }
    }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: Container( height: double.infinity,
        width: double.infinity,
        color:Colors.white,
        child: Container(
            height: 200,
            width:200,
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wait Loading",style:TextStyle(color: Colors.green,fontSize: 16),),
                SizedBox(height: 10,),
                CircularProgressIndicator(),
              ],
            ))))
        : Scaffold(
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
                  center: LatLng(_latitude!, _longitude!),
                  zoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  // CircleLayer(
                  //   circles: [
                  //     CircleMarker(
                  //       point: LatLng(_latitude!, _longitude!), // center of 't Gooi
                  //       radius: 50,
                  //       useRadiusInMeter: true,
                  //       color: Colors.red.withOpacity(0.3),
                  //       borderColor: Colors.red.withOpacity(0.7),
                  //       borderStrokeWidth: 2,
                  //     )
                  //   ],
                  // ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(_latitude!, _longitude!),
                        child: const Icon(
                          Icons.person_pin_circle_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
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
                          "Pollution Prediction",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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
                          _address ?? 'Unknown', // Use default value if _address is null
                          style: const TextStyle(
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
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Send location data to backend and navigate to next page
                                _sendLocationToBackend(
                                  _latitude ?? 0.0, // Use default value if _latitude is null
                                  _longitude ?? 0.0, // Use default value if _longitude is null
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.green, // Change button color
                                elevation:
                                5, // Add elevation for a raised look
                              ),
                              child: const Text(
                                'Predict Pollution Severity',
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
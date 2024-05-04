import 'dart:convert';
import 'package:finalwatewatchnepal/screens/mapone.dart';
import 'package:finalwatewatchnepal/utilities/findCurrentLocation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'maptwo.dart';

class MapPage extends StatefulWidget {

  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
      Uri.parse('$baseUrl/api/users/complain/list'),
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
      List<int> ids = [];
      List<dynamic> data = json.decode(response.body);
      for (var item in data) {
        if (item.containsKey('id')) {
          ids.add(item['id']);
        }
      }
      List<LatLng> points = data
          .map((item) => LatLng(double.parse(item['latitude']), double.parse(item['longitude'])))
          .toList();
      if (points.isEmpty) {
        Fluttertoast.showToast(
          msg: 'There is no reported area till now',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.redAccent.withOpacity(0.7),
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage1(points, _address!, _latitude!, _longitude!,ids: ids,),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage2(points, _address!, _latitude!, _longitude!, ids),
          ),
        );
      }
    } else {
      print('Failed to load data from the backend: ${response.statusCode}');
    }
    }

  @override
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please wait...",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    )
        : (_latitude != null && _longitude != null)
        ? Scaffold(
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
                  zoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(_latitude!, _longitude!), // center of 't Gooi
                        radius: 50,
                        useRadiusInMeter: true,
                        color: Colors.red.withOpacity(0.3),
                        borderColor: Colors.red.withOpacity(0.7),
                        borderStrokeWidth: 2,
                      )
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(_latitude!, _longitude!),
                        width: 200,
                        height: 200,
                        child: const Icon(
                          Icons.person_pin_circle_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
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
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
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
                        if (_address != null)
                          Text(
                            "$_address",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
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
                            Text("Solid Waste", style: TextStyle(fontSize: 14, color: Colors.black)),
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
                                // Send location data to backend and navigate to next page
                                if (_latitude != null && _longitude != null) {
                                  _sendLocationToBackend(_latitude!, _longitude!);
                                } else {
                                  print('Latitude and Longitude are null.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Change button color
                                elevation: 5, // Add elevation for a raised look
                              ),
                              child: const Text(
                                'View Pollution Area',
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
    )
        : const Center(
      child: Text('Failed to fetch location data.'),
    );
  }

}

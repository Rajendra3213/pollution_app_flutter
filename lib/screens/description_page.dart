import 'dart:convert';

import 'package:finalwatewatchnepal/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'homePage.dart';

class MapPage4 extends StatefulWidget {
  final LatLng point;
  final int id;

  const MapPage4({
    super.key,
    required this.point, required this.id,
  });

  @override
  State<MapPage4> createState() => _MapPage4State();
}

class _MapPage4State extends State<MapPage4> {
  Future<Map<String, String?>> _getImageDescriptionAndDateFromBackend(int key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    // Initialize variables to store the result
    String? imageUrl;
    String? description;
    String? date;
    String? severityLevel;
    String? validatedBy;
    String? contact;
    

    // Check if authToken is available
    // Send GET request to fetch image, description, and date
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/complain/select/$key'),
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer $authToken', // Add authorization token
      },
    );

    if (response.statusCode == 201) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);

      // Extract image, description, and date
      imageUrl = data['image'];
      description = data['description'];
      date = data['date'];
      severityLevel = data['severity_level'];
      validatedBy = data['validated_by'];
      contact = data['contact'];
      
    } else {
      // If the server did not return a 200 OK response, show an error message
      print('Failed to fetch data from the backend: ${response.statusCode}');
    }

    // Return the result as a Map
    return {
      'image': imageUrl,
      'description': description,
      'date': date,
      'severity_level': severityLevel,
      'validated_by':validatedBy,
      'contact': contact
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String?>>(
        future: _getImageDescriptionAndDateFromBackend(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;

            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: widget.point,
                    initialZoom: 18,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: widget.point,
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            'assets/dustbin.png',
                            width: 50, // specify desired width
                            height: 50, // specify desired height
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.5,
                    child: Expanded(
                      child: SingleChildScrollView(
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
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: double.infinity,
                                  child: Image.network(
                                    "$baseUrl/${data['image']}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'Description',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  // height: MediaQuery.of(context).size.height * 0.1,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      data['description']!,
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: const Color(0xff9D9D9D).withOpacity(0.5),
                                  thickness: 1,
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'Date of Reported',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data['date']!,
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.left,
                                ),
                                Divider(
                                  color: const Color(0xff9D9D9D).withOpacity(0.5),
                                  thickness: 1,
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Severity: ",
                                            style: TextStyle(fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            data['severity_level']!,
                                            style: TextStyle(
                                              color: getSeverityColor(data['severity_level']!),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            "Clean up Area of: ",
                                            style: TextStyle(fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            data['validated_by']!,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            "Contact: ",
                                            style: TextStyle(fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            data['contact']!,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 15),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      alignment: Alignment.center,
                                      backgroundColor: Colors.green, // Change button color
                                      elevation: 5, // Add elevation for a raised look
                                    ),
                                    child: const Text(
                                      'Report the pollution',
                                      style: TextStyle(color: Colors.white),
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
              ],
            );
          }
        },
      ),
    );
  }

  Color getSeverityColor(String severity) {
    switch (severity) {
      case "very_high":
        return Colors.red;
      case "high":
        return Colors.red.withOpacity(0.7); // Red with higher transparency
      case "low":
        return Colors.red.withOpacity(0.7); // Red with higher transparency
      default:
        return Colors.green;
    }
  }
}


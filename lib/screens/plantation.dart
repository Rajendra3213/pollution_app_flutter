import 'dart:convert';
import 'package:finalwatewatchnepal/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'homePage.dart';

class PlantationPage extends StatefulWidget {
  const PlantationPage({super.key});

  @override
  State<PlantationPage> createState() => _PlantationPageState();
}

class _PlantationPageState extends State<PlantationPage> {
  late List<Map<String, dynamic>> plantationDetailsList = const [];
  bool _isLoading = true;
  LatLng? initialCenter1;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    try {
      var response = await http.get(
        Uri.parse('$baseUrl/api/users/plantation/'),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse is List) {
            plantationDetailsList = List<Map<String, dynamic>>.from(decodedResponse);
            if (plantationDetailsList.isNotEmpty) {
              var firstTree = plantationDetailsList.first;
              double latitude = firstTree['latitude'] ?? 0.0;
              double longitude = firstTree['longitude'] ?? 0.0;
              initialCenter1 = LatLng(latitude, longitude);
              print(initialCenter1);
            }
            else{
              Fluttertoast.showToast(
                msg: 'There is no tree planted yet',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.redAccent.withOpacity(0.7),
                textColor: Colors.white,
              );
            }
          } else {
            print("unsuported format");

          }
        });
      } else {
        // Handle error
        print('Failed to load user data');
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void sendDataToBackend(BuildContext context) async {
    // Define the URL
    String url = '$baseUrl/api/users/donate/plant/';

    // Get the authorization token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    // Make the POST request
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken', // Include the authorization token
          // Add any other headers as needed
        },
        body: {
          // Add any data you need to send to ther backend
          // Example: 'key': 'value'
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plantation pending'),
            backgroundColor: Colors.green,  // Set background color to green
            behavior: SnackBarBehavior.floating,  // Optional: Ensure it floats above the bottom navigation bar
            shape: RoundedRectangleBorder(   // Optional: Add rounded corners
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Optional: Add padding
            action: SnackBarAction(
              label: 'View Points',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        // Handle other status codes
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Show Snackbar indicating not enough points
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Not enough points'),
            backgroundColor: Colors.redAccent,  // Set background color to green
            behavior: SnackBarBehavior.floating,  // Optional: Ensure it floats above the bottom navigation bar
            shape: RoundedRectangleBorder(   // Optional: Add rounded corners
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Optional: Add padding
            action: SnackBarAction(
              label: 'View Points',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
      // Show Snackbar indicating network error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error'),
        ),
      );
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height, // Full height
              width: MediaQuery.of(context).size.width, // Full width
              color: Colors.white, // Set background color to white
              child:  FlutterMap(
                options: MapOptions(
                  initialCenter: initialCenter1 ?? LatLng(27.700769, 85.300140),
                  zoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: _buildMarkers(),
                  ),
                ],
              )
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
                          "Your Planted Tree Details",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Planted Status",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff9D9D9D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "In the Name of Father Mr. Ganesh Bahadur",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 50),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                sendDataToBackend(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Change button color
                                elevation: 5, // Add elevation for a raised look
                              ),
                              child: const Text(
                                'Plant More',
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

  List<Marker> _buildMarkers() {
    return plantationDetailsList.map((plantation) {
      double latitude = plantation['latitude'] ?? 0.0; // Replace with your default latitude value
      double longitude = plantation['longitude'] ?? 0.0;

      return Marker(
        point: initialCenter1! ,
        width: 45, // Adjust the width as desired
        height: 45, // Adjust the height as desired
        child: Image.asset(
          'assets/tree.png',
          width: 50, // specify desired width
          height: 50, // specify desired height
        ),
      );
    }).toList();
  }

}

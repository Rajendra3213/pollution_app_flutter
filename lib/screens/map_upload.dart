import 'dart:convert';
import 'dart:io';
import 'package:finalwatewatchnepal/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/buildMarker.dart';

import '../main.dart';

class MapPage3 extends StatefulWidget {
  final List<LatLng> points;
  final String pollutionDescription;
  final double latitude;
  final double longitude;
  final String address;
  final String severitylevel;
  final List<int> ids;

  const MapPage3({
    super.key,
    required this.pollutionDescription,
    required this.latitude,
    required this.longitude,
    required this.points,
    required this.address, required this.severitylevel, required this.ids
  });

  @override
  State<MapPage3> createState() => _MapPage3State();
}

class _MapPage3State extends State<MapPage3> {
  File? _image;
  final picker = ImagePicker();

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
                center: widget.points.isNotEmpty ? widget.points[0] : LatLng(widget.latitude, widget.longitude), // Corrected variable name
                zoom: 16.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: widget.points.isEmpty
                      ? [
                    Marker(
                      point: LatLng(widget.latitude, widget.longitude),
                      width: 400,
                      height: 400,
                      child: const Icon(
                        Icons.person_pin_circle_rounded,
                        color: Colors.red,
                      ),
                    )
                  ]
                      :  buildMarkers(context,widget.points, widget.ids),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.65, // 65% of screen height
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Upload Image",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: _image == null
                            ? const Text('No image selected.')
                            :Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () => _getImageFromSource(ImageSource.camera),
                            tooltip: 'Take Photo',
                            child: const Icon(Icons.camera),
                          ),
                          const SizedBox(width: 20),
                          FloatingActionButton(
                            onPressed: () => _getImageFromSource(ImageSource.gallery),
                            tooltip: 'Choose from Gallery',
                            child: const Icon(Icons.photo_library),
                          ),
                        ],
                      ),
                      const Spacer(), // Flexible space
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _sendDataToBackend(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Change button color
                            elevation: 5, // Add elevation for a raised look
                          ),
                          child: const Text(
                            'Submit',
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
        ],
      ),
    );
  }
  Future<void> _getImageFromSource(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _sendDataToBackend(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    // Extract data from widget
    String description = widget.pollutionDescription;
    double longitude = widget.longitude;
    double latitude = widget.latitude;
    String severity = widget.severitylevel;

    // Prepare the request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/users/complain/add'),
    );

    // Set headers
    request.headers.addAll({
      'Authorization': 'Bearer $authToken',
      'accept': '*/*',
    });

    // Add form fields
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['description'] = description;
    request.fields['severity_level']= severity.toString();

    // Add image if available
    if (_image != null) {
      var fileStream = http.ByteStream(_image!.openRead());
      var length = await _image!.length();

      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: _image!.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Handle the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final details = data['detail'] as String;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(details),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          elevation: 5,
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        final details = data['detail'] as String;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(details),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          elevation: 5,
        ));
      }
    } catch (e) {
      print('Failed to send data. Error: $e');
    }
  }

}

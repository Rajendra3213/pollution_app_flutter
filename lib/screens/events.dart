import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late List<Map<String, dynamic>> eventDetailsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  void _sendEventToBackend(int key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    // Check if authToken is available
    // Send data to backend
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/event/signup/$key'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken', // Add authorization token
      },
      body: jsonEncode(<String, dynamic>{
        'id': key,
      }),
    );

    if (response.statusCode == 202) {
      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event registration successful! Check your Email'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print('Failed to register for the event');
    }
    }

  Future<void> _fetchEventData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    try {
      var response = await http.get(
        Uri.parse('$baseUrl/api/users/event/all'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse is List) {
            eventDetailsList = List<Map<String, dynamic>>.from(decodedResponse);
          } else {
            print('Invalid response format');
          }
        });
      } else {
        print('Failed to load event data');
      }
    } catch (e) {
      print('Network error: $e');
    }
  
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventDetailsList.isEmpty
          ? Center(
        child: Text(
          'Events will be announced soon!',
          style: const TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: eventDetailsList.length,
          itemBuilder: (BuildContext context, int index) {
            var event = eventDetailsList[index];
            return _buildEventBox(event);
          },
        ),
      ),
    );
  }

  Widget _buildEventBox(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '$baseUrl/media/${event["image"]}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  height: 150,
                  width: double.infinity,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event["title"],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event["description"],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start Date: ${event["start_date"]}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'End Date: ${event["end_date"]}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _sendEventToBackend(event["id"]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Register Now',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

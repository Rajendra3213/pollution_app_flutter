import 'dart:convert';

import 'package:finalwatewatchnepal/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userDetails = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'number': '',
    'address': '',
    'point': 0,
  };
  bool _isLoading = false;

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
        Uri.parse('$baseUrl/api/users/data/'),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 202) {
        setState(() {
          userDetails = json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(
                foregroundImage: NetworkImage(
                    "https://media.licdn.com/dms/image/D5603AQFvTZymkZkwAA/profile-displayphoto-shrink_800_800/0/1681391580488?e=2147483647&v=beta&t=8wq1LdCMQHBMVQmM5Tz9cRXMesTsYDVcpUSgmFdrHik"),
                backgroundImage: AssetImage('assets/avatar.png'),
                radius: 30,
              ),
              title: Text(
                '${userDetails['first_name']} ${userDetails['last_name']}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userDetails['email'],
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15.0),
                Text(
                  userDetails['number'],
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15.0),
                Text(
                  userDetails['address'],
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                Container(
                  constraints: const BoxConstraints(
                      maxWidth: double.infinity // Max width of the container// Max height of the container
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                        const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/tree.png',
                            height: 100), // Adjust height as needed
                        const SizedBox(height: 10),
                        Text(
                          userDetails['point'].toString(),
                          style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Colors.green),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Plant Tree Now",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              width: 300,
                              child: Text(
                                "Boost your points by engaging in reporting, participating in pollution cleaning events, and making donations",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              " Get a tree planted in your name!",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MapPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                elevation: 5,
                              ),
                              child: const Text(
                                'Get Score',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


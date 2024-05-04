import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utilities/topthreeLeader.dart'; // Assuming this is a custom file

class LeaderPage extends StatefulWidget {
  const LeaderPage({super.key});

  @override
  _LeaderPageState createState() => _LeaderPageState();
}

class _LeaderPageState extends State<LeaderPage> {
  late List<Map<String, dynamic>> leaderDataList = [];
  List<Map<String, dynamic>> topThreeData = []; // Initialize empty topThreeData
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLeaderData();
  }

  Future<void> _fetchLeaderData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('accessToken');

    try {
      var response = await http.get(
        Uri.parse('$baseUrl/api/users/leaderboard/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          var decodedResponse = json.decode(response.body);
          if (decodedResponse is List) {
            // Sort by highest tree_planted count
            leaderDataList = List<Map<String, dynamic>>.from(decodedResponse)
              ..sort((a, b) => b['tree_planted'] - a['tree_planted']);

            // Extract top 3 users (if available)
            topThreeData = leaderDataList.length >= 3
                ? leaderDataList.sublist(0, 3)
                : leaderDataList; // Fill with all data if less than 3 users
          } else {
            print('Invalid response format');
          }
        });
      } else {
        print('Failed to load leaderboard data (Status Code: ${response.statusCode})');
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
        title: const Text('Leaderboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Display loading indicator
          : leaderDataList.isEmpty
          ? const Center(child: Text('No data available')) // Display empty data message
          : Column(
        children: [
          TopThreeDisplay(topThreeData: topThreeData),
          Expanded( // Use Expanded for ListView to fill remaining space
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: ListView.builder(
                itemCount: leaderDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  var user = leaderDataList[index];
                  return _buildLeaderItem(user, index + 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderItem(Map<String, dynamic> user, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom:1.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.green.withOpacity(0.5)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rank and name
            Text(
              rank <= 3
                  ? '$rank. ${user["name"]}' // Bold for top 3
                  : '$rank. ${user["name"]}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            // Points and trees planted
            Row(
              children: [
                const Icon(Icons.forest, color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  user["tree_planted"].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text(
                  user["point"].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


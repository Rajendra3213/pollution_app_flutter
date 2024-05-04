import 'package:finalwatewatchnepal/screens/events.dart';
import 'package:finalwatewatchnepal/screens/leaderboard.dart';
import 'package:finalwatewatchnepal/screens/machine_learning.dart';
import 'package:flutter/material.dart';
import 'package:finalwatewatchnepal/screens/map.dart';
import 'package:finalwatewatchnepal/screens/plantation.dart';
import 'package:finalwatewatchnepal/screens/profilepage.dart';
import '../constants/constants.dart'; // Import your constants file

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wastewatch Nepal",
          style: TextStyle(
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.leaderboard,
              color: AppConstants.primaryColor,
            ),
            tooltip: 'leaderboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LeaderPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: AppConstants.primaryColor,
            ),
            tooltip: 'Account',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPage(),
                        ),
                      );
                      print("Report Pollution Clicked");
                    },
                    child: Container(
                      height: 104,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/carbon_report.png', height: 56),
                          const SizedBox(height: 10),
                          const Text(
                            "Report Pollution",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: AppConstants.smallFontSize,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MachineLearningPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 104,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image1.png',
                            height: 56,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Predict Pollution",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: AppConstants.smallFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlantationPage(),
                        ),
                      );
                      print("Your Planted Tree");
                    },
                    child: Container(
                      height: 104,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/tree.png', height: 56),
                          const SizedBox(height: 10),
                          const Text(
                            "Your Plantation",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: AppConstants.smallFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventsPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 104,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/greenevent.png', height: 56),
                          const SizedBox(height: 10),
                          const Text(
                            "Green Event",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: AppConstants.smallFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
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

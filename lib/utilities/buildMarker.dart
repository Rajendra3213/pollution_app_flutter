
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../screens/description_page.dart';

List<Marker> buildMarkers(BuildContext context, List<LatLng> points, List<int> ids) {
  assert(points.length == ids.length); // Ensure points and ids have the same length

  return List.generate(points.length, (index) {
    LatLng point = points[index];
    int id = ids[index];
    return Marker(
      point: point,
      width: 40, // Adjust the width as desired
      height: 45, // Adjust the height as desired
      child: GestureDetector(
        onDoubleTap: () {
          print("fuck");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage4(point: point, id: id)),
          );
        },
        child: Image.asset(
          'assets/dustbin.png',
          width: 50, // specify desired width
          height: 50, // specify desired height
        ),
      ),
    );
  });
}
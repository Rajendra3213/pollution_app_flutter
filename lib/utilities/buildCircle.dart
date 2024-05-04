import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<CircleMarker> buildCircles(List<LatLng> points) {
  return points.map((point) {
    return CircleMarker(
      point: point,
      radius: 15,
      useRadiusInMeter: true,
      color: Colors.green.withOpacity(0.3),
      borderColor: Colors.green.withOpacity(0.7),
      borderStrokeWidth: 2,
    );
  }).toList();
}
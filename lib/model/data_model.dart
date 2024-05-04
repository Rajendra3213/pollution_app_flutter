import 'package:latlong2/latlong.dart';

class PointData {
  final List<LatLng> points;
  final List<int> severityIndexes;

  PointData({required this.points, required this.severityIndexes});

  factory PointData.fromJson(Map<String, dynamic> json) {
    List<LatLng> points = [];
    List<int> severityIndexes = [];

    if (json['points'] != null) {
      json['points'].forEach((point) {
        double lat = point['lat'];
        double lng = point['lng'];
        points.add(LatLng(lat, lng));
      });
    }

    if (json['severityIndexes'] != null) {
      severityIndexes.addAll(json['severityIndexes'].cast<int>());
    }
    return PointData(
      points: points,
      severityIndexes: severityIndexes,
    );
  }
}

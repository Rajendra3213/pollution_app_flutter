import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService1 {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      bool servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        throw Exception("Location service is disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          throw Exception("Location permission denied.");
        }
      }

      Position currentLocation = await Geolocator.getCurrentPosition();
      // Fetch human-readable address using Geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);
      String currentAddress = "";
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        currentAddress = "${placemark.subLocality},${placemark.street}, ${placemark.locality}, ${placemark.country}";
      }
      print("latitude is ${currentLocation.latitude}");
      print("Longitude is ${currentLocation.longitude}");
      return {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'address': currentAddress,
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }
}

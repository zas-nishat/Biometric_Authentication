// location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  // Method to get the current location
 static Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LatLng(0, 0); // Default to (0,0) if no service
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LatLng(0, 0); // Default to (0,0) if permission denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LatLng(0, 0); // Default to (0,0) if permission permanently denied
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // Return the current location as a LatLng object
    return LatLng(position.latitude, position.longitude);
  }
}

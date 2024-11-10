// secure_page.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Services/LocationHelper.dart';

class SecurePage extends StatefulWidget {
  const SecurePage({super.key});

  @override
  State<SecurePage> createState() => _SecurePageState();
}

class _SecurePageState extends State<SecurePage> {
  String currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    // Fetch the current location coordinates
    LatLng? currentLocation = await LocationService.getCurrentLocation();
    if (currentLocation != null) {
      // Convert coordinates to a human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          Placemark place = placemarks[1];
          // Use detailed fields such as street, subThoroughfare (house number), locality, etc.
          currentAddress = "${place.street ?? 'N/A'}, "
              "${place.locality ?? 'N/A'}, ${place.administrativeArea ?? 'N/A'}, "
              "${place.postalCode ?? 'N/A'}, ${place.country ?? 'N/A'}";
        });
      } else {
        setState(() {
          currentAddress = "Location unavailable";
        });
      }
    } else {
      setState(() {
        currentAddress = "Location services disabled or permission denied.";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                currentAddress,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This is a secure page that requires authentication.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              currentAddress,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

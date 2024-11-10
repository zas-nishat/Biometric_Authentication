import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../Services/LocationHelper.dart';

class GHomePage extends StatefulWidget {
  const GHomePage({Key? key}) : super(key: key);

  @override
  _GHomePageState createState() => _GHomePageState();
}

class _GHomePageState extends State<GHomePage> {
  GoogleMapController? _mapController;
  LatLng? currentLocation;
  String currentAddress = "Fetching location...";
  final LocationService _locationService = LocationService(); // Create an instance of LocationService

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    LatLng? location = await LocationService.getCurrentLocation();
    setState(() {
      currentLocation = location;
    });

    // Convert coordinates to address
    if (currentLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          currentAddress = "${place.subThoroughfare ?? ''} ${place.street ?? ''}, "
              "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, "
              "${place.country ?? ''}";
        });
      }
    }

    // Move the camera to the current location once it's fetched
    if (_mapController != null && currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLocation!),
      );
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
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: currentLocation!,
          zoom: 13,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: currentLocation!,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchCurrentLocation();
        },
        child: const Icon(Icons.my_location),
        tooltip: 'Show Current Location',
      ),
    );
  }
}

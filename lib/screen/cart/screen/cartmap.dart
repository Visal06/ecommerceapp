import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default position
    zoom: 14.0,
  );

  late location.Location _location;
  location.LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    _location = location.Location();
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      _location.onLocationChanged.listen((location.LocationData newLocation) {
        setState(() {
          _currentLocation = newLocation;
        });
      });
      _currentLocation = await _location.getLocation();
      _updateMapLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
    }
  }

  Future<void> _updateMapLocation() async {
    final GoogleMapController controller = await _mapController.future;

    if (_currentLocation == null) return;

    final LatLng newLatLng = LatLng(
      _currentLocation!.latitude!,
      _currentLocation!.longitude!,
    );

    controller.animateCamera(CameraUpdate.newLatLng(newLatLng));
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Create a detailed address string
        String addressString = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ]
            .where((component) => component != null && component.isNotEmpty)
            .join(', ');

        // Return the selected location and address back to the previous screen
        Navigator.pop(context, addressString);
      }
    } catch (e) {
      print('Error getting address: $e');
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Screen',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        onTap: (LatLng tappedLocation) async {
          await _getAddressFromLatLng(tappedLocation);
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
      ),
    );
  }
}

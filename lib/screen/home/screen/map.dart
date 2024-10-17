import 'dart:async';
import 'dart:io'; // Import for Platform checks

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location; // Alias for location
import 'package:permission_handler/permission_handler.dart'
    as permission_handler; // Alias for permission_handler
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  final List<Marker> _markers = [];
  late BitmapDescriptor _branch1Icon;
  late BitmapDescriptor _branch2Icon;
  late location.Location _location;
  location.LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _initializeLocation();
  }

  Future<void> _loadMarkers() async {
    try {
      _branch1Icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(100, 100)),
        'assets/icon/maker2.png',
      );
      _branch2Icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(100, 100)),
        'assets/icon/maker2.png',
      );
    } catch (e) {
      print('Error loading icons: $e');
    }

    setState(() {
      _markers.addAll([
        Marker(
          markerId: const MarkerId('branch1'),
          position: const LatLng(37.7749, -122.4194),
          infoWindow: const InfoWindow(title: 'Branch 1'),
          icon: _branch1Icon,
          onTap: () => _openInGoogleMaps(const LatLng(37.7749, -122.4194)),
        ),
        Marker(
          markerId: const MarkerId('branch2'),
          position: const LatLng(37.7902, -122.4071),
          infoWindow: const InfoWindow(title: 'Branch 2'),
          icon: _branch2Icon,
          onTap: () => _openInGoogleMaps(const LatLng(37.7902, -122.4071)),
        ),
      ]);
    });
  }

  Future<void> _initializeLocation() async {
    _location = location.Location();

    // Request location permission
    permission_handler.PermissionStatus permissionStatus =
        await permission_handler.Permission.location.request();
    if (permissionStatus.isGranted) {
      _location.onLocationChanged.listen((location.LocationData newLocation) {
        setState(() {
          _currentLocation = newLocation;
        });
        _updateMapLocation();
      });

      // Fetch the initial location
      _currentLocation = await _location.getLocation();
      _updateMapLocation();
    } else {
      // Handle permission denial
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(
      //         'Location permission is required to track current location.'),
      //   ),
      // );
    }
  }

  Future<void> _updateMapLocation() async {
    final GoogleMapController controller = await _mapController.future;

    if (_currentLocation == null) return;

    final LatLng newLatLng = LatLng(
      _currentLocation!.latitude!,
      _currentLocation!.longitude!,
    );

    setState(() {
      _markers
          .removeWhere((marker) => marker.markerId.value == 'currentLocation');
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: newLatLng,
          infoWindow: const InfoWindow(title: 'Current Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    controller.animateCamera(
      CameraUpdate.newLatLng(newLatLng),
    );
  }

  Future<void> _openInGoogleMaps(LatLng location) async {
    final String googleMapsUrl = Platform.isIOS
        ? 'maps://?q=${location.latitude},${location.longitude}'
        : 'geo:${location.latitude},${location.longitude}';

    print('Attempting to open URL: $googleMapsUrl'); // Debug print

    try {
      final bool canLaunchUrl = await canLaunch(googleMapsUrl);
      print('Can launch URL: $canLaunchUrl'); // Debug print

      if (canLaunchUrl) {
        await launch(googleMapsUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Google Maps is not installed or the URL is invalid.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true, // Show current location button on the map
        myLocationButtonEnabled:
            true, // Show current location button on the map
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final MapController _mapController = MapController();
  LocationData? _locationData;
  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled && !await location.requestService()) return;

    final PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied &&
        await location.requestPermission() != PermissionStatus.granted) {
      return;
    }

    final data = await location.getLocation();
    setState(() {
      _locationData = data;
      _mapController.move(
        LatLng(_locationData?.latitude ?? 0, _locationData?.longitude ?? 0),
        16,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          if (_locationData != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    _locationData!.latitude!,
                    _locationData!.longitude!,
                  ),
                  width: 80,
                  height: 80,
                  child: const Icon(Icons.location_pin,
                      size: 40, color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}










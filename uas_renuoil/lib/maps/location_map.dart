import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

class ReNuOilLocation {
  final String name;
  final LatLng location;

  ReNuOilLocation({required this.name, required this.location});
}

// List lokasi mesin ReNuOil
final List<ReNuOilLocation> renuoilMachineLocations = [
  ReNuOilLocation(
      name: 'B Residence BSD City', location: LatLng(-6.3000, 106.6500)),
  ReNuOilLocation(
      name: 'Residence 8 Senopati', location: LatLng(-6.2249, 106.8083)),
  ReNuOilLocation(
      name: 'Apartment Orchard Surabaya', location: LatLng(-7.2903, 112.7271)),
  ReNuOilLocation(
      name: 'Hilltops Luxury Apartment Singapore',
      location: LatLng(1.2931, 103.7858)),
  ReNuOilLocation(
      name: 'Beachwalk Shopping Center Bali',
      location: LatLng(-8.7090, 115.1694)),
];


class LocationMapScreen extends StatefulWidget {
  final ValueChanged<String>? onLocationUpdated;

  const LocationMapScreen({super.key, this.onLocationUpdated});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  final loc.Location _locationService = loc.Location();
  bool _isLocationFetching = false;
  String _locationError = '';
  String _locationText = 'Fetching Location...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationFetching = true;
      _locationError = '';
    });
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          setState(() {
            _locationError = 'Location services are disabled.';
          });
          return;
        }
      }

      loc.PermissionStatus permissionGranted =
          await _locationService.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          setState(() {
            _locationError = 'Location permission denied.';
          });
          return;
        }
      }

      final loc.LocationData locationData =
          await _locationService.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          _isLocationFetching = false;
        });
        _getAddressFromCoordinates(_currentLocation!);
      } else {
        setState(() {
          _locationError = 'Could not retrieve location.';
          _isLocationFetching = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationError = 'Error fetching location: $e';
        _isLocationFetching = false;
      });
    }
  }

  void _centerMapToLocation(LatLng location) {
    _mapController.move(location, 15.0);
  }

  Future<void> _getAddressFromCoordinates(LatLng latlng) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latlng.latitude, latlng.longitude);
      if (placemarks.isNotEmpty) {
        final geo.Placemark place = placemarks.first;
        final address =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        setState(() {
          _locationText = address;
        });
        if (widget.onLocationUpdated != null) {
          widget.onLocationUpdated!(address);
        }
      } else {
        setState(() {
          _locationText = 'Location found';
        });
        if (widget.onLocationUpdated != null) {
          widget.onLocationUpdated!('Location found');
        }
      }
    } catch (e) {
      setState(() {
        _locationText = 'Could not determine address.';
      });
      if (widget.onLocationUpdated != null) {
        widget.onLocationUpdated!('Could not determine address.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLocationFetching
        ? const Center(child: CircularProgressIndicator())
        : _locationError.isNotEmpty
            ? Center(child: Text(_locationError))
            : _currentLocation == null
                ? const Center(child: Text('Waiting for location...'))
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation!,
                      initialZoom: 15.0,
                      onMapReady: () {
                        _centerMapToLocation(_currentLocation!);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          // Marker lokasi user
                          Marker(
                            point: _currentLocation!,
                            width: 80,
                            height: 80,
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.location_pin,
                                  size: 40,
                                  color: Colors.red,
                                ),
                                Text(
                                  'You',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          // Markers lokasi mesin ReNuOil
                          ...renuoilMachineLocations.map((location) {
                            return Marker(
                              point: location.location,
                              width: 100,
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      location.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  );
  }
}

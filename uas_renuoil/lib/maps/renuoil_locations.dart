import 'package:latlong2/latlong.dart';

class ReNuOilLocation {
  final String name;
  final LatLng location;

  ReNuOilLocation({required this.name, required this.location});
}

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

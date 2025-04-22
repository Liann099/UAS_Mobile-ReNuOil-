import 'package:latlong2/latlong.dart';

class ReNuOilLocation {
  final String name;
  final LatLng location;

  ReNuOilLocation({required this.name, required this.location});
}

final List<ReNuOilLocation> renuoilMachineLocations = [
  ReNuOilLocation(name: 'AEON Mall BSD', location: LatLng(-6.2576, 106.6306)),
  ReNuOilLocation(name: 'Central Park Jakarta', location: LatLng(-6.1745, 106.7906)),
  ReNuOilLocation(name: 'Pakuwon Mall Surabaya', location: LatLng(-7.2927, 112.7330)),
  ReNuOilLocation(name: 'Trans Studio Bandung', location: LatLng(-6.9256, 107.6315)),
  ReNuOilLocation(name: 'Plaza Ambarrukmo Yogyakarta', location: LatLng(-7.7827, 110.4057)),
  ReNuOilLocation(name: 'Another Location in Bali', location: LatLng(-8.6528, 115.2126)), // BISA TANYA GPT KALO SOAL LOCATION INI ASAL ADA AJA
];
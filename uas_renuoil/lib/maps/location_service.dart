import 'package:http/http.dart' as http;
import 'dart:convert';


class ServerLocation {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  ServerLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory ServerLocation.fromJson(Map<String, dynamic> json) {
    return ServerLocation(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

/// Fetches the list of locations from your Django API
Future<List<ServerLocation>> fetchLocations() async {
  final response = await http.get(
    // Uri.parse('http://your-django-server-url/locations/'),
   
    Uri.parse('http:// 0.0.0.0:8000/locations/'),   //Placeholder 
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => ServerLocation.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load locations');
  }
}

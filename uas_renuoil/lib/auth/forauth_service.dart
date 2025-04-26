import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Base URL for API calls
  static const String baseUrl = 'http://192.168.156.40:8000';
  
  // Store auth token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get stored auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
  
  // Add auth headers to requests
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }
  
  // Password reset request
  static Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final headers = await getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/users/reset_code/'),
        headers: headers,
        body: jsonEncode({'email': email}),
      );
      
      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'data': response.statusCode == 200 ? jsonDecode(response.body) : null,
        'error': response.statusCode != 200 ? jsonDecode(response.body) : null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';

import '../constants.dart';

final storage = FlutterSecureStorage();

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isLoading = true;
  Map<String, String> personalInfo = {
    'Legal name': '',
    'Preferred first name': '',
    'Phone Number': '',
    'Email': '',
    'Address': '',
    'Emergency contact': '',
  };

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final userResponse = await http.get(
        Uri.parse('$baseUrl/auth/users/me/'),
        headers: headers,
      );

      final profileResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/profile/'),
        headers: headers,
      );

      if (userResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        final profileData = json.decode(profileResponse.body);

        setState(() {
          personalInfo['Email'] = userData['email'] ?? '';
          personalInfo['Legal name'] = profileData['legal_name'] ?? '';
          personalInfo['Preferred first name'] =
              profileData['preferred_first_name'] ?? '';
          personalInfo['Phone Number'] = profileData['phone_number'] ?? '';
          personalInfo['Address'] = profileData['address'] ?? '';
          personalInfo['Emergency contact'] =
              profileData['emergency_contact'] ?? '';
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile or user info');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> updateProfile(String key, String newValue) async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final updatedData = {
        key.toLowerCase().replaceAll(' ', '_'): newValue,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/api/auth/profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        setState(() {
          personalInfo[key] = newValue;
        });
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  void _showEditDialog(String key) {
    final controller = TextEditingController(text: personalInfo[key] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $key'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: key,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              updateProfile(key, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEditDialog(title),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Poppins',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(color: Colors.grey, thickness: 0.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 40,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        'Personal info',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    _buildInfoSection(
                        'Legal name', personalInfo['Legal name']!),
                    _buildDivider(),
                    _buildInfoSection('Preferred first name',
                        personalInfo['Preferred first name']!),
                    _buildDivider(),
                    _buildInfoSection(
                        'Phone Number', personalInfo['Phone Number']!),
                    _buildDivider(),
                    _buildInfoSection('Email', personalInfo['Email']!),
                    _buildDivider(),
                    _buildInfoSection('Address', personalInfo['Address']!),
                    _buildDivider(),
                    _buildInfoSection('Emergency contact',
                        personalInfo['Emergency contact']!),
                    _buildDivider(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }
}

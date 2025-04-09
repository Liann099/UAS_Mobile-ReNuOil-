import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

import '../generated/assets.dart';
import '../constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final storage = const FlutterSecureStorage();
  Map<String, String> userData = {
    'username': '',
    'bio': '',
    'userId': '',
    'email': '',
    'phone': '',
    'gender': '',
    'birthday': '',
  };

  String? profilePictureUrl;
  bool isLoading = true;
  bool isSaving = false;

  Map<String, TextEditingController> controllers = {};
  Map<String, bool> isEditing = {};

  // Gender options
  final List<String> genderOptions = ['male', 'female'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      // Fetch from both endpoints
      final userResponse = await http.get(
        Uri.parse('$baseUrl/auth/users/me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final profileResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (userResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final userDataResponse = json.decode(userResponse.body);
        final profileData = json.decode(profileResponse.body);

        setState(() {
          userData = {
            'username': userDataResponse['username'] ?? '',
            'bio': profileData['bio'] ?? '',
            'userId': userDataResponse['id'].toString(),
            'email': userDataResponse['email'] ?? '',
            'phone': profileData['phone_number'] ?? '',
            'gender': profileData['gender'] ?? '',
            'birthday': profileData['date_of_birth'] ?? '',
          };
          profilePictureUrl = profileData['profile_picture'];
          isLoading = false;

          for (var key in userData.keys) {
            controllers[key] = TextEditingController(text: userData[key]);
            isEditing[key] = false;
          }
        });
      } else {
        print(
            '[ERROR] Failed to load user data: ${userResponse.statusCode} or ${profileResponse.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Exception occurred: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: userData['birthday']!.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(userData['birthday']!)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controllers['birthday']!.text = formattedDate;
      await _saveField('birthday', formattedDate);
    }
  }

  Future<void> _saveField(String field, String value) async {
    if (value.trim().isEmpty) return;

    setState(() {
      isSaving = true;
    });

    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) return;

      // Determine which endpoint to use based on the field
      String endpoint;
      String apiField = field;
      Map<String, dynamic> requestBody = {};

      if (field == 'username' || field == 'email') {
        endpoint = '$baseUrl/auth/users/me/';
        requestBody = {apiField: value};
      } else {
        endpoint = '$baseUrl/api/auth/profile/';
        // Map field names to match the API
        if (field == 'phone') apiField = 'phone_number';
        if (field == 'birthday') apiField = 'date_of_birth';
        requestBody = {apiField: value};
      }

      final response = await http.patch(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          userData[field] = value;
          isEditing[field] = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${field.capitalize()} updated successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        print('[ERROR] Failed to update $field: ${response.statusCode}');
        print('[ERROR] Response body: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update ${field.capitalize()}'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Revert the change if failed
        controllers[field]!.text = userData[field]!;
      }
    } catch (e) {
      print('[ERROR] Exception on updating $field: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating ${field.capitalize()}'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Revert the change if error
      controllers[field]!.text = userData[field]!;
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Gender',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: userData['gender']!.isEmpty ? null : userData['gender'],
              items: genderOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  controllers['gender']!.text = newValue;
                  await _saveField('gender', newValue);
                }
              },
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Select gender',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              const Icon(Symbols.arrow_back_ios_new, size: 24),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Edit profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD358),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: profilePictureUrl == null
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    image: profilePictureUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                profilePictureUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: profilePictureUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white70,
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  userData['username']!.isEmpty
                                      ? 'No Username'
                                      : userData['username']!,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildSection('Profile Info'),
                          _buildEditableField('username', 'Username'),
                          _buildEditableField('bio', 'Bio'),
                          const SizedBox(height: 12),
                          buildSection('Personal Info'),
                          _buildReadOnlyField('userId', 'User ID',
                              hasClipboard: true),
                          _buildEditableField('email', 'E-mail'),
                          _buildEditableField('phone', 'Phone number'),
                          _buildGenderField(), // Replaced with the new gender dropdown
                          _buildBirthdayField(),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(
                              height: 30,
                              thickness: 1.2,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/delete-account'),
                                child: const Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Divider(height: 30, thickness: 1.2, color: Colors.grey.shade400),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String key, String label) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controllers[key],
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: key == 'bio'
                        ? 'Write a bio about you'
                        : userData[key]!.isEmpty
                            ? '-'
                            : null,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isEditing[key] = true;
                    });
                  },
                  onFieldSubmitted: (value) async {
                    if (isEditing[key]!) {
                      await _saveField(key, value);
                    }
                  },
                ),
              ),
              if (isEditing[key]!)
                IconButton(
                  icon: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save, size: 20),
                  onPressed: isSaving
                      ? null
                      : () async {
                          await _saveField(key, controllers[key]!.text);
                        },
                )
              else
                const Icon(Icons.chevron_right, size: 20, color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBirthdayField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Birthday',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: TextFormField(
                controller: controllers['birthday'],
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: userData['birthday']!.isEmpty ? '-' : null,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                enabled: false,
              ),
            ),
          ),
          const Icon(Icons.calendar_today, size: 20, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String key, String label,
      {bool hasClipboard = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: Text(
              userData[key] ?? '-',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          if (hasClipboard)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: userData[key] ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Copied to clipboard")),
                );
              },
              child:
                  const Icon(Icons.content_copy, size: 20, color: Colors.black),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

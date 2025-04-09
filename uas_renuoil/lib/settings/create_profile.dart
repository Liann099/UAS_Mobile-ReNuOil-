import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final storage = FlutterSecureStorage();

  String email = '';
  String username = '';
  String? profilePictureUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    final token = await storage.read(key: 'access_token');

    if (token == null) {
      print('No token found');
      return;
    }

    try {
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
        final userData = json.decode(userResponse.body);
        final profileData = json.decode(profileResponse.body);

        setState(() {
          email = userData['email'];
          username = userData['username'];

          final rawProfilePicture = profileData['profile_picture'];
          profilePictureUrl =
              (rawProfilePicture != null && rawProfilePicture != '')
                  ? (rawProfilePicture.toString().startsWith('http')
                      ? rawProfilePicture
                      : '$baseUrl$rawProfilePicture')
                  : null;

          print('Profile picture URL: $profilePictureUrl');
          isLoading = false;
        });
      } else {
        print('User response code: ${userResponse.statusCode}');
        print('Profile response code: ${profileResponse.statusCode}');
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Symbols.arrow_back_ios_new, size: 24),
                      ),
                    ),

                    // Profile Card
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD358),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Profile Picture
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
                                // Username
                                Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Change Profile Picture Button
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit-profile');
                            },
                            child: const Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Confirmed Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Icon(Icons.check, size: 30, color: Colors.green),
                        const SizedBox(width: 15),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 20),

                    const Text(
                      'It\'s time to create your profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'Your profile is an important part of every transaction in this app. Create yours to help other buyer and seller get to know you.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 70),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit-profile');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD358),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Create Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final storage = FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();

  String email = '';
  String username = '';
  String? profilePictureUrl;
  bool isLoading = true;
  File? _selectedImage;

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

  Future<void> _showImageSourceModal() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Choose from files'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(
                      ImageSource.gallery); // Using gallery for files too
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestPhotosPermission() async {
    if (await Permission.photos.request().isGranted) {
      return true;
    }
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<void> _pickImage(ImageSource source) async {
    // Request permissions
    if (source == ImageSource.camera) {
      if (!await requestCameraPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
        return;
      }
    } else {
      if (!await requestPhotosPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photos permission denied')),
        );
        return;
      }
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Check file size (e.g., 5MB limit)
        if (fileSize > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size should be less than 5MB')),
          );
          return;
        }

        setState(() {
          _selectedImage = file;
        });
        await _uploadProfilePicture();
      }
    } on PlatformException catch (e) {
      print('Platform Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.message}')),
      );
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to pick image. Please try again.')),
      );
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage == null) return;
    //
    final token = await storage.read(key: 'access_token');
    if (token == null) return;

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/api/auth/profile/'),
      );

      // Add authorization header properly
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          _selectedImage!.path,
        ),
      );

      var response = await request.send();
      final responseBody = await response.stream
          .bytesToString(); // Add this to read the response

      print(
          'Upload response: ${response.statusCode} - $responseBody'); // Debug logging

      if (response.statusCode == 200) {
        await fetchUserProfileData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      } else {
        print(
            'Failed to upload profile picture: ${response.statusCode} - $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update profile picture: ${responseBody}')),
        );
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error updating profile picture: ${e.toString()}')),
      );
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
                                    color: profilePictureUrl == null &&
                                            _selectedImage == null
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    image: _selectedImage != null
                                        ? DecorationImage(
                                            image: FileImage(_selectedImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : profilePictureUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    profilePictureUrl!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                  ),
                                  child: profilePictureUrl == null &&
                                          _selectedImage == null
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
                            onPressed: _showImageSourceModal,
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

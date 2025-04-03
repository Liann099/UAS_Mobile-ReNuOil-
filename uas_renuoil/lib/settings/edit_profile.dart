import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../generated/assets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Sample user data
  final Map<String, String> userData = {
    'name': 'Matt',
    'username': 'Create a unique username',
    'bio': 'write a bio about you',
    'userId': '9871235',
    'email': 'Matt123@gmail.com',
    'phone': '+62123456789',
    'gender': 'Men',
    'birthday': '29 February 1999',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar with back button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Symbols.arrow_back_ios_new, size: 24),
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
                  // Empty space to balance the back button
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile card with yellow background
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD358), // Yellow background
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Profile Picture
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // Profile image container
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: const DecorationImage(
                                    image: AssetImage(Assets.imagesAa),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            userData['name']!,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

                    // Profile Info Section
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        'Profile info',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    // Name Field
                    _buildProfileField(
                        'Name',
                        userData['name']!,
                        onTap: () {
                          // Handle name field tap
                        }
                    ),

                    // Username Field
                    _buildProfileField(
                        'Username',
                        userData['username']!,
                        textColor: Colors.grey,
                        onTap: () {
                          // Handle username field tap
                        }
                    ),

                    // Bio Field
                    _buildProfileField(
                        'Bio',
                        userData['bio']!,
                        textColor: Colors.grey,
                        onTap: () {
                          // Handle bio field tap
                        }
                    ),

                    const SizedBox(height: 10),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

                    // Personal Info Section
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        'Personal Info',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    // User ID Field
                    _buildProfileField(
                        'User ID',
                        userData['userId']!,
                        hasChevron: false,
                        hasClipboard: true,
                        onTap: () {
                          // Handle user ID tap
                        }
                    ),

                    // Email Field
                    _buildProfileField(
                        'E-mail',
                        userData['email']!,
                        onTap: () {
                          // Handle email field tap
                        }
                    ),

                    // Phone Number Field
                    _buildProfileField(
                        'Phone number',
                        userData['phone']!,
                        onTap: () {
                          // Handle phone field tap
                        }
                    ),

                    // Gender Field
                    _buildProfileField(
                        'Gender',
                        userData['gender']!,
                        onTap: () {
                          // Handle gender field tap
                        }
                    ),

                    // Birthday Field
                    _buildProfileField(
                        'Birthday',
                        userData['birthday']!,
                        onTap: () {
                          // Handle birthday field tap
                        }
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

                    // Delete Account Button
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/delete-account');
                          },
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

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build profile field items
  Widget _buildProfileField(
      String label,
      String value, {
        Color? textColor,
        bool hasChevron = true,
        bool hasClipboard = false,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            if (hasClipboard)
              const Icon(Icons.content_copy, size: 20)
            else if (hasChevron)
              const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}
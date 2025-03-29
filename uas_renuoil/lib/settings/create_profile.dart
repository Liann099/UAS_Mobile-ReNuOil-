import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                          color: const Color(0xFFFFD358), // Yellow background
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
                                color: Colors.white,
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/mascot.png'),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Name
                            const Text(
                              'Matt',
                              style: TextStyle(
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
                          // Action to change profile picture
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

                // Confirmed Information Section
                const Text(
                  'Matt\'s confirmed information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 20),

                // Email confirmed item
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: const Icon(
                        Icons.check,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Email address',
                      style: TextStyle(
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

                // Main heading
                const Text(
                  'It\'s time to create your profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 20),

                // Description
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

                // Create Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to profile creation or next step
                      Navigator.pushNamed(context, '/profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD358), // Yellow background
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
      ),
    );
  }
}
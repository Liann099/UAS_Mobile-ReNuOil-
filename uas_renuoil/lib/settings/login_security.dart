import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_svg/svg.dart';

class LoginSecurityScreen extends StatelessWidget {
  const LoginSecurityScreen({super.key});

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
                    child: const Icon(Icons.close, size: 28),
                  ),
                ),

                // Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    'Login & Security',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Login Section
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(color: Colors.grey, thickness: 0.5),

                // Password Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Last updated 2 days ago',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Update password action
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Security Card
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset(
                          Assets.iconsSecurityIcon
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Keeping your account secure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'We regularly review accounts to make sure they\'re secure as possible. We\'ll also let you know if there\'s more we can do to increase the security of your account.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'Learn about safety tips for ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to buyer safety tips
                            },
                            child: const Text(
                              'buyer',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          const Text(
                            ' or ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to seller safety tips
                            },
                            child: const Text(
                              'seller',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Account Section
                const SizedBox(height: 20),
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(color: Colors.grey, thickness: 0.5),

                // Deactivate Account Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Deactivate your account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Account deactivation action
                        },
                        child: const Text(
                          'Deactivate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
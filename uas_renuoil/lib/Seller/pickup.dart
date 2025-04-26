import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../generated/assets.dart';

import 'package:flutter_application_1/balance.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:flutter_application_1/Seller/sellerwithdraw.dart';
import 'package:flutter_application_1/Seller/pickup.dart';
import 'package:flutter_application_1/Seller/QRseller.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Seller/seller.dart';
import 'package:flutter_application_1/Seller/transaction_history.dart';


class PickupPage extends StatefulWidget {
  const PickupPage({super.key});

  @override
  State<PickupPage> createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage> {
  final storage = const FlutterSecureStorage();
  Future<List<Map<String, dynamic>>>? _futureUserData;
  final TextEditingController _amountController = TextEditingController();

  bool isLoading = true;
  Map<String, String> userData = {};
  String? profilePictureUrl;
  final Map<String, TextEditingController> controllers = {};
  final Map<String, bool> isEditing = {};

  Future<List<Map<String, dynamic>>> fetchUserData() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

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

        userData = {
          'username': userDataResponse['username'] ?? '',
          'bio': profileData['bio'] ?? '',
          'userId': userDataResponse['id'].toString(),
          'email': userDataResponse['email'] ?? '',
          'phone': profileData['phone_number'] ?? '',
          'gender': profileData['gender'] ?? '',
          'birthday': userDataResponse['date_of_birth'] ?? '',
        };
        profilePictureUrl = profileData['profile_picture'];

        for (var key in userData.keys) {
          controllers[key] = TextEditingController(text: userData[key]);
          isEditing[key] = false;
        }

        return [profileData, userDataResponse];
      } else {
        throw Exception(
            'Failed to load user data: ${userResponse.statusCode} or ${profileResponse.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Exception occurred: $e');
      rethrow;
    }
  }

  // Add this method to your _PickupPageState class
  Future<void> _submitPickupOrder() async {
    try {
      final String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      if (_amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the amount in liters')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/pick-up/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'pick_up_location': 'BMW Astra Serpong', // You can make this dynamic
          'drop_location': 'Nearest ReNuOil (@ Residence BSD City)',
          'liters': _amountController.text,
          'courier': 'gojek', // You can make this selectable
          'transport_mode': 'car', // You can make this selectable
        }),
      );

      if (response.statusCode == 201) {
        // Success - show success message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pickup order created successfully!')),
        );
        // Navigate to confirmation page or back to seller home
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DriverConfirmationPage()),
        ).then((_) {
          // This runs after the driver confirmation page is closed (popped)
          // Navigate back to seller home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SellerPage()),
          );
        });
      } else {
        // Handle error
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${errorData['detail'] ?? 'Failed to create pickup order'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureUserData = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD75E),
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _futureUserData == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureUserData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load profile'));
                }

                final profile = snapshot.data![0];
                final usernameData = snapshot.data![1];
                final profilePicture = profile['profile_picture'];
                final username = usernameData['username'] ?? 'Guest User';

                return SafeArea(
                  child: Column(
                    children: [
                      // Header with profile picture
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD75E),
                          borderRadius:
                              BorderRadius.vertical(bottom: Radius.zero),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfilePage()),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    profilePicture != null
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                NetworkImage(profilePicture),
                                          )
                                        : const CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.grey,
                                            child: Icon(Icons.person,
                                                size: 25, color: Colors.white),
                                          ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Edit Profile Here',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    const Icon(Icons.person,
                                        color: Colors.black54),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        color: const Color(0xFFFFD75E),
                        child: SizedBox(
                          height: 5,
                          child: Container(
                            color: const Color(0xFFFFD75E),
                          ),
                        ),
                      ),

                      Container(
                        color: const Color(0xFFFFD75E),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _NavIcon(
                              icon: 'assets/icons/iconhome.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SellerPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconbalance.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RnoPayApp()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconwithdraw.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SellerWithdrawPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconpickup.png',
                              active: true,
                              showUnderline: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PickupPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconqrcode.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const QRSellerPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconhistory.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransactionHistoryScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Map Area
                      Expanded(
                        child: Stack(
                          children: [
                            // Map placeholder - in a real app, replace with actual map widget
                            Image.asset(
                              'assets/images/map_with_route.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),

                      // Bottom Form Section
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Source Location
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: const [
                                  Icon(Icons.home, color: Colors.black),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'BMW Astra Serpong',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Destination Location
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey.shade200,
                                    child: Image.asset(
                                      'assets/images/handimage.png',
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Nearest ReNuOil (@ Residence BSD City)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Amount Field
                            Row(
                              children: [
                                const Text(
                                  'Amount  : ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 60,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Liters',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Oil Type
                            Row(
                              children: const [
                                Text(
                                  'Type of oil : ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '-',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Courier Selection
                            Row(
                              children: [
                                const Text(
                                  'Courier : ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.keyboard_arrow_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Request Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitPickupOrder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFD75E),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Request',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String icon;
  final bool active;
  final bool showUnderline;
  final VoidCallback? onTap;

  const _NavIcon({
    required this.icon,
    this.active = false,
    this.showUnderline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 55,
            height: 55,
          ),
          if (showUnderline && active)
            Container(
              margin: const EdgeInsets.only(top: 1),
              height: 1.5,
              width: 40,
              color: Colors.black,
            ),
        ],
      ),
    );
  }
}

class DriverConfirmationPage extends StatelessWidget {
  const DriverConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCD34D), // Matching yellow background
      body: GestureDetector(
        // This gesture detector covers the whole screen to handle any tap
        onTap: () {
          Navigator.pop(context); // Close this page on any tap
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Scooter Icon and Motion Lines
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Motion lines

                      // Scooter icon
                      Center(
                        child: Image.asset(
                          'assets/images/motor.png',
                          width: 300,
                          height: 200,
                        ),
                      ),
                    ],
                  ),

                  // You Got A Driver text
                  const Text(
                    'You Got A Driver!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Order number
                  const Text(
                    'Your order number is #1234',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Driver heading text
                  const Text(
                    'The driver is heading to your location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sit tight text
                  const Text(
                    'Sit tight and wait for your oil to be delivered.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

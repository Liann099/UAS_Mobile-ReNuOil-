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
import 'package:flutter_application_1/Seller/seller.dart';

class RnoPayApp extends StatefulWidget {
  const RnoPayApp({super.key});

  @override
  State<RnoPayApp> createState() => _RnoPayAppState();
}

class _RnoPayAppState extends State<RnoPayApp> {
  final storage = const FlutterSecureStorage();
  Future<List<Map<String, dynamic>>>? _futureUserData;

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
                              active: true,
                              showUnderline: true,
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
                                          const ProfilePage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      _buildDashboardTitle(),
                      _buildRnoPayBalanceCard(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDashboardTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        'RNO Pay Dashboard | ReNuOil',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRnoPayBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFFBD562),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildTopUpButton(),
            _buildCardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/RNO Pay.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.3),
      ),
    );
  }

  Widget _buildTopUpButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Top-up',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return const Positioned(
      top: 50,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RNO Pay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Rp0.00',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '5270 6206 5315 0372',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
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
            width: 60,
            height: 65,
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

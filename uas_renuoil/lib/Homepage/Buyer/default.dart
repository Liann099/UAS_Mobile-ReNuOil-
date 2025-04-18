import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

import 'package:flutter_application_1/balance.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:flutter_application_1/Seller/sellerwithdraw.dart';
import 'package:flutter_application_1/Seller/pickup.dart';
import 'package:flutter_application_1/Seller/QRseller.dart';
import 'package:flutter_application_1/Seller/ranking_list_page.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Seller/transaction_history.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_application_1/Seller/seller.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  final storage = const FlutterSecureStorage();
  Future<List<Map<String, dynamic>>>? _futureUserData;

  bool isLoading = true;
  Map<String, String> userData = {};
  String? profilePictureUrl;
  final Map<String, TextEditingController> controllers = {};
  final Map<String, bool> isEditing = {};
  bool isBuyer = true; // Added to track the switch state

  // Add your base URL here

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

  Map<String, dynamic>? leaderboardData;
  bool isLoadingLeaderboard = true;

  Future<void> fetchLeaderboardData() async {
    try {
      final String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/myrank/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          leaderboardData = json.decode(response.body);
          isLoadingLeaderboard = false;
        });
      } else {
        throw Exception('Failed to load leaderboard data');
      }
    } catch (e) {
      setState(() {
        isLoadingLeaderboard = false;
      });
      print('Error fetching leaderboard: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureUserData = fetchUserData();
    fetchLeaderboardData();
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
                              active: true,
                              showUnderline: true,
                              onTap: () {
                                // Already on home
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
                            _NavIcon(
                              icon: 'icons/trackfix.png',
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

                      const SizedBox(height: 20),

                      // Main content section
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF5F5F5),
                          child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Mascot container
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                      'images/mascot.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome!',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'I am Revivo, the mascot\nof ReNuOil',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Buyer switch
                                  Column(
                                    children: [
                                      Switch(
                                        value: isBuyer,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isBuyer = value;
                                          });
                                          if (!value) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SellerPage()),
                                            );
                                          }
                                        },
                                        activeColor: const Color(0xFFFFD75E),
                                        inactiveThumbColor:
                                            const Color(0xFFFFD75E),
                                        inactiveTrackColor:
                                            const Color.fromARGB(
                                                255, 251, 228, 157),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Buyer",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              // Eco Oil Banner
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  Assets.images2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Promotion section
                              const Text(
                                'Promotion',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD75E),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.card_giftcard,
                                        color: Colors.black87),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Promotion",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.chevron_right,
                                        color: Colors.black87),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Category section
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  // Cooking Oil button
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD75E),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Cooking Oil',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Motor Oil button
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD75E),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Motor Oil',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Industrial Oil button
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD75E),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Industrial Oil',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),

                              // Flash Sale Section
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Flash Sale ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.flash_on,
                                          color: Colors.amber[600],
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Ends in: '),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text('2',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        const Text(' : '),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text('15',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        const Text(' : '),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text('9',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Used Cooking Oil Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Used Cooking Oil',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'See All',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemBuilder: (context, i) =>
                                      _usedCookingOilCard(),
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Used Motor Oil Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Used Motor Oil',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'See All',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemBuilder: (context, i) =>
                                      _usedMotorOilCard(),
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Used Industrial Oil Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Used Industrial Oil',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'See All',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemBuilder: (context, i) =>
                                      _usedIndustrialOilCard(),
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _usedCookingOilCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(Assets.imagesProductMilk,
                height: 150, fit: BoxFit.cover),
            const SizedBox(height: 6),
            const Text(
              'Cooking Oil - Renewable',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usedMotorOilCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(Assets.imagesMotorOil, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 6),
            const Text(
              'Refined Motor Oil',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usedIndustrialOilCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(Assets.imagesIndustrialOil,
                height: 150, fit: BoxFit.cover),
            const SizedBox(height: 6),
            const Text(
              'InduraLube Oil',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
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
    super.key,
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
          const SizedBox(height: 0.5),
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

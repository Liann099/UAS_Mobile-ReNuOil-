import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../home.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/whitdraw.dart';
import 'package:flutter_application_1/Homepage/Buyer/balancebuy.dart';
import 'package:flutter_application_1/Homepage/Buyer/detail.dart';
import 'package:flutter_application_1/Homepage/Buyer/checkout.dart';
import 'package:flutter_application_1/Homepage/Buyer/track2.dart';
import 'package:flutter_application_1/Homepage/Buyer/review.dart';

import 'package:flutter_application_1/Seller/transaction_history.dart';
import 'package:flutter_application_1/balance.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_application_1/settings/profile.dart';

class Product {
  final int id;
  final String name;
  final String address;
  final double pricePerLiter;
  final String description;
  final String? picture;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.address,
    required this.pricePerLiter,
    required this.description,
    this.picture,
    required this.category,
  });
}

class BuyerHistoryScreen extends StatefulWidget {
  const BuyerHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BuyerHistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<BuyerHistoryScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryYellow = Color(0xFFFFD358);
  final storage = const FlutterSecureStorage();
  List<dynamic> _historyItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  static const Color borderColor = Color(0xFFEEEEEE);
  static const double defaultPadding = 16.0;
  Future<List<Map<String, dynamic>>>? _futureUserData;
  Map<String, String> userData = {};
  String? profilePictureUrl;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _futureUserData = fetchUserData();
    _fetchCheckoutHistory();
    _tabController =
        TabController(length: 1, vsync: this); // Changed to 1 tab only
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

        setState(() {
          userData = {
            'username': userDataResponse['username'] ?? '',
            'userId': userDataResponse['id'].toString(),
          };
          profilePictureUrl = profileData['profile_picture'];
        });

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

  Future<void> _fetchCheckoutHistory() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/checkout-history/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Checkout History Data: $data'); // Log the data
        setState(() {
          _historyItems = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildHistoryCard(Map<String, dynamic> history) {
    final items = history['items'] as List? ?? [];
    final date = DateTime.parse(history['created_at']);
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: primaryYellow,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Delivered',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) {
              // Get the photo URL for each item
              String? photoUrl;
              if (item != null) {
                // Handle case where photo_url might be in different formats
                if (item['photo_url'] is String) {
                  photoUrl = item['photo_url'];
                } else if (item['photo_url'] is Map) {
                  photoUrl =
                      item['photo_url']['url'] ?? item['photo_url']['path'];
                }
                // Prepend the base URL if the photoUrl is a relative path
                if (photoUrl != null && !photoUrl.startsWith('http')) {
                  photoUrl = '$baseUrl$photoUrl'; // Ensure baseUrl is defined
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: photoUrl != null
                          ? Image.network(
                              photoUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            )
                          : Image.asset(
                              'images/campuran.png',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item != null
                                ? item['product']?.toString() ??
                                    'Unknown Product'
                                : 'Unknown Product',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            "North Jakarta, Indonesia",
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildActionButton('Review', item),
                  ],
                ),
              );
            }).toList(),
            // Show grand total at the bottom
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    'Total: Rp${NumberFormat('#,###').format(double.parse(history['grand_total'].toString()))}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Set<int> reviewedProductIds = <int>{};
  Widget _buildActionButton(String text, Map<String, dynamic> item) {
    // Debug print to see the complete item structure
    print('Full item structure: ${jsonEncode(item)}');

    // Try different ways to extract the product ID
    final productId = item['id'] ??
        item['product_id'] ??
        (item['product'] is Map ? item['product']['id'] : null) ??
        (item['product_details'] is Map
            ? item['product_details']['id']
            : null) ??
        0;

    final bool isReviewed = reviewedProductIds.contains(productId);

    // Rest of your existing code for name and image URL...
    final productName = item['product'] is String
        ? item['product']
        : (item['product'] is Map ? item['product']['name'] : null) ??
            'Unknown Product';

    var photoUrl = item['photo_url'] ??
        (item['product'] is Map ? item['product']['photo_url'] : null);

    if (photoUrl is Map) {
      photoUrl = photoUrl['url'] ?? photoUrl['path'];
    }
    if (photoUrl != null && !photoUrl.startsWith('http')) {
      photoUrl = '$baseUrl$photoUrl';
    }

    return GestureDetector(
      onTap: isReviewed
          ? null
          : () async {
              final reviewSubmitted = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewPage(),
                  settings: RouteSettings(
                    arguments: {
                      'productId': productId,
                      'productName': productName,
                      'productPrice': item['price'] ?? 0,
                      'productImageUrl': photoUrl,
                      'productOrigin': "North Jakarta, Indonesia",
                    },
                  ),
                ),
              );

              if (reviewSubmitted == true) {
                setState(() {
                  reviewedProductIds.add(productId); // Mark as reviewed
                });
              }
            },
    child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: isReviewed ? Colors.grey[400] : primaryYellow,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          isReviewed ? 'Reviewed' : text,
          style: TextStyle(
            color: isReviewed ? Colors.white : Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Center(child: Text('Error: $_errorMessage'))
                          : _historyItems.isEmpty
                              ? const Center(
                                  child: Text('No purchase history found'))
                              : ListView.builder(
                                  itemCount: _historyItems.length,
                                  itemBuilder: (context, index) {
                                    return _buildHistoryCard(
                                        _historyItems[index]);
                                  },
                                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureUserData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Failed to load profile')),
          );
        }

        final profile = snapshot.data![0];
        final profilePicture = profile['profile_picture'];

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFD75E),
            borderRadius: BorderRadius.vertical(bottom: Radius.zero),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()),
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
                                  backgroundImage: NetworkImage(profilePicture),
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
                          const Icon(Icons.person, color: Colors.black54),
                        ],
                      ),
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
                                builder: (context) => const BuyerHomePage()),
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
                                builder: (context) => const RnoPayApps()),
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
                                    const SellerWithdrawsPage()),
                          );
                        },
                      ),
                      const SizedBox(width: 0.5),
                      _NavIcon(
                        icon: 'assets/icons/iconhistory.png',
                        active: true,
                        showUnderline: true,
                        onTap: () {},
                      ),
                      _NavIcon(
                        icon: 'icons/trackfix.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const OrderTrackingScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

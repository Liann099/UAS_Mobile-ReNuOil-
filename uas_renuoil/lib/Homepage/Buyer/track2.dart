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
import 'package:flutter_application_1/Homepage/Buyer/historybuyer.dart';

import 'package:flutter_application_1/Seller/transaction_history.dart';
import 'package:flutter_application_1/balance.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_application_1/settings/profile.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  // Constants for reuse
  static const Color primaryYellow = Color(0xFFFBD85D);
  static const Color borderColor = Color(0xFFEEEEEE);
  static const double defaultPadding = 16.0;

  // State variables
  final storage = const FlutterSecureStorage();
  bool _isLoading = true;
  String? _errorMessage;
  Future<List<Map<String, dynamic>>>? _futureUserData;
  Map<String, String> userData = {};
  String? profilePictureUrl;
  late TabController _tabController;
  bool _isTimelineVisible = false;
  Map<String, dynamic>? _trackingData;
  List<dynamic> _trackingList = [];
  List<bool> _isCardExpanded = [];

  @override
  void initState() {
    super.initState();
    _futureUserData = fetchUserData();
    _fetchTrackingData(); // Add this line
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTrackingData() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/tracker/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _trackingList = data;
          _isCardExpanded = List.filled(_trackingList.length, false);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load tracking data: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Exception occurred: $e');
      setState(() {
        _errorMessage = 'Failed to load tracking information';
        _isLoading = false;
      });
    }
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
            'address' : profileData['address'] ?? '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            _buildTitleSection(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _buildOrderList(),
            ),
          ],
        ),
      ),
    );
  }

  // Top header section with search bar and navigation
  Widget _buildTopHeader(BuildContext context) {
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BuyerHistoryScreen()),
                          );
                        },
                      ),
                      _NavIcon(
                        icon: 'icons/trackfix.png',
                        active: true,
                        showUnderline: true,
                        onTap: () {},
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

  // Page title section
  Widget _buildTitleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: const Text(
        'Track Your Order',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Order card with progress
  Widget _buildOrderList() {
    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: _trackingList.length,
      itemBuilder: (context, index) {
        final order = _trackingList[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCardExpanded[index] = !_isCardExpanded[index];
                });
              },
              child: _buildOrderCard(order, index),
            ),
            if (_isCardExpanded[index]) _buildTrackingTimeline(order, userData),
            const SizedBox(height: defaultPadding),
          ],
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    // Parse dates
    final fromDate = order['tanggal_from'] != null
        ? DateFormat('dd MMM, yy').format(DateTime.parse(order['tanggal_from']))
        : '-- ---, --';

    final toDate = order['tanggal_to'] != null
        ? DateFormat('dd MMM, yy').format(DateTime.parse(order['tanggal_to']))
        : '-- ---, --';

    // Parse items if they exist
    List<dynamic> items = [];
    if (order['items'] != null && order['items'].toString().isNotEmpty) {
      try {
        items = json.decode(order['items']);
      } catch (e) {
        print('Error parsing items: $e');
      }
    }

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${order['id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items.isNotEmpty
                        ? items.length > 1
                            ? '${items[0]['product']}, etc' // Display first two products
                            : items[0]['product'] ?? 'Multiple Product'
                        : 'Multiple Product',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'images/handimage.png', // Ganti path ini sesuai lokasi aset kamu
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.shopping_bag,
                            color: Colors.green[700]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fromDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (order['from_location']?.toString().toLowerCase() ==
                            'unknown')
                        ? 'North Jakarta'
                        : order['from_location']?.toString() ?? 'North Jakarta',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'estimate',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    toDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Home',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar with truck
          SizedBox(
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    // Start Circle (Yellow)
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: primaryYellow,
                        shape: BoxShape.circle,
                      ),
                    ),

                    // Progress Line
                    Expanded(
                      child: Container(
                        height: 4,
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 4,
                              color: primaryYellow,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // End Circle (Grey)
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),

                // Truck Image
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.45 - 40,
                  child: Image.asset(
                    'images/truck_delivery.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.scaleDown,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.local_shipping,
                        color: Colors.orange[700],
                        size: 24,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Show items if available
          // if (items.isNotEmpty) ...[
          //   const SizedBox(height: 16),
          //   ...items.map((item) => ListTile(
          //         leading: SizedBox(
          //           width: 40,
          //           height: 40,
          //           child: item['photo_url'] != null
          //               ? Image.network(
          //                   '$baseUrl${item['photo_url']}',
          //                   fit: BoxFit.cover,
          //                 )
          //               : const Icon(Icons.shopping_bag),
          //         ),
          //         title: Text(item['product'] ?? 'Product'),
          //         subtitle: Text(
          //             '${item['quantity']} x ${NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(double.tryParse(item['price_per_unit'] ?? '0') ?? 0)}'),
          //         trailing: Text(
          //           NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0)
          //               .format(double.tryParse(item['total'] ?? '0') ?? 0),
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       )),
          // ],
        ],
      ),
    );
  }

  // Order number and title with logo
  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${_trackingData?['id'] ?? '1946'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _trackingData?['from_location'] ?? 'Sholl Motor Oil',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),

        // Logo image
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/handimage.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.eco, color: Colors.green[700]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Origin and destination dates
// Origin and destination dates
  Widget _buildOrderDates() {
    // Parse dates with null safety
    final fromDate = _trackingData?['tanggal_from'] != null
        ? DateFormat('dd MMM, yy')
            .format(DateTime.parse(_trackingData!['tanggal_from']))
        : '21 Feb, 25';

    final toDate = _trackingData?['tanggal_to'] != null
        ? DateFormat('dd MMM, yy')
            .format(DateTime.parse(_trackingData!['tanggal_to']))
        : '24 Feb, 25';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fromDate, // Use the formatted date
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _trackingData?['from_location']?.toString() ?? 'North Jakarta',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'estimate',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
              ),
            ),
            Text(
              // Removed const since the value is dynamic
              toDate, // Use the formatted date
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Home',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  // Progress bar with truck
  Widget _buildProgressBar(BuildContext context) {
    // Calculate progress width - about 45% of available width based on the image
    final progressWidth = MediaQuery.of(context).size.width * 0.45;

    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Line
          Row(
            children: [
              // Start Circle (Yellow)
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: primaryYellow,
                  shape: BoxShape.circle,
                ),
              ),

              // Progress Line
              Expanded(
                child: Container(
                  height: 4,
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      Container(
                        width: progressWidth,
                        height: 4,
                        color: primaryYellow,
                      ),
                    ],
                  ),
                ),
              ),

              // End Circle (Grey)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          // Truck Image
          Positioned(
            left: progressWidth -
                40, // Adjusted to center truck on progress point
            child: Image.asset(
              'images/truck_delivery.png',
              width: 80,
              height: 80,
              fit: BoxFit.scaleDown,
              errorBuilder: (context, error, stackTrace) {
                // Only as fallback if image isn't found
                return Icon(
                  Icons.local_shipping,
                  color: Colors.orange[700],
                  size: 24,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Timeline section
  Widget _buildTrackingTimeline(
      Map<String, dynamic> order, Map<String, dynamic> userData) {
    final fromDate = order['tanggal_from'] != null
        ? DateFormat('dd MMM, yy').format(DateTime.parse(order['tanggal_from']))
        : '-- ---, --';

    final toDate = order['tanggal_to'] != null
        ? DateFormat('dd MMM, yy').format(DateTime.parse(order['tanggal_to']))
        : '-- ---, --';

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - dates and times
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTimelineDate(fromDate, '10:45 AM', true),
                  const SizedBox(height: 60),
                  _buildTimelineDate(fromDate, '7:00 PM', true),
                  const SizedBox(height: 60),
                  _buildTimelineDate(toDate, '-', false),
                  const SizedBox(height: 60),
                  _buildTimelineDate(toDate, '-', false),
                ],
              ),
            ),

            // Middle - timeline connector with dots
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: _buildContinuousTimeline(),
            ),

            // Right side - location info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineInfo('Drop Off', 'North Jakarta', true),
                  const SizedBox(height: 60),
                  _buildTimelineInfo('Sorting Center', 'DC Cakung', true),
                  const SizedBox(height: 60),
                  _buildTimelineInfo('Sorting Center', 'DC BSD', false),
                  const SizedBox(height: 60),
                  _buildTimelineInfo(
                      'Home', userData['address'] ?? 'Unknown Address', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Timeline date and time element
  Widget _buildTimelineDate(String date, String time, bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isCompleted ? Colors.black : Colors.grey[500],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.black : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // Timeline location info
  Widget _buildTimelineInfo(String title, String subtitle, bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isCompleted ? Colors.black : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.black87 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Continuous timeline with dots
  Widget _buildContinuousTimeline() {
    return Stack(
      children: [
        // Vertical line
        Positioned(
          left: 7,
          top: 8,
          bottom: 8,
          width: 2,
          child: Container(
            color: Colors.grey[300],
            child: Column(
              children: [
                Container(
                    height: 80, color: primaryYellow), // First segment (active)
                Expanded(child: Container()), // Remaining segment (inactive)
              ],
            ),
          ),
        ),

        // Dots
        Column(
          children: [
            _buildTimelineDot(true),
            const SizedBox(height: 60),
            _buildTimelineDot(true),
            const SizedBox(height: 60),
            _buildTimelineDot(false),
            const SizedBox(height: 60),
            _buildTimelineDot(false),
          ],
        ),
      ],
    );
  }

  // Individual timeline dot
  Widget _buildTimelineDot(bool isActive) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? primaryYellow : Colors.grey[400],
        shape: BoxShape.circle,
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

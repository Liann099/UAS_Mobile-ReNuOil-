import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';
import 'package:flutter/services.dart';
import '../generated/assets.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRegisterSelected = true;
  final storage = const FlutterSecureStorage();
  List<dynamic> allPromotions = [];
  List<dynamic> availablePromotions = [];
  List<dynamic> registeredPromotions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPromotions();
  }

  Future<void> _fetchPromotions() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final userResponse = await http.get(
        Uri.parse('$baseUrl/api/promotion/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debugging: Log the status code and response body
      debugPrint("Status code: ${userResponse.statusCode}");
      debugPrint("Response body: ${userResponse.body}");

      if (userResponse.statusCode == 200) {
        final data = json.decode(userResponse.body);
        setState(() {
          allPromotions = data;
          registeredPromotions = data
              .where((promo) => promo['status'].toLowerCase() == 'claimed')
              .toList();

          availablePromotions = data
              .where((promo) => promo['status'].toLowerCase() == 'unclaimed')
              .toList();

          isLoading = false;
        });
      } else {
        // Enhanced error handling based on status code
        if (userResponse.statusCode == 401) {
          throw Exception('Unauthorized: Invalid token');
        } else if (userResponse.statusCode == 404) {
          throw Exception('Promotions not found');
        } else {
          throw Exception(
              'Failed to load promotions: ${userResponse.statusCode}');
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      debugPrint("Error fetching promotions: $errorMessage");
    }
  }

  Future<void> _claimPromotion(String promoId) async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final userResponse = await http.post(
        Uri.parse('$baseUrl/api/promotion/$promoId/claim/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (userResponse.statusCode == 200 || userResponse.statusCode == 201) {
        // Refresh the promotions after claiming
        await _fetchPromotions();
      } else {
        throw Exception('Failed to claim promotion');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD358),
      appBar: AppBar(
        title: const Text(
          'Promotion',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: const Color(0xFFFFD358),
        centerTitle: true,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Tab selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD358),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildTabButton(
                          'Register Promotion',
                          isRegisterSelected,
                          () => setState(() => isRegisterSelected = true)),
                    ),
                    Expanded(
                      child: _buildTabButton(
                          'Available Promotion',
                          !isRegisterSelected,
                          () => setState(() => isRegisterSelected = false)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Main content
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : isRegisterSelected
                        ? _buildRegisterContent()
                        : _buildAvailableContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : Colors.transparent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: isSelected ? 4 : 0,
          shadowColor: Colors.black38,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: isSelected ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterContent() {
    if (registeredPromotions.isEmpty) {
      return const Center(
        child: Text('No registered promotions yet'),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the content
              children: [
                Image.asset(
                  Assets.imagesPromoCodeMascot,
                  height: 165,
                  fit: BoxFit.contain,
                ),
                for (var promo in registeredPromotions)
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center the image and code
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: promo['code']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Code copied to clipboard')),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            promo['picture'],
                            width: 325, // Set the width to 325
                            height: 170, // Set the height to 150
                            fit:
                                BoxFit.cover, // Fit the image within the bounds
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Code: ${promo['code']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildAvailableContent() {
    if (availablePromotions.isEmpty) {
      return const Center(
        child: Text('No available promotions'),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Title
            const Text(
              'Claim your promotion!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),

            // Promotion cards with claim buttons
            for (var promo in availablePromotions)
              Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          promo['picture'],
                          width: 325, // Set the width to 325
                          height: 170, // Set the height to 150
                          fit: BoxFit.cover, // Fit the image within the bounds
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () =>
                              _claimPromotion(promo['id'].toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Claim',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../generated/assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RankingListPage extends StatefulWidget {
  const RankingListPage({super.key});

  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> {
  List<dynamic> leaderboardData = [];
  Map<String, dynamic>? currentUserData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
    _fetchCurrentUserRank();
  }

  Future<void> _fetchLeaderboardData() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');

      print(
          'Attempting to fetch leaderboard with token: $token'); // Debug print

      final response = await http.get(
        Uri.parse('$baseUrl/api/rankings/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed data: $data'); // Debug print
        setState(() {
          leaderboardData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load leaderboard data: ${response.statusCode} - ${response.body}';
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error fetching leaderboard: $e'); // Debug print
      print(stackTrace); // Debug print
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCurrentUserRank() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');

      print('Current user token: $token'); // Debug print

      if (token == null) {
        setState(() {
          errorMessage = 'No authentication token found';
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/myrank/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          'MyRank response: ${response.statusCode} ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        setState(() {
          currentUserData = json.decode(response.body);
        });
      } else {
        print('Failed to fetch user rank: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching user rank: $e');
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD75E),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  // Title and back button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios, size: 20),
                      ),
                      const Expanded(
                        child: Text(
                          "Ranking List",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Empty widget for symmetry
                      const SizedBox(width: 20),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // User profile and ranking
                  Row(
                    children: [
                      // User profile picture
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: currentUserData?['profile_picture'] != null
                            ? ClipOval(
                                child: Image.network(
                                  currentUserData!['profile_picture'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, size: 40);
                                  },
                                ),
                              )
                            : const Icon(Icons.person, size: 40),
                      ),

                      const SizedBox(width: 16),

                      // User ranking details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Ranking : ${currentUserData?['rank'] ?? '-'}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  "Collected This Month : ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${currentUserData?['collected']?.toStringAsFixed(2) ?? '0.00'}L",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  "Last Month Bonus      : ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Rp${currentUserData?['last_month_bonus']?.toStringAsFixed(0) ?? '0'}",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ranking List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : leaderboardData.isEmpty
                            ? const Center(
                                child: Text('No ranking data available'))
                            : _buildLeaderboardList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        // Build list items from leaderboardData
        ...leaderboardData.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          final rank = index + 1;

          // Determine tier based on rank
          String tier;
          Color cardColor;
          String? badgeAsset;

          if (rank == 1) {
            tier = "Gold";
            cardColor = const Color(0xFFFFDC3E);
            badgeAsset = "assets/images/win1.png";
          } else if (rank == 2) {
            tier = "Silver";
            cardColor = const Color(0xFFE0E0E0);
            badgeAsset = "assets/images/win2.png";
          } else if (rank == 3) {
            tier = "Bronze";
            cardColor = const Color(0xFFFFDBC2);
            badgeAsset = "assets/images/win3.png";
          } else {
            tier = "Runner Up";
            cardColor = const Color(0xFFF5F5F5);
          }

          return _buildRankItem(
            rank: rank,
            name: user['username'] ?? 'Unknown',
            tier: tier,
            amount:
                "${user['collected_this_month']?.toStringAsFixed(2) ?? '0.00'}L",
            bonus: "Rp${user['last_month_bonus']?.toStringAsFixed(0) ?? '0'}",
            imageUrl: user['profile_picture'],
            cardColor: cardColor,
            badgeAsset: badgeAsset,
          );
        }).toList(),

        const SizedBox(height: 16),

        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Bottom text
        const Center(
          child: Text(
            "Keep collecting to get bonuses!",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem({
    required int rank,
    required String name,
    required String tier,
    required String amount,
    required String bonus,
    required String? imageUrl,
    Color cardColor = Colors.white,
    String? badgeAsset,
  }) {
    // Define rank number size based on position
    final double rankFontSize = rank <= 3 ? 55.0 : 40.0;
    final fontWeight = FontWeight.bold;

    // Define different card sizes based on rank
    final double verticalPadding = rank <= 3 ? 12.0 : 8.0;
    final double profileSize = rank <= 3 ? 60.0 : 50.0;
    final double nameFontSize = rank <= 3 ? 18.0 : 16.0;
    final double detailsFontSize = rank <= 3 ? 12.0 : 11.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank number positioned outside the card
          SizedBox(
            width: 40,
            child: Text(
              "$rank",
              style: TextStyle(
                fontSize: rankFontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Card with gradient background
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: rank <= 4
                        ? rank == 1
                            ? const LinearGradient(
                                colors: [Color(0xFFFFFFFF), Color(0XFFFFDC3E)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : rank == 2
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFFFF),
                                      Color(0xFFB5B5B5)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFFFF),
                                      Color(0xFFF07D35)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                        : null,
                    color: rank > 3 ? cardColor : null,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: verticalPadding),
                  margin: rank > 3 ? const EdgeInsets.only(right: 24) : null,
                  child: Row(
                    children: [
                      // User image with crown
                      SizedBox(
                        width: 70,
                        height: rank <= 3 ? 70 : 60,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: rank <= 3 ? 30 : 25,
                              backgroundColor: Colors.grey[300],
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          rank <= 3 ? 30 : 25),
                                      child: Image.network(
                                        imageUrl,
                                        width: rank <= 3 ? 60 : 50,
                                        height: rank <= 3 ? 60 : 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.person,
                                              size: rank <= 3 ? 30 : 25,
                                              color: Colors.white);
                                        },
                                      ),
                                    )
                                  : Icon(Icons.person,
                                      size: rank <= 3 ? 30 : 25,
                                      color: Colors.white),
                            ),

                            // Crown or badge image
                            if (badgeAsset != null)
                              Positioned(
                                top: -15,
                                child: Image.asset(
                                  badgeAsset,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // User details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: rank <= 3 ? 4 : 2),
                            Row(
                              children: [
                                Text(
                                  "Tier",
                                  style: TextStyle(
                                    fontSize: detailsFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ": $tier",
                                  style: TextStyle(
                                    fontSize: detailsFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: rank <= 3 ? 2 : 1),
                            Row(
                              children: [
                                Text(
                                  "Collected This Month",
                                  style: TextStyle(
                                    fontSize: detailsFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ": $amount",
                                  style: TextStyle(
                                    fontSize: detailsFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: rank <= 3 ? 2 : 1),
                            Row(
                              children: [
                                Text(
                                  "Last Month Bonus",
                                  style: TextStyle(
                                    fontSize: detailsFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ": $bonus",
                                  style: TextStyle(
                                    fontSize: detailsFontSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

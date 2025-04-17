import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:material_symbols_icons/symbols.dart';

class RankingListPage extends StatelessWidget {
  const RankingListPage({super.key});

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
                        backgroundImage:
                            const AssetImage('assets/images/user_circle.png'),
                        backgroundColor: Colors.white,
                      ),

                      const SizedBox(width: 16),

                      // User ranking details
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Ranking : -",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Collected This Month : ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "0.00L",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Last Month Bonus      : ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Rp0",
                                  style: TextStyle(
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
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  children: [
                    // Rank 1
                    _buildRankItem(
                      rank: 1,
                      name: "Udin Petot",
                      tier: "Gold",
                      amount: "199L",
                      bonus: "Rp1.990.000",
                      imageUrl: "assets/images/user1.png",
                      cardColor: const Color(0xFFFFDC3E),
                      badgeAsset: Assets.imagesWin1,
                      // hasUpArrow: false,
                      // hasDownArrow: false,
                    ),

                    // Rank 2
                    _buildRankItem(
                      rank: 2,
                      name: "Jessica G.",
                      tier: "Silver",
                      amount: "69L",
                      bonus: "Rp690.000",
                      imageUrl: "assets/images/user2.png",
                      cardColor: const Color(0xFFE0E0E0),
                      badgeAsset: Assets.imagesWin2,
                      // hasUpArrow: true,
                      // hasDownArrow: false,
                    ),

                    // Rank 3
                    _buildRankItem(
                      rank: 3,
                      name: "JaMal Boy",
                      tier: "Bronze",
                      amount: "35L",
                      bonus: "Rp350.000",
                      imageUrl: "assets/images/user3.png",
                      cardColor: const Color(0xFFFFDBC2),
                      badgeAsset: Assets.imagesWin3,
                      // hasUpArrow: false,
                      // hasDownArrow: true,
                    ),

                    // Rank 4
                    _buildRankItem(
                      rank: 4,
                      name: "Valentino Rossi",
                      tier: "Bronze",
                      amount: "26L",
                      bonus: "Rp260.000",
                      imageUrl: "assets/images/user4.png",
                      cardColor: const Color(0xFFFFDBC2),
                      // hasUpArrow: false,
                      // hasDownArrow: false,
                    ),

                    // Rank 5
                    _buildRankItem(
                      rank: 5,
                      name: "Billy North",
                      tier: "Runner Up",
                      amount: "13L",
                      bonus: "Rp130.000",
                      imageUrl: "assets/images/user5.png",
                      cardColor: const Color(0xFFF5F5F5),
                      // hasUpArrow: false,
                      // hasDownArrow: false,
                    ),

                    // Rank 6
                    _buildRankItem(
                      rank: 6,
                      name: "Vivian R Hoy",
                      tier: "Runner Up",
                      amount: "8L",
                      bonus: "Rp80.000",
                      imageUrl: "assets/images/user6.png",
                      cardColor: const Color(0xFFF5F5F5),
                      // hasUpArrow: false,
                      // hasDownArrow: false,
                    ),

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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem({
    required int rank,
    required String name,
    required String tier,
    required String amount,
    required String bonus,
    required String imageUrl,
    Color cardColor = Colors.white,
    String? badgeAsset,
    // bool hasUpArrow = false,
    // bool hasDownArrow = false,
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
                              backgroundImage: AssetImage(imageUrl),
                              onBackgroundImageError:
                                  (exception, stackTrace) {},
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(rank <= 3 ? 30 : 25),
                                child: Container(
                                  color: Colors.grey[300],
                                  width: rank <= 3 ? 60 : 50,
                                  height: rank <= 3 ? 60 : 50,
                                  child: Icon(Icons.person,
                                      size: rank <= 3 ? 30 : 25,
                                      color: Colors.white),
                                ),
                              ),
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

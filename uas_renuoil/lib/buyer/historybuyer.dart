import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Poppins',
      ),
      home: const BuyerHistoryScreen(),
    );
  }
}

class BuyerHistoryScreen extends StatefulWidget {
  const BuyerHistoryScreen({super.key});

  @override
  State<BuyerHistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<BuyerHistoryScreen> with SingleTickerProviderStateMixin {
  // Constants for reuse
  static const Color primaryYellow = Color(0xFFFFD358);
  static const Color borderColor = Color(0xFFEEEEEE);
  static const double defaultPadding = 16.0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Yellow header with search bar and navigation
          _buildHeader(context),

          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5), // Light gray background
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDeliveredOrderCard(context),
                  // Add more cards as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: primaryYellow,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    // Profile image
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile.jpg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    // Search text
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(0.7),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Start your search',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation menu
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 'Home', false),
                  _buildNavItem(Icons.account_balance_wallet_outlined, 'Balance', false),
                  _buildNavItem(Icons.swap_horizontal_circle_outlined, 'Withdraw', false),
                  _buildNavItem(Icons.history, 'History', true),
                  _buildNavItem(Icons.local_shipping_outlined, 'Track', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: primaryYellow,
        indicatorWeight: 3,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        tabs: const [
          Tab(text: 'Buy History'),
          Tab(text: 'Sell History'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.black : Colors.black.withOpacity(0.7),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.black.withOpacity(0.7),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        // Show black indicator line if this item is active
        if (isActive)
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
      ],
    );
  }

  Widget _buildDeliveredOrderCard(BuildContext context) {
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
            // Header row with trophy icon and "Delivered" text
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: primaryYellow,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'ReNuOil Collection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Delivered',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.9),
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product info row
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      Assets.imagesAa,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coconut Oil - Renewable',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'North Jakarta, Indonesia',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Text(
                              'Rp49.999/',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'liter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action buttons column
                  Column(
                    children: [
                      const Spacer(),
                      _buildActionButton('Review'),
                      const SizedBox(height: 8),
                      _buildActionButton('Buy Again'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellHistoryCard(BuildContext context) {
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
            // Header row with dropoff information
            Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: primaryYellow,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Used Oil Dropoff',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Oil dropoff details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Oil container image
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.opacity,
                      color: primaryYellow,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Dropoff details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Used Cooking Oil',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Feb 15, 2025 • 3.5L',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'DC Cakung, East Jakarta',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Text(
                            'Earned: ',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Rp22.190',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // View details button
                Container(
                  height: 64,
                  alignment: Alignment.bottomRight,
                  child: _buildActionButton('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryYellow,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
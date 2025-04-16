import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const OrderTrackingScreen(),
    );
  }
}

class OrderData {
  final String id;
  final String title;
  final String originDate;
  final String originLocation;
  final String destinationDate;
  final double progressValue; // Value between 0.0 and 1.0

  OrderData({
    required this.id,
    required this.title,
    required this.originDate,
    required this.originLocation,
    required this.destinationDate,
    required this.progressValue,
  });
}

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  // Constants for reuse
  static const Color primaryYellow = Color(0xFFFBD85D);
  static const Color borderColor = Color(0xFFEEEEEE);
  static const double defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    // Sample order data
    final List<OrderData> orders = [
      OrderData(
        id: '1945',
        title: 'Cooking Oil - Renewable',
        originDate: '20 Feb, 25',
        originLocation: 'Jakarta',
        destinationDate: '22 Feb, 25',
        progressValue: 0.35,
      ),
      OrderData(
        id: '1946',
        title: 'Shell Motor Oil',
        originDate: '21 Feb, 25',
        originLocation: 'Surabaya',
        destinationDate: '24 Feb, 25',
        progressValue: 0.35,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTitleSection(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(context, orders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header section with search bar and navigation
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: primaryYellow,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                // Profile Image with handimage.png
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset(
                        'assets/images/handimage.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image fails to load
                          return Icon(Icons.person, color: Colors.grey[600]);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.search, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Start your search',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('Home', Icons.home_outlined),
              _buildNavItem('Balance', Icons.account_balance_wallet_outlined),
              _buildNavItem('Withdraw', Icons.swap_horiz),
              _buildNavItem('History', Icons.history),
              _buildNavItem('Track', Icons.local_shipping_outlined, isSelected: true),
            ],
          ),
        ],
      ),
    );
  }

  // Title section
  Widget _buildTitleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
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

  // Single order card
  Widget _buildOrderCard(BuildContext context, OrderData order) {
    // Calculate available width for progress bar (accounting for padding and margins)
    final double availableWidth = MediaQuery.of(context).size.width - 32 - 32; // Subtract horizontal padding
    // Calculate the actual progress width based on available space
    final double progressWidth = (availableWidth - 32) * order.progressValue; // Subtract dot sizes
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Order details (ID, title, logo)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${order.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.title,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              // Logo with handimage.png
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          'assets/images/handimage.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image fails to load
                            return Icon(Icons.eco, color: Colors.green[700], size: 24);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'estimate',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Origin and destination
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.originDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.originLocation,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.destinationDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Progress bar with truck
          SizedBox(
            height: 40,
            child: Stack(
              clipBehavior: Clip.none,
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
                
                // Truck Icon - Positioned exactly as in the design
                Positioned(
                  left: progressWidth,
                  top: -20,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Base truck structure
                        Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.local_shipping,
                              color: Colors.grey[700],
                              size: 22,
                            ),
                          ),
                        ),
                        
                        // Orange front
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          width: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        
                        // Wheels
                        Positioned(
                          bottom: -4,
                          left: 6,
                          right: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigation item
  Widget _buildNavItem(String label, IconData icon, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.black : Colors.black54,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.black : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 24,
            height: 2,
            color: Colors.black,
          ),
      ],
    );
  }
}
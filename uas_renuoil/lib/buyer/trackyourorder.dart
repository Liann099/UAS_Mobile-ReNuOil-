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

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

  // Constants for reuse
  static const Color primaryYellow = Color(0xFFFBD85D);
  static const Color borderColor = Color(0xFFEEEEEE);
  static const double defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTitleSection(),
            _buildOrderCard(context),
            _buildTrackingTimeline(),
          ],
        ),
      ),
    );
  }

  // Header section with search bar and navigation
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        defaultPadding, 
        defaultPadding / 2, 
        defaultPadding, 
        defaultPadding
      ),
      decoration: const BoxDecoration(
        color: primaryYellow,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildNavigation(),
        ],
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Profile circle (usually an image)
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  'assets/images/profile.png',
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
    );
  }

  // Bottom navigation bar
  Widget _buildNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(Icons.home_outlined, 'Home'),
        _buildNavItem(Icons.account_balance_wallet_outlined, 'Balance'),
        _buildNavItem(Icons.sync_alt, 'Withdraw'),
        _buildNavItem(Icons.history, 'History'),
        _buildNavItem(Icons.local_shipping_outlined, 'Track', isSelected: true),
      ],
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
  Widget _buildOrderCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(defaultPadding),
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
      child: Column(
        children: [
          _buildOrderHeader(),
          const SizedBox(height: 16),
          _buildOrderDates(),
          const SizedBox(height: 24),
          _buildProgressBar(context),
        ],
      ),
    );
  }

  // Order number and title with logo
  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#1945',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Cooking Oil - Renewable',
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
                  // Fallback if image fails to load
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
  Widget _buildOrderDates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '20 Feb, 25',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Jakarta',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Text(
                  '23 Feb, 25',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'estimate',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
              ],
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
    );
  }

  // Progress bar with truck
  Widget _buildProgressBar(BuildContext context) {
    // Calculate progress width - 35% of available width
    final progressWidth = MediaQuery.of(context).size.width * 0.35;
    
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
          
          // Truck Icon
          Positioned(
            left: progressWidth,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.orange[700],
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Timeline section
  Widget _buildTrackingTimeline() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          defaultPadding, 
          0, 
          defaultPadding, 
          defaultPadding
        ),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildTimelineItem(
              date: '20 Feb, 25',
              time: '10:45 AM',
              title: 'Drop Off',
              subtitle: 'Silambat Jakarta',
              isCompleted: true,
            ),
            _buildTimelineConnector(isActive: true),
            _buildTimelineItem(
              date: '20 Feb, 25',
              time: '7:00 PM',
              title: 'Sorting Center',
              subtitle: 'DC Cakung',
              isCompleted: true,
            ),
            _buildTimelineConnector(isActive: false),
            _buildTimelineItem(
              date: '21 Feb, 25',
              time: '-',
              title: 'Sorting Center',
              subtitle: 'DC BSD',
              isCompleted: false,
            ),
            _buildTimelineConnector(isActive: false),
            _buildTimelineItem(
              date: '23 - 24 Feb, 25',
              time: '-',
              title: 'Home',
              subtitle: 'B Residence BSD City',
              isCompleted: false,
            ),
          ],
        ),
      ),
    );
  }

  // Navigation item
  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
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

  // Timeline item with date, status dot, and info
  Widget _buildTimelineItem({
    required String date,
    required String time,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time
        SizedBox(
          width: 100,
          child: Column(
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
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Status Dot
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isCompleted ? primaryYellow : Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Status Info
        Expanded(
          child: Column(
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
          ),
        ),
      ],
    );
  }

  // Connector line between timeline items
  Widget _buildTimelineConnector({required bool isActive}) {
    return Row(
      children: [
        const SizedBox(width: 108),
        Container(
          width: 2,
          height: 40,
          color: isActive ? primaryYellow : Colors.grey[300],
        ),
      ],
    );
  }
}
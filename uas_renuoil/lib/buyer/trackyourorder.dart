import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({Key? key}) : super(key: key);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrackOrderPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}

class TrackOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTitleSection(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isTimelineVisible = !_isTimelineVisible;
                        });
                      },
                      child: _buildOrderCard(context),
                    ),
                    if (_isTimelineVisible) _buildTrackingTimeline(),
                  ],
                ),
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
          // Profile circle
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
              '#1946',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Sholl Motor Oil',
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
  Widget _buildOrderDates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '21 Feb, 25',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Surabaya',
              style: TextStyle(
                fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
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
            const Text(
              '24 Feb, 25',
              style: TextStyle(
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
                fontWeight: FontWeight.w600
              ),
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
            left: progressWidth - 40, // Adjusted to center truck on progress point
            child: Image.asset(
                Assets.imagesTruckDelivery,
              width: 80,
              height: 80,
              fit: BoxFit.scaleDown,
              // Don't apply color tint to the image
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
  Widget _buildTrackingTimeline() {
    return Container(
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
                  _buildTimelineDate('21 Feb, 25', '10:45 AM', true),
                  const SizedBox(height: 60),
                  _buildTimelineDate('21 Feb, 25', '7:00 PM', true),
                  const SizedBox(height: 60),
                  _buildTimelineDate('22 Feb, 25', '-', false),
                  const SizedBox(height: 60),
                  _buildTimelineDate('24 - 25 Feb, 25', '-', false),
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
                  _buildTimelineInfo('Drop Off', 'Silambat Surabaya', true),
                  const SizedBox(height: 60),
                  _buildTimelineInfo('Sorting Center', 'DC Surabaya', true),
                  const SizedBox(height: 60),
                  _buildTimelineInfo('Sorting Center', 'DC BSD', false),
                  const SizedBox(height: 60),
                  _buildTimelineInfo('Home', 'B Residence BSD City', false),
                ],
              ),
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
                Container(height: 80, color: primaryYellow), // First segment (active)
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
import 'package:flutter/material.dart';

void main() {
  runApp(const RnoPayApp());
}

class RnoPayApp extends StatelessWidget {
  const RnoPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RnoPayDashboard(),
      theme: ThemeData(
        primaryColor: const Color(0xFFFBD562),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Add a clean, modern font
      ),
    );
  }
}

class RnoPayDashboard extends StatelessWidget {
  const RnoPayDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchAndQuickActionBar(),
            _buildDashboardTitle(),
            _buildRnoPayBalanceCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndQuickActionBar() {
    return Container(
      color: const Color(0xFFFBD562),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 10),
          _buildQuickActionIcons(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/images/startyoursearch.png'),
              radius: 15,
            ),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Start your search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIconWithLabel('assets/icons/iconhome.png', 'Home'),
        _buildIconWithLabel('assets/icons/iconbalance.png', 'Balance'),
        _buildIconWithLabel('assets/icons/iconwithdraw.png', 'Withdraw'),
        _buildIconWithLabel('assets/icons/iconpickup.png', 'Pick Up'),
        _buildIconWithLabel('assets/icons/iconqrcode.png', 'QR Code'),
        _buildIconWithLabel('assets/icons/iconhistory.png', 'History'),
      ],
    );
  }

  Widget _buildDashboardTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        'RNO Pay Dashboard | ReNuOil',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRnoPayBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFFBD562),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildTopUpButton(),
            _buildCardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/RNO Pay.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.3),
      ),
    );
  }

  Widget _buildTopUpButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Top-up',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return const Positioned(
      top: 50,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RNO Pay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Rp0.00',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '5270 6206 5315 0372',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithLabel(String iconPath, String label) {
    return Column(
      children: [
        Image.asset(iconPath, width: 24, height: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
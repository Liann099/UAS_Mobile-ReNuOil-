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
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'SF Pro Display',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFD358), // Yellow background color
        child: SafeArea(
          child: Column(
            children: [
              // Search bar with profile picture
              _buildSearchBar(context),
              
              // Navigation menu
              _buildNavigationMenu(context),
              
              // Content area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5), // Light gray background
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDeliveredOrder(context),
                        // Add more content here if needed
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Adaptive horizontal padding based on screen width
    final double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding, 
        vertical: 15
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.75,
        ),
        child: Row(
          children: [
            // Profile picture
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Search text
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      'Start your search',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildNavigationMenu(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 8 : 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFD358), // Yellow background color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', context),
          _buildNavItem(Icons.account_balance_wallet, 'Balance', context),
          _buildNavItem(Icons.swap_horiz, 'Withdraw', context),
          _buildNavItem(Icons.history, 'History', context, isSelected: true),
          _buildNavItem(Icons.local_shipping, 'Track', context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, BuildContext context, {bool isSelected = false}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    
    // Adjust icon and text size based on screen size
    final double iconSize = isSmallScreen ? 20 : 24;
    final double fontSize = isSmallScreen ? 10 : 12;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: iconSize,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: isSmallScreen ? 25 : 35,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
      ],
    );
  }

  Widget _buildDeliveredOrder(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final double cardPadding = isSmallScreen ? 12.0 : 16.0;
    final double imageWidth = isSmallScreen ? 80 : 100;
    final double imageHeight = isSmallScreen ? 90 : 110;
    final double buttonWidth = isSmallScreen ? 80 : 100;
    
    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.04), // Adaptive margin
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collection title with trophy icon
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'ReNuOil Collection',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Delivered',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Product details
          LayoutBuilder(
            builder: (context, constraints) {
              // For very small screens, use a stacked layout
              if (constraints.maxWidth < 350) {
                return Column(
                  children: [
                    // Product image centered
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/cookingoil.png',
                          width: imageWidth * 1.2,
                          height: imageHeight * 1.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Product info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coconut Oil - Renewable',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'North Jakarta, Indonesia',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp49.999/liter',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Buttons in a row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton('Review', Colors.amber, context),
                            const SizedBox(width: 8),
                            _buildButton('Buy Again', Colors.amber, context),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // For larger screens, use the original row layout with adaptive sizes
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/cookingoil.png',
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coconut Oil - Renewable',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'North Jakarta, Indonesia',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp49.999/liter',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Buttons column
                    Column(
                      children: [
                        _buildButton('Review', Colors.amber, context),
                        const SizedBox(height: 8),
                        _buildButton('Buy Again', Colors.amber, context),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color, BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final double buttonWidth = isSmallScreen ? 80 : 100;
    final double fontSize = isSmallScreen ? 12 : 14;
    
    return Container(
      width: buttonWidth,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
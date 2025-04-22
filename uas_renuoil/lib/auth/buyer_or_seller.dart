import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

class BuyerOrSellerScreen extends StatelessWidget {
  const BuyerOrSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesGroup306), // Use the same wave background image
            fit: BoxFit.cover,
          ),
          color: Color(0xFFFFB35A), // Orange background color
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button and logo
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      // Logo
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/mascot.png', // Replace with your actual logo asset
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer to push content downward
                const Spacer(flex: 2),

                // Title
                const Text(
                  'Buyer or Seller?',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    fontFamily: 'Poppins',
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  "Don't worry, you can change it later",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF444444),
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 40),

                // Option buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Buy option
                    _buildOptionButton(
                      context,
                      title: 'Buy',
                      icon: Icons.shopping_cart,
                      onTap: () {
                        // Handle buy option
                        print('Selected: Buy');
                        // Navigate to next screen or update user type
                        Navigator.pushNamed(context, '/how-did-you-know');
                      },
                    ),

                    // Sell option
                    _buildOptionButton(
                      context,
                      title: 'Sell',
                      icon: Icons.account_balance_wallet,
                      onTap: () {
                        // Handle sell option
                        print('Selected: Sell');
                        Navigator.pushNamed(context, '/seller-inquiry');
                        // Navigate to next screen or update user type
                      },
                    ),
                  ],
                ),

                // Spacer to push content to center
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7C0), Color(0xFFFFE259)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.black,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
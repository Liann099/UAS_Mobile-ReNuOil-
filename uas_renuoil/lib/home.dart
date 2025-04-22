import 'package:flutter/material.dart';

import 'generated/assets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRegisterSelected = true;

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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Tab selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(2.0),
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
                              () => setState(() => isRegisterSelected = true)
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton(
                          'Available Promotion',
                          !isRegisterSelected,
                              () => setState(() => isRegisterSelected = false)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),

              // Main content
              Expanded(
                child: isRegisterSelected ? _buildRegisterContent() : _buildAvailableContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
    // Content for Register Promotion tab (Image 1)
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Mascot and oil promotion - using your existing asset
          // If you have a combined image with both mascot and speech bubble
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Image.asset(
                  Assets.imagesPromoCodeMascot, // Replace with your actual combined image
                  height: 150,
                  fit: BoxFit.contain,
                ),
                // Promotional banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    Assets.images2,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Promotion code
          const Text(
            'Code: CK188OIL',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildAvailableContent() {
    // Content for Available Promotion tab (Image 2)
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

            // Multiple promo cards (using SafeArea to avoid overflow)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/2.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/aa.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/2.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/3.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
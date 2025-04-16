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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PromotionPage(),
    );
  }
}

class PromotionPage extends StatefulWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  bool isRegisterSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 16),
            _buildTabSelector(),
            const SizedBox(height: 20),
            _buildHeader(),
            _buildPromotionList(),
          ],
        ),
      ),
    );
  }

  // App Bar Widget
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFD54F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {},
          ),
          const Expanded(
            child: Text(
              'Promotion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance for back button
        ],
      ),
    );
  }

  // Tab Selector Widget
  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              title: 'Register Promotion',
              isSelected: isRegisterSelected,
              onTap: () => setState(() => isRegisterSelected = true),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              title: 'Available Promotion',
              isSelected: !isRegisterSelected,
              onTap: () => setState(() => isRegisterSelected = false),
            ),
          ),
        ],
      ),
    );
  }

  // Tab Button Widget
  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFD54F)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Claim your promotion!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Promotion List Widget
  Widget _buildPromotionList() {
    final List<String> promotionImages = [
      'assets/images/promo_30.png',
      'assets/images/EcoOilBanner.png',
      'assets/images/aa.png',
      'assets/images/banneroil.png',
    ];
    
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if in landscape or portrait mode
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          // Use grid for landscape, list for portrait
          return isLandscape 
              ? _buildGridPromotions(promotionImages, constraints)
              : _buildListPromotions(promotionImages, constraints);
        },
      ),
    );
  }
  
  // Grid view for landscape mode
  Widget _buildGridPromotions(List<String> images, BoxConstraints constraints) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildPromotionCard(images[index]);
      },
    );
  }
  
  // List view for portrait mode
  Widget _buildListPromotions(List<String> images, BoxConstraints constraints) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildPromotionCard(images[index]),
        );
      },
    );
  }

  // Responsive Promotion Card Widget
  Widget _buildPromotionCard(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AspectRatio(
          aspectRatio: 16 / 9, // Standard aspect ratio for responsive design
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
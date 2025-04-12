import 'package:flutter/material.dart';

class QRSellerPage extends StatelessWidget {
  const QRSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search Bar and Navigation Icons
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFD75E),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/user_circle.png'),
                          radius: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Start your search',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.black54),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Bottom Nav Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _NavIcon(icon: Icons.home, label: 'Home'),
                      _NavIcon(icon: Icons.account_balance_wallet, label: 'Balance'),
                      _NavIcon(icon: Icons.money_off, label: 'Withdraw'),
                      _NavIcon(icon: Icons.location_on, label: 'Pick Up'),
                      _NavIcon(icon: Icons.qr_code_scanner, label: 'QR Code', active: true),
                      _NavIcon(icon: Icons.history, label: 'History'),
                    ],
                  ),
                ],
              ),
            ),

            // Body Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Confirmation Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD75E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Checkmark icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirmation text
                          const Text(
                            'I hereby confirm that this is used oil(RNO) collected from my home',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Yes button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Yes',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Mascot and Speech Bubble
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Speech bubble
                        Positioned(
                          bottom: 80,
                          right: 20,
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD75E),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Please ensure that you collect the oil from your home or personal use',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Mascot image
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8FD5A6),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/mascot.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
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
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavIcon({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: active ? Colors.black : Colors.black45,
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.black45,
            fontSize: 10,
          ),
        ),
        if (active)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 20,
            height: 2,
            color: Colors.black,
          ),
      ],
    );
  }
}

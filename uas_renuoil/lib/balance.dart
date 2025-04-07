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
        primaryColor: Color(0xFFFBD562), // Kuning khas desain
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class RnoPayDashboard extends StatelessWidget {
  const RnoPayDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBD562), // Warna kuning
        elevation: 0,
        title: const Text(
          'RNO Pay Dashboard | ReNuOil',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/startyoursearch.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('Start your search'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // RNO Pay Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFFFE600), // Warna kuning background
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RNO Pay',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rp0.00',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Image.asset('assets/images/RNO Pay.png', height: 60),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Top-up Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBD562),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Top-up'),
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Navigation Bar
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBar(
                  backgroundColor: Color(0xFFFBD562),
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/icons/iconhome.png', width: 24),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/icons/iconbalance.png', width: 24),
                      label: 'Balance',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/icons/iconwithdraw.png', width: 24),
                      label: 'Withdraw',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/icons/iconpickup.png', width: 24),
                      label: 'Pick Up',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/icons/iconqrcode.png', width: 24),
                      label: 'QR Code',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/icons/iconhistory.png', width: 24),
                      label: 'History',
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

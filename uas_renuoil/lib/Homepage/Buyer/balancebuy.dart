import 'package:flutter/material.dart';

class BalanceBuyerPage extends StatelessWidget {
  const BalanceBuyerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD75E),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/user_circle.png'), // <-- Your profile image here
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Start your search',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.black54),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom nav icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _NavIcon(icon: Icons.home, label: 'Home'),
                      _NavIcon(icon: Icons.account_balance_wallet, label: 'Balance', active: true),
                      _NavIcon(icon: Icons.money_off_csred, label: 'Withdraw'),
                      _NavIcon(icon: Icons.history, label: 'History'),
                      _NavIcon(icon: Icons.local_shipping, label: 'Track'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("RNO Pay Dashboard | ReNuOil", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD75E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Top-up", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 10),
            Container(
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD75E),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.black),
                      SizedBox(width: 8),
                      Text("RNO Pay", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Rp0.00", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Text("5270 6206 5315 0372", style: TextStyle(letterSpacing: 2)), // Back end probably here
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/images/handimage.png'), 
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("Interesting promotions only for you!",
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/banneroil.png', 
                fit: BoxFit.cover,
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
        Icon(icon, color: active ? Colors.black : Colors.black45),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? Colors.black : Colors.black45)),
      ],
    );
  }
}

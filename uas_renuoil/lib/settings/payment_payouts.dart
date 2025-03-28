import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PaymentsPayoutsScreen extends StatelessWidget {
  const PaymentsPayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Symbols.arrow_back_ios_new, size: 24),
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Payments & Payouts',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Buyer Section
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Buyer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Payment methods
              PaymentListItem(
                icon: Icons.credit_card_outlined,
                title: 'Payment methods',
                onTap: () {
                  // Navigate to payment methods
                },
              ),

              // Credits & coupons
              PaymentListItem(
                icon: Icons.confirmation_number_outlined,
                title: 'Credits & coupons',
                onTap: () {
                  // Navigate to credits & coupons
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(color: Colors.grey, thickness: 0.5),
              ),

              // Seller Section
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                child: Text(
                  'Seller',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Payout Methods
              PaymentListItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Payout Methods',
                onTap: () {
                  // Navigate to payout methods
                },
              ),

              // Transaction history
              PaymentListItem(
                icon: Icons.receipt_long_outlined,
                title: 'Transaction history',
                onTap: () {
                  // Navigate to transaction history
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const PaymentListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}

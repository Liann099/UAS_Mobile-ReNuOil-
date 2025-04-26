import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_application_1/Seller/transaction_history.dart';
import 'package:flutter_application_1/Homepage/Buyer/historybuyer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                  'History',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Your buy history section
              HistoryListItem(
                title: 'Your buy history',
                subtitle: 'Click here to see your buy history',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BuyerHistoryScreen()),
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(color: Colors.grey, thickness: 0.5),
              ),

              // Load more (Sell history) section
              HistoryListItem(
                title: 'Load more',
                subtitle: 'Click here to see your sell history',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactionHistoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const HistoryListItem({
    super.key,
    required this.title,
    required this.subtitle,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}

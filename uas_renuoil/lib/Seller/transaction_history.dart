import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with search bar and navigation icons
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFD75E),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Column(
                children: [
                  // Search bar with avatar
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
                      children: [
                        CircleAvatar(
                          backgroundImage: const AssetImage('assets/images/profile.jpg'),
                          radius: 18,
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

                  // Bottom navigation icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavIcon(icon: Icons.home, label: 'Home'),
                      _NavIcon(icon: Icons.account_balance_wallet, label: 'Balance'),
                      _NavIcon(icon: Icons.money_off, label: 'Withdraw'),
                      _NavIcon(icon: Icons.location_on, label: 'Pick Up'),
                      _NavIcon(icon: Icons.qr_code_scanner, label: 'QR Code'),
                      _NavIcon(icon: Icons.history, label: 'History', active: true),
                    ],
                  ),
                ],
              ),
            ),

            // Tab bar for RNO Deposit and Withdrawal
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                tabs: const [
                  Tab(text: 'RNO Deposit'),
                  Tab(text: 'Withdrawal'),
                ],
              ),
            ),

            // "History" label
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              alignment: Alignment.center,
              child: const Text(
                'History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // RNO Deposit Tab
                  _buildDepositList(),

                  // Withdrawal Tab
                  _buildWithdrawalList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositList() {
    final depositList = [
      {
        'source': 'Cooking Oil',
        'status': 'Succes',
        'amount': '+Rp 49.000',
        'date': '2024-02-07 18:55',
      },
      {
        'source': 'Cashback',
        'status': 'Pending',
        'amount': '+Rp 27.000',
        'date': '2025-01-05 18:32',
      },
      {
        'source': 'Chef Oil',
        'status': 'Succes',
        'amount': '+Rp 37.000',
        'date': '2024-02-08 19:20',
      },
    ];

    return ListView.separated(
      itemCount: depositList.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
      itemBuilder: (context, index) {
        final item = depositList[index];
        return _buildTransactionItem(
          title: item['source']!,
          status: item['status']!,
          amount: item['amount']!,
          date: item['date']!,
        );
      },
    );
  }

  Widget _buildWithdrawalList() {
    final withdrawalList = [
      {
        'source': 'From BCA',
        'status': 'Succes',
        'amount': '+Rp 26.000',
        'date': '2024-02-07 18:55',
      },
      {
        'source': 'From OCBC',
        'status': 'Succes',
        'amount': '+Rp 47.000',
        'date': '2024-02-07 18:55',
      },
      {
        'source': 'From BCA',
        'status': 'Succes',
        'amount': '+Rp 38.000',
        'date': '2024-02-08 19:20',
      },
    ];

    return ListView.separated(
      itemCount: withdrawalList.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
      itemBuilder: (context, index) {
        final item = withdrawalList[index];
        return _buildTransactionItem(
          title: item['source']!,
          status: item['status']!,
          amount: item['amount']!,
          date: item['date']!,
        );
      },
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String status,
    required String amount,
    required String date,
  }) {
    // Parse date string to DateTime
    final DateTime dateTime = DateTime.parse(date);
    // Format the date to display
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.transparent,
      child: Row(
        children: [
          // Left section (source and date)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: status.toLowerCase() == 'succes' ? Colors.black : Colors.grey[800],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          // Right section (amount)
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
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
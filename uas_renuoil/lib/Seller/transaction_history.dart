import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../generated/assets.dart';

import 'package:flutter_application_1/balance.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:flutter_application_1/Seller/sellerwithdraw.dart';
import 'package:flutter_application_1/Seller/pickup.dart';
import 'package:flutter_application_1/Seller/QRseller.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Seller/seller.dart';

class Transaction {
  final String type;
  final double amount;
  final DateTime timestamp;
  final String status;
  final String? payment_method; // Add this field

  Transaction({
    required this.type,
    required this.amount,
    required this.timestamp,
    this.status = 'Success',
    this.payment_method,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['transaction_type'],
      amount: double.parse(json['amount'].toString()),
      timestamp: DateTime.parse(json['timestamp']),
      payment_method: json['payment_method'], // Add this line
    );
  }
}

class ApiService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<Transaction>> fetchTransactions(String type) async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/transaction-history/?type=$type'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('[ERROR] Exception occurred: $e');
      rethrow;
    }
  }
}

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final storage = const FlutterSecureStorage();
  Future<List<Map<String, dynamic>>>? _futureUserData;
  final ApiService _apiService = ApiService();
  Future<List<Transaction>>? _depositTransactions;
  Future<List<Transaction>>? _withdrawalTransactions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureUserData = fetchUserData();
    _loadTransactions();
  }

  void _loadTransactions() {
    _depositTransactions = _apiService.fetchTransactions('deposit');
    _withdrawalTransactions = _apiService.fetchTransactions('withdrawal');
  }

  Future<List<Map<String, dynamic>>> fetchUserData() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final userResponse = await http.get(
        Uri.parse('$baseUrl/auth/users/me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final profileResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (userResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final userDataResponse = json.decode(userResponse.body);
        final profileData = json.decode(profileResponse.body);
        return [profileData, userDataResponse];
      } else {
        throw Exception(
            'Failed to load user data: ${userResponse.statusCode} or ${profileResponse.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Exception occurred: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTransactionTitle(String type) {
    switch (type) {
      case 'deposit':
        return 'RNO Deposit';
      case 'withdrawal':
        return 'Bank Withdrawal';
      default:
        return type;
    }
  }

  Widget _buildTransactionItem({
    required String title,
    required String status,
    required String amount,
    required String date,
    String? payment_method,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.toLowerCase() == 'success'
                                ? Colors.black
                                : Colors.grey[800],
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
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (payment_method != null && payment_method.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Bank: $payment_method',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: amount.startsWith('-') ? Colors.black : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepositList() {
    return FutureBuilder<List<Transaction>>(
      future: _depositTransactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No deposit history found'));
        }

        return ListView.separated(
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          itemBuilder: (context, index) {
            final transaction = snapshot.data![index];
            final isWithdrawal = transaction.type == 'withdrawal';
            final payment_method =
                isWithdrawal ? transaction.payment_method : null;
            return _buildTransactionItem(
              title: _getTransactionTitle(transaction.type),
              status: transaction.status,
              amount: '+Rp ${transaction.amount.toStringAsFixed(0)}',
              payment_method: transaction
                  .payment_method, // Deposits don't need bank account

              date:
                  DateFormat('yyyy-MM-dd HH:mm').format(transaction.timestamp),
            );
          },
        );
      },
    );
  }

  Widget _buildWithdrawalList() {
    return FutureBuilder<List<Transaction>>(
      future: _withdrawalTransactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No withdrawal history found'));
        }

        return ListView.separated(
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          itemBuilder: (context, index) {
            final transaction = snapshot.data![index];
            return _buildTransactionItem(
              title: _getTransactionTitle(transaction.type),
              status: transaction.status,
              amount: '-Rp ${transaction.amount.toStringAsFixed(0)}',
              date:
                  DateFormat('yyyy-MM-dd HH:mm').format(transaction.timestamp),
              payment_method: transaction
                  .payment_method, // Show bank account for withdrawals
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD75E),
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _futureUserData == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureUserData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load profile'));
                }

                final profile = snapshot.data![0];
                final usernameData = snapshot.data![1];
                final profilePicture = profile['profile_picture'];

                return SafeArea(
                  child: Column(
                    children: [
                      // Header with profile picture
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD75E),
                          borderRadius:
                              BorderRadius.vertical(bottom: Radius.zero),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfilePage()),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
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
                                    profilePicture != null
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                NetworkImage(profilePicture),
                                          )
                                        : const CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.grey,
                                            child: Icon(Icons.person,
                                                size: 25, color: Colors.white),
                                          ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Edit Profile Here',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    const Icon(Icons.person,
                                        color: Colors.black54),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        color: const Color(0xFFFFD75E),
                        child: SizedBox(
                          height: 5,
                          child: Container(
                            color: const Color(0xFFFFD75E),
                          ),
                        ),
                      ),

                      Container(
                        color: const Color(0xFFFFD75E),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _NavIcon(
                              icon: 'assets/icons/iconhome.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SellerPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconbalance.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RnoPayApp()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconwithdraw.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SellerWithdrawPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconpickup.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PickupPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconqrcode.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const QRSellerPage()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconhistory.png',
                              active: true,
                              showUnderline: true,
                              onTap: () {
                                // Already on home
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

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
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
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
                );
              },
            ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String icon;
  final bool active;
  final bool showUnderline;
  final VoidCallback? onTap;

  const _NavIcon({
    required this.icon,
    this.active = false,
    this.showUnderline = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 55,
            height: 55,
          ),
          const SizedBox(height: 0.5),
          if (showUnderline && active)
            Container(
              margin: const EdgeInsets.only(top: 1),
              height: 1.5,
              width: 40,
              color: Colors.black,
            ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../generated/assets.dart';

import 'package:flutter_application_1/balance.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:flutter_application_1/Seller/sellerwithdraw.dart';
import 'package:flutter_application_1/Seller/pickup.dart';
import 'package:flutter_application_1/Seller/QRseller.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Seller/seller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/Seller/addbankaccount.dart';
import 'package:flutter_application_1/Seller/transaction_history.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/detail.dart';
import 'package:flutter_application_1/Homepage/Buyer/whitdraw.dart';
import 'package:flutter_application_1/Homepage/Buyer/balancebuy.dart';
import 'package:flutter_application_1/Homepage/Buyer/historybuyer.dart';
import 'package:flutter_application_1/Homepage/Buyer/track2.dart';

class SellerWithdrawsPage extends StatefulWidget {
  const SellerWithdrawsPage({super.key});

  @override
  State<SellerWithdrawsPage> createState() => _SellerWithdrawsPageState();
}

class _SellerWithdrawsPageState extends State<SellerWithdrawsPage> {
  double balance = 0.0; // Declare balance here

  List<BankAccount> _bankAccounts = [];
  bool _isLoadingBanks = true;

  final storage = const FlutterSecureStorage();
  Future<List<Map<String, dynamic>>>? _futureUserData;
  final TextEditingController _amountController = TextEditingController();
  bool _withdrawAll = false;
  int _selectedBankIndex = 0;

  bool isLoading = true;
  Map<String, String> userData = {};
  String? profilePictureUrl;
  final Map<String, TextEditingController> controllers = {};
  final Map<String, bool> isEditing = {};

  bool _validateAmount(String input) {
    if (input.isEmpty) return false;
    final amount = double.tryParse(input);
    if (amount == null) return false;
    return amount > 0 && amount <= balance;
  }

  // Helper function to get bank color based on bank name
  Color _getBankColor(String bankName) {
    switch (bankName.toLowerCase()) {
      case 'bca':
        return const Color(0xFFAFD2FF);
      case 'ocbc':
        return const Color(0xFFFFACAC);
      case 'mandiri':
        return const Color(0xFF00A651);
      case 'bni':
        return const Color(0xFFF58220);
      default:
        return Colors.grey[300]!;
    }
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

        print('User data: ${userResponse.body}');
        print('Balance from API: ${userDataResponse['balance']}');

        double parsedBalance =
            double.tryParse(userDataResponse['balance'].toString()) ?? 0.0;

        print('[DEBUG] Parsed Balance: $parsedBalance');

        setState(() {
          balance = parsedBalance;

          userData = {
            'username': userDataResponse['username'] ?? '',
            'bio': profileData['bio'] ?? '',
            'userId': userDataResponse['id'].toString(),
            'email': userDataResponse['email'] ?? '',
            'phone': profileData['phone_number'] ?? '',
            'gender': profileData['gender'] ?? '',
            'birthday': userDataResponse['date_of_birth'] ?? '',
            'balance': parsedBalance.toString(), // Corrected
            // Balance is set as a string to be used in the UI
          };
          profilePictureUrl = profileData['profile_picture'];
        });

        for (var key in userData.keys) {
          controllers[key] = TextEditingController(text: userData[key]);
          isEditing[key] = false;
        }

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

  Future<void> _fetchBankAccounts() async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      print(
          'Fetching bank accounts from: $baseUrl/api/bank-accounts/'); // Debug print

      final response = await http.get(
        Uri.parse('$baseUrl/api/bank-accounts/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Parsed data: $data'); // Debug print

        setState(() {
          _bankAccounts =
              data.map((json) => BankAccount.fromJson(json)).toList();
          _isLoadingBanks = false;
        });
      } else {
        throw Exception('Failed to load bank accounts');
      }
    } catch (e) {
      print('Error fetching bank accounts: $e'); // Debug print
      setState(() {
        _isLoadingBanks = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bank accounts: ${e.toString()}')),
      );
    }
  }

  Future<void> _withdrawBalance() async {
    try {
      // Validate amount
      if (_amountController.text.isEmpty && !_withdrawAll) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please enter an amount or select "Withdraw all balance"')),
        );
        return;
      }

      // Get the amount
      double amount;
      if (_withdrawAll) {
        amount = balance;
      } else {
        amount = double.tryParse(_amountController.text) ?? 0.0;
      }

      // Validate amount is positive and not zero
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Withdrawal amount must be greater than zero')),
        );
        return;
      }

      // Check if we have bank accounts
      if (_bankAccounts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a bank account first')),
        );
        return;
      }

      // Get selected bank account
      final selectedBank = _bankAccounts[_selectedBankIndex];
      final formattedAmount = NumberFormat('#,##0', 'id_ID').format(amount);

      // Show confirmation dialog
      bool confirm = await showDialog(
            context: context,
            builder: (context) => WithdrawalConfirmationDialog(
              bankName: selectedBank.bankName,
              accountNumber: selectedBank.accountNumber,
              accountHolder: selectedBank.accountHolder,
              amount: formattedAmount,
              onContinue: () {
                Navigator.of(context).pop(true); // Return true to confirm
              },
            ),
          ) ??
          false;

      if (!confirm) return; // User cancelled

      // Get token
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('No access token found');
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Make the API request
      final response = await http.post(
        Uri.parse('$baseUrl/api/withdraw/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': amount.toString(),
          'payment_method': selectedBank.bankName.toLowerCase(),
          'bank_account': selectedBank.accountNumber,
        }),
      );

      // Hide loading indicator
      Navigator.of(context).pop();

      // Handle response
      if (response.statusCode == 201) {
        // Success - refresh balance
        await fetchUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdrawal successful!')),
        );
      } else if (response.statusCode == 400) {
        // Check for insufficient balance error specifically
        final errorData = json.decode(response.body);
        if (errorData['error']?.contains('Insufficient balance') ?? false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Insufficient balance for withdrawal')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorData['error'] ?? 'Withdrawal failed')),
          );
        }
      } else {
        // Other errors
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Withdrawal failed')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureUserData = fetchUserData();
    _fetchBankAccounts();
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
                final username = usernameData['username'] ?? 'Guest User';

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
                                      builder: (context) =>
                                          const BuyerHomePage()),
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
                                      builder: (context) => const RnoPayApps()),
                                );
                              },
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconwithdraw.png',
                              active: true,
                              showUnderline: true,
                              onTap: () {},
                            ),
                            const SizedBox(width: 0.5),
                            _NavIcon(
                              icon: 'assets/icons/iconhistory.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BuyerHistoryScreen()),
                                );
                              },
                            ),
                            _NavIcon(
                              icon: 'assets/icons/trackfix.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderTrackingScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Body content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Funding Source',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Refund Balance Card
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD75E),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                          Icons.account_balance_wallet,
                                          size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Refund Balance',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Balance: Rp ${NumberFormat('#,##0.00', 'id_ID').format(balance)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Withdrawal Amount Section
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD75E),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Withdrawal Amount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Rp. ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: _amountController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: '0',
                                                hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Withdraw all balance',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Switch(
                                          value: _withdrawAll,
                                          onChanged: (value) {
                                            setState(() {
                                              _withdrawAll = value;
                                              if (value) {
                                                _amountController.text =
                                                    balance.toStringAsFixed(2);
                                              } else {
                                                _amountController.clear();
                                              }
                                            });
                                          },
                                          activeColor: Colors.white,
                                          activeTrackColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Select Bank Destination
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select Bank Destination',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Your withdrawal of funds will be transferred to the selected destination account',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Bank Cards
                                  _isLoadingBanks
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : _bankAccounts.isEmpty
                                          ? const Text(
                                              'No bank accounts found. Please add one.',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  for (int i = 0;
                                                      i < _bankAccounts.length;
                                                      i++) ...[
                                                    if (i > 0)
                                                      const Divider(
                                                          height: 1,
                                                          thickness: 1),
                                                    SizedBox(
                                                      // Added SizedBox here
                                                      height:
                                                          110, // Fixed height for all cards
                                                      child: _BankCard(
                                                        bankName:
                                                            _bankAccounts[i]
                                                                .bankName,
                                                        accountNumber:
                                                            _bankAccounts[i]
                                                                .accountNumber,
                                                        name: _bankAccounts[i]
                                                            .accountHolder,
                                                        color: _getBankColor(
                                                            _bankAccounts[i]
                                                                .bankName),
                                                        isSelected:
                                                            _selectedBankIndex ==
                                                                i,
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedBankIndex =
                                                                i;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                  const SizedBox(height: 12),

                                  // Add New Bank Account Button
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BankAccountDetailPage(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add New Bank Account',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Withdraw Balance Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          _withdrawBalance, // Updated to call our function
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFFD75E),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Withdraw Balance',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
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
                );
              },
            ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _BankCard({
    required this.bankName,
    required this.accountNumber,
    required this.name,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    accountNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Name: $name',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
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

class BankAccount {
  final int id;
  final String bankName;
  final String accountHolder;
  final String accountNumber;
  final String? branchCode;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountHolder,
    required this.accountNumber,
    this.branchCode,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      bankName:
          json['bank_name'], // Make sure these keys match your API response
      accountHolder: json['account_holder'],
      accountNumber: json['account_number'],
      branchCode: json['branch_code'],
    );
  }
  @override
  String toString() {
    return 'BankAccount{id: $id, bankName: $bankName, accountNumber: $accountNumber}';
  }
}

class WithdrawalConfirmationDialog extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String amount;
  final VoidCallback onContinue;

  const WithdrawalConfirmationDialog({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.amount,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        DateFormat('dd MMMM yyyy, HH.mm').format(now) + ' WIB';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Withdraw Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Bank Info
            Text(
              bankName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              accountNumber,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              accountHolder,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Withdrawal request in process',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Rp$amount',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Your balance withdrawal will be processed immediately',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD75E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

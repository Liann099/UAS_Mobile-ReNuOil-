import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class RnoTopUpPage extends StatefulWidget {
  const RnoTopUpPage({Key? key}) : super(key: key);

  @override
  State<RnoTopUpPage> createState() => _RnoTopUpPageState();
}

class _RnoTopUpPageState extends State<RnoTopUpPage> {
  String selectedAmount = '';
  final TextEditingController _amountController = TextEditingController();
  int? _selectedPaymentMethod;
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isLoadingBanks = false;
  List<BankAccount> _bankAccounts = [];
  double balance = 0.0; // Declare balance here
  Future<List<Map<String, dynamic>>>? _futureUserData;
  Map<String, String> userData = {};
  final Map<String, TextEditingController> controllers = {};
  final Map<String, bool> isEditing = {};

  @override
  void initState() {
    super.initState();
    _fetchBankAccounts();
    _futureUserData = fetchUserData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
    setState(() {
      _isLoadingBanks = true;
    });

    try {
      final String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/bank-accounts/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _bankAccounts =
              data.map((json) => BankAccount.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load bank accounts');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bank accounts: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingBanks = false;
      });
    }
  }

  Future<void> _submitTopUp() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the amount')),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      // Add null check for bank accounts list
      if (_bankAccounts.isEmpty) throw Exception('No bank accounts available');
      if (_selectedPaymentMethod! >= _bankAccounts.length) {
        throw Exception('Invalid payment method selected');
      }

      final selectedAccount = _bankAccounts[_selectedPaymentMethod!];

      final response = await http.post(
        Uri.parse('$baseUrl/api/topup/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'amount': _amountController.text,
          'payment_method': selectedAccount.bankName,
          'bank_account':
              '${selectedAccount.accountNumber} - ${selectedAccount.accountHolder}',
        }),
      );

      // More robust response handling
      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        final message =
            responseData['message']?.toString() ?? 'Top-up successful';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.of(context).pop(true);
      } else {
        final error = responseData['error']?.toString() ??
            responseData['message']?.toString() ??
            'Top-up failed with status ${response.statusCode}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAmountButton(String label) {
    final isSelected = selectedAmount == label;
    final amounts = {
      '100rb': 100000,
      '200rb': 200000,
      '500rb': 500000,
      '1jt': 1000000,
      '1,5jt': 1500000,
      'Isi penuh': 2000000,
    };

    return InkWell(
      onTap: () {
        setState(() {
          selectedAmount = label;
          int? value = amounts[label];
          if (value != null) {
            _amountController.text = value.toString();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.amber : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBankAccountCard(BankAccount account, int index) {
    final isSelected = _selectedPaymentMethod == index;
    Color cardColor;

    // Assign different colors based on bank
    if (account.bankName.toLowerCase().contains('bca')) {
      cardColor = Color(0xFFAFD2FF);
    } else if (account.bankName.toLowerCase().contains('ocbc')) {
      cardColor = Color(0xFFFFACAC);
    } else if (account.bankName.toLowerCase().contains('mandiri')) {
      cardColor = Color(0xFF00A651);
    } else if (account.bankName.toLowerCase().contains('bni')) {
      cardColor = Color(0xFFF58220);
    } else {
      cardColor = Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.bankName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      account.accountNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Name: ${account.accountHolder}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'RNO Top-up',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Max top-up card
// Max top-up card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/handimage.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Max. top-up',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'RNO Balance',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Rp2.000.000',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,##0', 'id_ID').format(balance)}', // Updated formatting
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'How much do you want to Top Up?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0',
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.grey.shade500, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.amber.shade700, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 8,
                children: [
                  _buildAmountButton('100rb'),
                  _buildAmountButton('200rb'),
                  _buildAmountButton('500rb'),
                  _buildAmountButton('1jt'),
                  _buildAmountButton('1,5jt'),
                  _buildAmountButton('Isi penuh'),
                ],
              ),

              const SizedBox(height: 24),
              const Text(
                'Which payment method do you want to use?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              if (_isLoadingBanks)
                const Center(child: CircularProgressIndicator())
              else if (_bankAccounts.isEmpty)
                const Text('No bank accounts available')
              else
                Column(
                  children: List.generate(
                    _bankAccounts.length,
                    (index) =>
                        _buildBankAccountCard(_bankAccounts[index], index),
                  ),
                ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitTopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
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
      bankName: json['bank_name'],
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

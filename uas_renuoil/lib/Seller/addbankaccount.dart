import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Account Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
      home: const BankAccountDetailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BankAccountDetailPage extends StatefulWidget {
  const BankAccountDetailPage({Key? key}) : super(key: key);

  @override
  State<BankAccountDetailPage> createState() => _BankAccountDetailPageState();
}

class _BankAccountDetailPageState extends State<BankAccountDetailPage> {
  bool isChecked = false;
  String? selectedBank;
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController branchCodeController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Bank account detail',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildDropdownField('Bank'),
                    const SizedBox(height: 24),
                    _buildTextField(
                        'Account holder\'s name', accountHolderController),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Bank code', null),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                              'Branch code', branchCodeController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Account number', accountNumberController),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(color: Colors.grey.shade400),
                            activeColor: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'By adding this bank account, I agree to transfer from bank account.',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ElevatedButton(
                        onPressed: _addBankAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD75E),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Add bank account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    List<String> banks = ['BCA', 'OCBC', 'MANDIRI', 'BNI'];

    return DropdownButtonFormField<String>(
      value: selectedBank,
      items: banks.map((String bank) {
        return DropdownMenuItem<String>(
          value: bank,
          child: Text(bank),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedBank = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Future<void> _addBankAccount() async {
    if (selectedBank == null ||
        accountHolderController.text.isEmpty ||
        accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final String? token = await storage.read(key: 'access_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User  not authenticated')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/bankacc/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'bank_name': selectedBank,
        'account_holder': accountHolderController.text,
        'account_number': accountNumberController.text,
        'branch_code': branchCodeController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank account added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add bank account: ${response.body}')),
      );
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // <-- Add this import
import 'package:material_symbols_icons/symbols.dart';
import '../constants.dart';
import 'package:flutter_application_1/auth/verify_email.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String emailText = '';

  final String apiUrl = "$baseUrl/api/request-password-reset/";
  // Replace "your-server.com" with your actual Django server URL

  @override
  void dispose() {
    // _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // Success
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email Sent'),
            content: const Text(
                'Please check your email for the verification code.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateNewPasswordScreen(emailUser: emailText)),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Error from server
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['error'] ?? 'Failed to send reset email')),
        );
      }
    } catch (e) {
      // Connection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Symbols.arrow_back_ios,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Back to login',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7E4A5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    'Please Enter Your Email Address To\nReceive a Verification Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter Email Address',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      print(value);
                      emailText = value;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(color: Colors.purple),
                          )
                        : const Text(
                            'Send',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF775873),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

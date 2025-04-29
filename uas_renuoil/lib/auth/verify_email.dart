import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import 'package:flutter/services.dart'; // Added for FilteringTextInputFormatter

class CreateNewPasswordScreen extends StatefulWidget {
  final String emailUser;

  const CreateNewPasswordScreen({
    super.key,
    required this.emailUser,
  });

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _passwordMatch = true;
  bool _passwordValid = true;

  void _resetPassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final otp = _otpControllers.map((c) => c.text).join();

    // Validate OTP
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate passwords match
    if (newPassword != confirmPassword) {
      setState(() {
        _passwordMatch = false;
      });
      return;
    } else {
      setState(() {
        _passwordMatch = true;
      });
    }

    // Validate password strength (add your own criteria)
    if (newPassword.length < 8) {
      setState(() {
        _passwordValid = false;
      });
      return;
    } else {
      setState(() {
        _passwordValid = true;
      });
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/verify-otp-reset-password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.emailUser,
          'otp': otp,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Password Reset'),
            content: const Text('Your password has been reset successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle errors
        final error =
            jsonDecode(response.body)['error'] ?? 'Unknown error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error occurred'),
          backgroundColor: Colors.red,
        ),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Back to verification',
                            style: TextStyle(
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

                  // Title
                  const Center(
                    child: Text(
                      'Create New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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

                  // Lock icon in circle
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E4A5), // Light yellow
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
                          Icons.lock_reset,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // OTP Description
                  const Center(
                    child: Text(
                      'Enter the 4-digit code sent to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // OTP input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => SizedBox(
                        width: 70,
                        height: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7E4A5).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                _otpFocusNodes[index + 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // New password label
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  // New password input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter New Password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),

                  if (!_passwordValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 8.0),
                      child: Text(
                        'Password must be at least 8 characters',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Confirm password label
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  // Confirm password input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),

                  if (!_passwordMatch)
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 8.0),
                      child: Text(
                        'Passwords do not match',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),

                  // Reset Password button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
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
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFF775873),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../constants.dart';


class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController(); // Added for current password
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureCurrentPassword = true;
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    // Validate inputs
    if (_newPasswordController.text.isEmpty ||
        _currentPasswordController.text.isEmpty) {
      _showErrorMessage('Please fill in all password fields');
      return;
    }

    if (_newPasswordController.text.length < 8) {
      _showErrorMessage('Password must be at least 8 characters');
      return;
    }

    // Optional: You can keep client-side confirmation check if you want
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorMessage('New passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('No access token found. Please login again.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/users/set_password/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "new_password": _newPasswordController.text,
          "current_password": _currentPasswordController.text,
        }),
      );

      if (response.statusCode == 204) {
        // Success - no content returned (204 No Content)
        _showSuccessMessage();
      } else {
        // Try to parse error message
        try {
          final errorData = json.decode(response.body);
          String errorMessage = 'Password reset failed';

          if (errorData.containsKey('current_password')) {
            errorMessage = errorData['current_password'].join('\n');
          } else if (errorData.containsKey('new_password')) {
            errorMessage = errorData['new_password'].join('\n');
          } else if (errorData.containsKey('detail')) {
            errorMessage = errorData['detail'];
          }

          _showErrorMessage(errorMessage);
        } catch (e) {
          _showErrorMessage('Password reset failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      _showErrorMessage('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your password has been reset successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          const Icon(Symbols.arrow_back_ios,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Back',
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
                          Icons.lock_open,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Description text
                  const Center(
                    child: Text(
                      'Your New Password Must be Different\nFrom Previously Used Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Current password label
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Current Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  // Current password input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrentPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter Current Password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCurrentPassword =
                                  !_obscureCurrentPassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 40),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF775873),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

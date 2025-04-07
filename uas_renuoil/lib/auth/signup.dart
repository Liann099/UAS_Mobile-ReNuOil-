import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  final String signupUrl = 'http://10.10.153.255:8000/auth/users/';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (!email.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    if (!_acceptTerms) {
      _showError('Please accept the terms and conditions');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          're_password': confirmPassword, // Tambahkan ini
        }),
      );

      if (response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = 'Registration failed';
        if (responseBody is Map && responseBody.containsKey('email')) {
          errorMessage = responseBody['email'][0];
        } else if (responseBody is Map &&
            responseBody.containsKey('username')) {
          errorMessage = responseBody['username'][0];
        }
        _showError(errorMessage);
        print("Signup Response: ${response.statusCode}");
        print("Signup Body: ${response.body}");
      }
    } catch (e) {
      _showError('Error connecting to server: ${e.toString()}');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Berhasil!",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: const Text(
            "Akun kamu berhasil dibuat.",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(context, '/address-input');
              },
              child: const Text(
                "Lanjut",
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Group 315.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Back to login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildInputField(
                      _usernameController, 'Username', Icons.person),
                  const SizedBox(height: 20),
                  _buildInputField(_emailController, 'Email', Icons.email,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildInputField(_passwordController, 'Password', Icons.lock,
                      obscureText: _obscurePassword, toggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  }),
                  const SizedBox(height: 20),
                  _buildInputField(_confirmPasswordController,
                      'Confirm Password', Icons.lock,
                      obscureText: _obscureConfirmPassword,
                      toggleVisibility: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  }),

                  const SizedBox(height: 20),

                  // Centered Terms Checkbox
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) =>
                                setState(() => _acceptTerms = value ?? false),
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.selected))
                                return Colors.white;
                              return Colors.white.withOpacity(0.5);
                            }),
                            checkColor: Colors.brown,
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.7)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'I accept the terms and privacy policy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                      ),
                      onPressed: _signUp,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF775873),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      VoidCallback? toggleVisibility}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade600.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: toggleVisibility != null
              ? IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white),
                  onPressed: toggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _resendCode() {
    // Clear current code fields
    for (var controller in _codeControllers) {
      controller.clear();
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code resent to your email'),
          backgroundColor: Color(0xFF775873),
        ),
      );
    });
  }

  void _verifyCode() {
    // Get the combined code
    final code = _codeControllers.map((c) => c.text).join();

    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API verification
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Email Verified'),
          content: const Text('Your email has been successfully verified.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/create-new-password');
                // Navigate to password reset or home screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
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
                          const Icon(Symbols.arrow_back_ios,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Back to login',
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
                      'Verify your Email',
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

                  // Email icon in circle
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
                          Icons.mail_outline,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Description text
                  const Center(
                    child: Text(
                      'Please Enter The 4 Digit Code Sent To\nYour Email',
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

                  // Code input boxes
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
                            controller: _codeControllers[index],
                            focusNode: _focusNodes[index],
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
                                _focusNodes[index + 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Resend code button
                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : _resendCode,
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyCode,
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
                              'Verify',
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

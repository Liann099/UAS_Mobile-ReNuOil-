import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

class MakePasscodeScreen extends StatefulWidget {
  const MakePasscodeScreen({super.key});

  @override
  State<MakePasscodeScreen> createState() => _MakePasscodeScreenState();
}

class _MakePasscodeScreenState extends State<MakePasscodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  String _passcode = '';
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() {
        _updatePasscode();
        if (_controllers[i].text.isNotEmpty && i < 5) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 6; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _updatePasscode() {
    setState(() {
      _passcode = _controllers.map((controller) => controller.text).join();
    });
  }

  Future<void> _savePasscode() async {
    if (_passcode.length != 6 || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.patch(
        Uri.parse('$baseUrl/auth/users/me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'passcode': _passcode,
        }),
      );

      if (response.statusCode == 200) {
        _showCongratulationsDialog();
      } else {
        throw Exception('Failed to update passcode: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _useFaceID() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Face ID authentication initiated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CongratulationsDialog(
          onContinue: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/group306.png'),
            fit: BoxFit.cover,
          ),
          color: Color(0xFFFFB35A),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/mascot.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    'Make a passcode',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Please enter 6 digit code',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF333333),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: _buildPasscodeField(index),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                const Center(
                  child: Text(
                    'Or Face ID',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _useFaceID,
                  child: Center(
                    child: Image.asset('assets/images/face_id.png', height: 50),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _passcode.length == 6 ? _savePasscode : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBFAF8),
                        foregroundColor: const Color(0xFFA27798),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: Color(0xFFA27798),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasscodeField(int index) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF1ECAD), // top
            Color(0xFFEFE470), // bottom
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}

class CongratulationsDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const CongratulationsDialog({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 400,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8E8A0), Color(0xFFFFF176)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A3250),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/mascot.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -15,
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: -30,
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8D6E63),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: onContinue,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFF8D6E63),
                    width: 4,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF8D6E63),
                    size: 30,
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

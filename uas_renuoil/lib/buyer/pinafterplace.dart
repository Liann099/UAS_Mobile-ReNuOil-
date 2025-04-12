import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PasscodeScreen(),
    );
  }
}

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({Key? key}) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _passcode = '';

  void _addDigit(String digit) {
    if (_passcode.length < 6) {
      setState(() {
        _passcode += digit;
      });
    }
  }

  void _removeDigit() {
    if (_passcode.isNotEmpty) {
      setState(() {
        _passcode = _passcode.substring(0, _passcode.length - 1);
      });
    }
  }

  Widget _buildPasscodeCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _passcode.length ? Colors.black : Colors.white,
            border: Border.all(
              color: index < _passcode.length ? Colors.black : Colors.grey,
              width: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumpadButton(String label, {VoidCallback? onPressed}) {
    if (label == '') {
      return const SizedBox(width: 80, height: 80);
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: label == '⌫' ? Colors.transparent : Colors.grey[200],
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        minimumSize: const Size(80, 80),
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: label == '⌫' ? 24 : 32,
          fontWeight: label == '⌫' ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['1', '2', '3']
              .map((digit) => _buildNumpadButton(digit, 
                  onPressed: () => _addDigit(digit)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['4', '5', '6']
              .map((digit) => _buildNumpadButton(digit, 
                  onPressed: () => _addDigit(digit)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['7', '8', '9']
              .map((digit) => _buildNumpadButton(digit, 
                  onPressed: () => _addDigit(digit)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumpadButton(''),
            _buildNumpadButton('0', onPressed: () => _addDigit('0')),
            _buildNumpadButton('⌫', onPressed: _removeDigit),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700), // Yellow background
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'Enter Passcode',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      'Please enter 6 digit code',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Passcode circles
                    _buildPasscodeCircles(),
                    const SizedBox(height: 32),

                    // Or Face ID section
                    const Text(
                      'Or',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const Text(
                      'Face ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.face,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Numpad
                    _buildNumpad(),
                    const SizedBox(height: 32),

                    // Confirm button
                    ElevatedButton(
                      onPressed: _passcode.length == 6 
                          ? () {
                              // Handle confirmation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Passcode entered: $_passcode'),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _passcode.length == 6 
                            ? Colors.black 
                            : Colors.grey,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
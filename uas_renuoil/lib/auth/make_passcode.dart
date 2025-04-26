import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_application_1/generated/assets.dart';

import 'package:local_auth/local_auth.dart';

class MakePasscodeScreen extends StatefulWidget {
  const MakePasscodeScreen({super.key});

  @override
  State<MakePasscodeScreen> createState() => _MakePasscodeScreenState();
}

class _MakePasscodeScreenState extends State<MakePasscodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  String _passcode = '';

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        _updatePasscode();

        if (_controllers[i].text.isNotEmpty && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
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

  void _useFaceID() async {
    final LocalAuthentication auth = LocalAuthentication();

    bool canAuthenticate =
        await auth.canCheckBiometrics || await auth.isDeviceSupported();

    if (!canAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available')),
      );

      return;
    }

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        _showCongratulationsDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesGroup306),
            fit: BoxFit.fill,
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
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
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
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Please enter 4 digit code',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF333333),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => _buildPasscodeField(index),
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
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _useFaceID,
                  child: Center(
                    child: Image.asset(Assets.imagesFaceId, height: 50),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _passcode.length == 4
                          ? () {
                              print('Passcode: $_passcode');

                              _showCongratulationsDialog();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFA27798),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 22,
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

  Widget _buildPasscodeField(int index) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7C0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            spreadRadius: 1,
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
            fontSize: 24,
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
        ),
      ),
    );
  }
}

class CongratulationsDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const CongratulationsDialog({super.key, required this.onContinue});

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
                    color: Color(0xFF8D6E63),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckoutWrapper(),
    );
  }
}

class CheckoutWrapper extends StatefulWidget {
  @override
  _CheckoutWrapperState createState() => _CheckoutWrapperState();
}

class _CheckoutWrapperState extends State<CheckoutWrapper> {
  final storage = FlutterSecureStorage();
  String? _userPasscode;

  @override
  void initState() {
    super.initState();
    _fetchUserPasscode();
  }

  Future<void> _fetchUserPasscode() async {
    // In a real app, you would fetch this from your backend
    // For demo purposes, we'll simulate fetching the passcode
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _userPasscode = "123456"; // Default passcode for demo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout Demo")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (_userPasscode == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Loading passcode...")),
              );
              return;
            }
            _showPinEntryScreen();
          },
          child: Text("Proceed to Checkout"),
        ),
      ),
    );
  }

  void _showPinEntryScreen({bool showError = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasscodeScreen(
          onPinVerified: (pin) {
            if (_userPasscode != null && pin == _userPasscode) {
              // Passcode matches, proceed with checkout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passcode verified! Proceeding...")),
              );
              // Here you would typically navigate to checkout confirmation
              Navigator.pop(context);
            } else {
              // Show the screen again with error message
              _showPinEntryScreen(showError: true);
            }
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order cancelled')),
            );
            Navigator.pop(context);
          },
          showError: showError,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class PasscodeScreen extends StatefulWidget {
  final Function(String)? onPinVerified;
  final VoidCallback? onCancel;
  final bool showError;

  const PasscodeScreen({
    Key? key,
    this.onPinVerified,
    this.onCancel,
    this.showError = false,
  }) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _passcode = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onPasscodeChanged(String value) {
    final RegExp digitRegExp = RegExp(r'^\d+$');
    if (value.isNotEmpty && !digitRegExp.hasMatch(value)) {
      return;
    }

    if (value.length > 6) {
      value = value.substring(0, 6);
      _controller.text = value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    }

    setState(() {
      _passcode = value;
    });

    if (_passcode.length == 6 && widget.onPinVerified != null) {
      widget.onPinVerified!(_passcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFD358),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                TextButton.icon(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 20),
                  label: const Text(
                    'Back to Checkout',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),

                const SizedBox(height: 100),

                // Title and subtitle
                const Center(
                  child: Text(
                    'Enter Passcode',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Please enter 6 digit code',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),

                // Error message if showError is true
                if (widget.showError)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Incorrect passcode. Please try again.',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),

                const SizedBox(height: 40),

                // Passcode circles
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: index < _passcode.length
                            ? Center(
                                child: Container(
                                  width: 16,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : null,
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 40),

                // Face ID option
                const Center(
                  child: Text(
                    'Or Face ID',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Face ID authentication requested')),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.fingerprint,
                        size: 40,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Confirm button
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _passcode.length == 6
                          ? () {
                              if (widget.onPinVerified != null) {
                                widget.onPinVerified!(_passcode);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        disabledBackgroundColor: Colors.white,
                        disabledForegroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Hidden text field for keyboard input
                Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _onPasscodeChanged,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
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
}

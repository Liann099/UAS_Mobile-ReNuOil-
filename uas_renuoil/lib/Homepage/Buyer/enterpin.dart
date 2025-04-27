import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckoutWrapper(),
    );
  }
}

class CheckoutWrapper extends StatefulWidget {
  const CheckoutWrapper({super.key});

  @override
  _CheckoutWrapperState createState() => _CheckoutWrapperState();
}

class _CheckoutWrapperState extends State<CheckoutWrapper> {
  final storage = FlutterSecureStorage();
  String? _userPasscode;
  late final LocalAuthentication _localAuth;
  bool _isAuthenticating = false; // Track authentication state
  bool _supportState = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _localAuth = LocalAuthentication();
    _checkDeviceSupport();
    _getAvailableBiometrics();
    _fetchUserPasscode();
  }

  Future<void> _checkDeviceSupport() async {
    bool isSupported = await _localAuth.isDeviceSupported();
    setState(() {
      _supportState = isSupported;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    final List<BiometricType> fetchedBiometrics =
        await _localAuth.getAvailableBiometrics();
    if (mounted) {
      setState(() {
        _availableBiometrics = fetchedBiometrics;
      });
    }
  }

  Future<void> _fetchUserPasscode() async {
    // In a real app, you would fetch this from your backend
    // For demo purposes, we'll simulate fetching the passcode
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _userPasscode = "123456"; // Default passcode for demo
    });
  }

  Future<void> _authenticateWithFingerprint() async {
    await _getAvailableBiometrics();
    
    if (!_supportState) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This device does not support biometric authentication')),
        );
      }
      return;
    }
    
    if (_availableBiometrics.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometrics available on this device')),
        );
      }
      return;
    }
    
    setState(() {
      _isAuthenticating = true;
    });
    
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (mounted) {
        if (didAuthenticate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fingerprint verified! Proceeding...")),
          );
          // Here you would typically navigate to checkout confirmation
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CheckoutPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication failed')),
          );
        }
      }
    } on PlatformException catch (e) {
      if (mounted) {
        if (e.code == 'NotEnrolled') {
          _showErrorDialog("No biometrics enrolled. Please set up fingerprint or face recognition in your device settings.");
        } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
          _showErrorDialog("Too many attempts. Biometric authentication is locked. Please use your passcode.");
          _showPinEntryScreen();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication error: ${e.message}')),
          );
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout Demo")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (_userPasscode == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Loading passcode...")),
              );
              return;
            }
            _showAuthenticationOptions();
          },
          child: const Text("Proceed to Checkout"),
        ),
      ),
    );
  }

  void _showAuthenticationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Use Fingerprint/Face ID'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  if (!_isAuthenticating) { // Prevent multiple authentications
                    await _authenticateWithFingerprint();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Enter Passcode'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showPinEntryScreen();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
                const SnackBar(content: Text("Passcode verified! Proceeding...")),
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
              const SnackBar(content: Text('Order cancelled')),
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
    super.key,
    this.onPinVerified,
    this.onCancel,
    this.showError = false,
  });

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              if (widget.onCancel != null) {
                                widget.onCancel!();
                              }
                              Navigator.pop(context);
                            },
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withOpacity(0.1),
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
                          if (widget.showError)
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Center(
                                child: Text(
                                  'Incorrect passcode. Please try again.',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                            ),
                          const Spacer(),
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
                                    borderRadius:
                                        BorderRadius.circular(8),
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
                          Opacity(
                            opacity: 0,
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
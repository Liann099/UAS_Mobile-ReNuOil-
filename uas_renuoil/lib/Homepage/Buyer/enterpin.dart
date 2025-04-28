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
  late final LocalAuthentication _localAuth;
  bool _isAuthenticating = false;
  bool _supportState = false;
  List<BiometricType> _availableBiometrics = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _localAuth = LocalAuthentication();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkDeviceSupport();
    await _getAvailableBiometrics();
    await _fetchUserPasscode();

    if (mounted) {
      setState(() {
        _initialized = true;
      });
      await _showBiometricConfirmation();
    }
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
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // _userPasscode = "123456"; // Default passcode for demo
    });
  }

  Future<void> _showBiometricConfirmation() async {
    if (!_supportState || _availableBiometrics.isEmpty) {
      // If device doesn't support biometrics or no biometrics available,
      // just show the pin entry screen directly
      _showPinEntryScreen();
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enable Biometric Authentication'),
        content: const Text(
            'Do you want to enable biometric authentication for faster access?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Not Now',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Enable',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _useBiometricAuth();
    } else {
      // If user chooses "Not Now", show the pin entry screen
      _showPinEntryScreen();
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

  Future<void> _useBiometricAuth() async {
    await _getAvailableBiometrics();

    if (!_supportState) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('This device does not support biometric authentication')));
      }
      _showPinEntryScreen();
      return;
    }

    if (_availableBiometrics.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No biometrics available on this device')),
        );
      }
      _showPinEntryScreen();
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
          biometricOnly: false,
        ),
      );

      if (mounted) {
        if (didAuthenticate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Fingerprint verified! Proceeding...")),
          );
          Navigator.of(context).pop(); // Close the passcode screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication failed')),
          );
          _showPinEntryScreen();
        }
      }
    } on PlatformException catch (e) {
      if (mounted) {
        if (e.code == 'NotEnrolled') {
          _showErrorDialog(
              "No biometrics enrolled. Please set up fingerprint or face recognition in your device settings.");
        } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
          _showErrorDialog(
              "Too many attempts. Biometric authentication is locked. Please use your passcode.");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication error: ${e.message}')),
          );
        }
      }
      _showPinEntryScreen();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      _showPinEntryScreen();
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passcode verified! Proceeding...")),
              );
              Navigator.pop(context);
            } else {
              _showPinEntryScreen(showError: true);
            }
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order cancelled')),
            );
            Navigator.pop(context);
          },
          onBiometricAuth: _useBiometricAuth,
          showError: showError,
        ),
        fullscreenDialog: true,
      ),
    ).then((_) {
      // Call biometric authentication after the PasscodeScreen is shown
      _useBiometricAuth();
    });
  }
}

class PasscodeScreen extends StatefulWidget {
  final Function(String)? onPinVerified;
  final VoidCallback? onCancel;
  final bool showError;
  final VoidCallback? onBiometricAuth;

  const PasscodeScreen({
    Key? key,
    this.onPinVerified,
    this.onCancel,
    this.onBiometricAuth,
    this.showError = false,
  }) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _passcode = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      setState(() {
        _keyboardVisible = true;
      });
      // Remove the call to widget.onBiometricAuth here
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

  void _toggleKeyboard() {
    if (_keyboardVisible) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
    setState(() {
      _keyboardVisible = !_keyboardVisible;
    });
  }

  void _showFingerprintInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fingerprint Authentication'),
        content: const Text(
          'Tap the fingerprint icon to authenticate using your fingerprint. '
          'Make sure your finger is clean and properly placed on the sensor.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              if (widget.onBiometricAuth != null) {
                widget.onBiometricAuth!();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD358),
      body: GestureDetector(
        onTap: _toggleKeyboard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 120),
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
                      GestureDetector(
                        onTap: _toggleKeyboard,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
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
                      ),
                      // const SizedBox(height: 40),
                      // const Center(
                      //   child: Text(
                      //     'Or Fingerprint',
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 16),
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: widget.onBiometricAuth,
                      //     child: Container(
                      //       width: 50,
                      //       height: 50,
                      //       child: Icon(
                      //         Icons.fingerprint,
                      //         size: 40,
                      //         color: Colors.black.withOpacity(0.7),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 16.0
                              : 30.0,
                          top: 20,
                        ),
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
                              ), // This was the missing closing parenthesis
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
    );
  }
}

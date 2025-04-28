import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_1/Seller/seller.dart';

import 'package:flutter_application_1/controller/google_login_cubit.dart';
import 'package:flutter_application_1/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => GoogleSignInCubit(),
        child: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = FlutterSecureStorage(); // <-- ini WAJIB
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    print('ini udh masuk');
    final url = Uri.parse('$baseUrl/auth/jwt/create/');

    try {
      print('ini yg email ${_emailController.text}');
      print('ini yg email ${_passwordController.text}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        // Successful login
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access'];
        final refreshToken = responseData['refresh'];

        await storage.write(key: 'access_token', value: accessToken);
        await storage.write(key: 'refresh_token', value: refreshToken);

        // Here you can store the tokens (using shared_preferences or secure_storage)
        // and navigate to the home screen
        print('Login successful! Access Token: $accessToken');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SellerPage()),
        );

        // Navigate to home screen (replace with your navigation logic)
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // Failed login
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Login failed';
        if (errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
          print('Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Network or server error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to handle Google sign-in authentication with backend
  Future<void> _handleGoogleSignIn(GoogleSignInAccount account) async {
    if (account == null) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // Get ID token from Google account
      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to get Google authentication token')),
        );
        return;
      }

      // Exchange Google token for your backend JWT token
      final url = Uri.parse('$baseUrl/auth/google/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access'];
        final refreshToken = responseData['refresh'];

        // Store tokens securely
        await storage.write(key: 'access_token', value: accessToken);
        await storage.write(key: 'refresh_token', value: refreshToken);

        // Get user info after successful login
        await _fetchUserInfo(accessToken);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google login successful!')),
        );

        // Navigate to homepage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SellerPage()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Google login failed';
        if (errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error with Google login: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  Future<void> _fetchUserInfo(String token) async {
    try {
      final userUrl = Uri.parse('$baseUrl/auth/users/me/');
      final response = await http.get(
        userUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        // Store user data
        await storage.write(key: 'user_id', value: userData['id'].toString());
        await storage.write(key: 'user_email', value: userData['email']);
        if (userData.containsKey('username')) {
          await storage.write(key: 'username', value: userData['username']);
        }
      }
    } catch (e) {
      print('Error fetching user info: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleSignInCubit, GoogleSignInAccount?>(
      builder: (context, account) {
        return Scaffold(
          // Add this line to prevent automatic resizing
          resizeToAvoidBottomInset: false,
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
              // Wrap with SingleChildScrollView to make scrollable
              SingleChildScrollView(
                child: SizedBox(
                  // Ensure the container takes at least full screen height
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Let's Go,",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.grey,
                                offset: Offset(2, 2),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Turning Used Oil into a Sustainable Future",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 100),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            hintText: "savetheworld@gmail.com",
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgot-password');
                            },
                            child: const Text("Forgot Password",
                                style: TextStyle(
                                    color: Color(0xFF1F3958),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF775873),
                                    ),
                                  )
                                : const Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Color(0xFF775873),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text("Or login with",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildSocialIcon("assets/images/fb.png", () {}),
                            const SizedBox(width: 10),
                            buildSocialIcon("assets/images/apple.png", () {}),
                            const SizedBox(width: 10),
                            buildSocialIcon(
                                "assets/images/google.png",
                                _isGoogleLoading
                                    ? null
                                    : () async {
                                        if (account == null) {
                                          // Sign in with Google
                                          await context
                                              .read<GoogleSignInCubit>()
                                              .signIn();

                                          // The BlocBuilder will rebuild with the new account
                                          // and next time this function runs, it will hit the else branch
                                        } else {
                                          // We already have a Google account, authenticate with backend
                                          await _handleGoogleSignIn(account);
                                        }
                                      }),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Add bottom padding to ensure there's space for keyboard
                        SizedBox(
                            height:
                                MediaQuery.of(context).viewInsets.bottom + 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isGoogleLoading)
                Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSocialIcon(String assetPath, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, height: 43),
    );
  }
}

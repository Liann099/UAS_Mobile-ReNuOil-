import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_application_1/controller/google_login_cubit.dart';

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
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = FlutterSecureStorage();
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$baseUrl/auth/jwt/create/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access'];
        final refreshToken = responseData['refresh'];

        await storage.write(key: 'access_token', value: accessToken);
        await storage.write(key: 'refresh_token', value: refreshToken);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to home screen...
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Login failed';
        if (errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              Center(
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
                          onPressed: _login,
                          child: const Text(
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
                          buildSocialIcon("assets/images/google.png", () {
                            if (account == null) {
                              context.read<GoogleSignInCubit>().signIn();
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      Text("Welcome, ${account.displayName}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            account.photoUrl ?? ''),
                                        radius: 30,
                                      ),
                                      Text(account.email),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<GoogleSignInCubit>()
                                              .signOut();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Sign out"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSocialIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, height: 43),
    );
  }
}

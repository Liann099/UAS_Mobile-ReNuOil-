import 'package:flutter/material.dart';

void main() {
  runApp(const WithdrawApp());
}

class WithdrawApp extends StatelessWidget {
  const WithdrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WithdrawScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Withdraw Balance",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Bank BCA",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "5147 8816 8499 7303",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Matt Cenna",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text(
                    "Withdrawal request in process",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "26 February 2025, 13:00 WIB",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: const TextSpan(
                      text: "Rp ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "50.000",
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Your balance withdrawal will be\nprocessed immediately",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBD562), // warna kuning
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                        shadowColor: Colors.black26,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

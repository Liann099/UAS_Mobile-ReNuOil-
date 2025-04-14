import 'package:flutter/material.dart';

void main() {
  runApp(const TransferApp());
}

class TransferApp extends StatelessWidget {
  const TransferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TransferScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // Mengatur alignment ke tengah
                  children: [
                    const Text(
                      "Transfer Balance",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center, // Menengahkan teks
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Bank BCA",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // Menengahkan teks
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "5147 8816 8499 7303",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // Menengahkan teks
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Matt Cenna",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center, // Menengahkan teks
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.check_circle, size: 80, color: Colors.green),
                    const SizedBox(height: 20),
                    const Text(
                      "Withdrawal request in process",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center, // Menengahkan teks
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "26 February 2025, 10:00 WIB",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center, // Menengahkan teks
                    ),
                    const SizedBox(height: 20),
                    Center( // Memastikan RichText juga ditengahkan
                      child: RichText(
                        textAlign: TextAlign.center, // Menengahkan teks dalam RichText
                        text: const TextSpan(
                          text: "Rp ",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "200.000",
                              style: TextStyle(
                                fontSize: 24, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Your Top Up balance will be\nprocessed immediately",
                      textAlign: TextAlign.center, // Sudah ditengahkan
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBD562),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
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
                          textAlign: TextAlign.center, // Menengahkan teks tombol
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
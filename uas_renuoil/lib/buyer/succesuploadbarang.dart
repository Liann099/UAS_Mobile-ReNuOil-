import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFFFD358), // Warna latar belakang kuning yang baru
      ),
      home: const SuccessUploadScreen(),
    );
  }
}

class SuccessUploadScreen extends StatelessWidget {
  const SuccessUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFD358), // Warna kuning baru sesuai permintaan
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD358), // Warna kuning baru
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar produk dalam container persegi dengan sudut melengkung
            Container(
              width: screenSize.width * 0.5, // 50% dari lebar layar
              height: screenSize.width * 0.5, // Aspek rasio 1:1
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/Refined Motor.png', // Ganti dengan path gambar produk Anda
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: 24), // Spasi antara gambar dan teks
            
            // Pesan sukses - text pertama
            const Text(
              'You have successfully',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Pesan sukses - text kedua 
            const Text(
              'uploaded this product!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
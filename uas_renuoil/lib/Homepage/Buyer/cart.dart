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
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const BasketScreen(),
    );
  }
}

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar saat ini
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      // Menggunakan SafeArea untuk menghindari notch/bezel perangkat
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Menentukan lebar container berdasarkan ukuran layar
              final containerWidth = isSmallScreen
                  ? screenSize.width * 0.95
                  : screenSize.width > 800
                      ? 600.0
                      : screenSize.width * 0.75;

              return Container(
                width: containerWidth,
                constraints: BoxConstraints(
                  maxHeight: screenSize.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // App Bar
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE0E0E0),
                            spreadRadius: 0,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          const Text(
                            'Basket',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 24),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF5F5F5),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store section
                              Row(
                                children: [
                                  const Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFFFFD700),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Lala's Collection",
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Product section - Gunakan Expanded agar dapat scroll jika konten terlalu banyak
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Checkbox
                                          const Padding(
                                            padding: EdgeInsets.only(top: 24),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Checkbox(
                                                value: true,
                                                onChanged: null,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          
                                          // Product image - Ukuran adaptif berdasarkan layar
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/cookingoil.png',
                                              width: isSmallScreen ? 60 : 70,
                                              height: isSmallScreen ? 60 : 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: isSmallScreen ? 60 : 70,
                                                  height: isSmallScreen ? 60 : 70,
                                                  color: Colors.grey[300],
                                                  child: const Icon(Icons.image_not_supported),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          
                                          // Product details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isSmallScreen ? 6 : 8,
                                                    vertical: isSmallScreen ? 4 : 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0F0F0),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Cooking Oil - Renewable",
                                                        style: TextStyle(
                                                          fontSize: isSmallScreen ? 12 : 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "Rp49.999",
                                                        style: TextStyle(
                                                          fontSize: isSmallScreen ? 12 : 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                
                                                // Quantity control - Wrap dengan FittedBox untuk layar kecil
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerRight,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (quantity > 1) {
                                                            setState(() {
                                                              quantity--;
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: Colors.grey),
                                                          ),
                                                          child: const Icon(Icons.remove, size: 14),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 6),
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFE0E0E0),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Text(
                                                          "$quantity",
                                                          style: TextStyle(
                                                            fontSize: isSmallScreen ? 12 : 14,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            quantity++;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: Colors.grey),
                                                          ),
                                                          child: const Icon(Icons.add, size: 14),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        "Liters",
                                                        style: TextStyle(
                                                          fontSize: isSmallScreen ? 12 : 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                    
                    // Checkout button
                    Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD54F),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 12 : 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
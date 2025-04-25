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
        scaffoldBackgroundColor: const Color(0xFFFFD358),
      ),
      home: const PromotionScreen(),
    );
  }
}

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  bool isRegisterSelected = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFD358),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFFFD358),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            onPressed: () {
              // Handle back button press
            },
          ),
          centerTitle: true,
          title: const Text(
            'Promotion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            // Spacer untuk keseimbangan layout
            const SizedBox(width: 48),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Toggle buttons
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD358),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Register Promotion Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegisterSelected = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isRegisterSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Register Promotion',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Available Promotion Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegisterSelected = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isRegisterSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Available Promotion',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Speech bubble dan mascot
                    SizedBox(
                      height: size.height * 0.18,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Speech bubble di atas mascot
                          Expanded(
                            child: Column(
                              children: [
                                // Speech bubble
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD358),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Input the code at the checkout session',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                
                                // Triangle untuk speech bubble
                                Align(
                                  alignment: Alignment.center,
                                  child: CustomPaint(
                                    size: const Size(20, 15),
                                    painter: TrianglePainter(color: const Color(0xFFFFD358)),
                                  ),
                                ),
                                
                                // Mascot dengan teal background
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF7FD4C1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/mascot.png',
                                        fit: BoxFit.contain,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Promotion banner - Responsive version
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Responsive banner container
                          Container(
                            width: double.infinity, // Full width
                            constraints: BoxConstraints(
                              maxHeight: size.height * 0.25, // 25% of screen height at most
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/aa.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Promotion code
                          const Text(
                            'Code: CK188OIL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          // Tambahkan spacer untuk mengisi ruang kosong
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter untuk triangle di speech bubble
class TrianglePainter extends CustomPainter {
  final Color color;
  
  TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final path = Path();
    
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
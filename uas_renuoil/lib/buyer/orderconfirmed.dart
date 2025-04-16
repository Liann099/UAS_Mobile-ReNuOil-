import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderConfirmationScreen(),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isMediumScreen = size.width < 600 && size.width >= 360;
    final isLargeScreen = size.width >= 600;
    
    // Ukuran yang menyesuaikan dengan layar
    final checkmarkSize = isSmallScreen ? 120.0 : isMediumScreen ? 150.0 : 180.0;
    final mascotSize = isSmallScreen ? 80.0 : isMediumScreen ? 100.0 : 120.0;
    final titleFontSize = isSmallScreen ? 20.0 : isMediumScreen ? 24.0 : 28.0;
    final normalTextSize = isSmallScreen ? 14.0 : isMediumScreen ? 16.0 : 18.0;
    final smallTextSize = isSmallScreen ? 12.0 : isMediumScreen ? 14.0 : 16.0;
    final buttonHeight = isSmallScreen ? 45.0 : isMediumScreen ? 50.0 : 55.0;
    final paddingSize = isSmallScreen ? 16.0 : isMediumScreen ? 24.0 : 32.0;
    final spacingHeight = isSmallScreen ? 16.0 : isMediumScreen ? 24.0 : 32.0;
    final smallSpacingHeight = isSmallScreen ? 6.0 : isMediumScreen ? 8.0 : 10.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFC107), // Yellow background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                maxWidth: isLargeScreen ? 600.0 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.all(paddingSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Green checkmark badge with error handling
                    SizedBox(
                      width: checkmarkSize,
                      height: checkmarkSize,
                      child: Image.asset(
                        'assets/images/vector.png',
                        width: checkmarkSize,
                        height: checkmarkSize,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: checkmarkSize,
                            height: checkmarkSize,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.check,
                              size: checkmarkSize * 0.6,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: spacingHeight),

                    // Order Confirmed Title
                    Text(
                      'Order Confirmed!',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: smallSpacingHeight),

                    // Order Number
                    Text(
                      'Your order number is #1945',
                      style: TextStyle(
                        fontSize: normalTextSize,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: smallSpacingHeight),

                    // Order Receipt Message
                    Text(
                      'You will receive the order receipt\nemail shortly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: smallTextSize,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: smallSpacingHeight),

                    // Thank You Message
                    Text(
                      'Thank you for shopping with us!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: smallTextSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacingHeight),

                    // Cute Character with error handling
                    SizedBox(
                      width: mascotSize,
                      height: mascotSize,
                      child: Image.asset(
                        'assets/images/mascot.png',
                        width: mascotSize,
                        height: mascotSize,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.emoji_emotions,
                            size: mascotSize * 0.8,
                            color: Colors.black54,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: spacingHeight),

                    // Container untuk tombol dengan lebar maksimum pada layar besar
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 400.0 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          // Back to Homepage Button
                          SizedBox(
                            height: buttonHeight,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add navigation logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Back to Homepage',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: smallTextSize,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: smallSpacingHeight),

                          // Track Your Order Button
                          SizedBox(
                            height: buttonHeight,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add order tracking logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Track Your Order',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: smallTextSize,
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
            ),
          ),
        ),
      ),
    );
  }
}
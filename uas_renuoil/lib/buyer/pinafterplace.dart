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
      home: PasscodeScreen(),
    );
  }
}

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({Key? key}) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _passcode = '';

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk adaptasi
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    // Ukuran yang adaptif berdasarkan layar
    final double circleDiameter = isSmallScreen ? 30 : 40;
    final double circleMargin = isSmallScreen ? 6 : 8;
    final double titleFontSize = isSmallScreen ? 20 : 24;
    final double defaultSpacing = isSmallScreen ? 24 : 32;
    final double smallSpacing = isSmallScreen ? 6 : 8;
    final double faceIdSize = isSmallScreen ? 60 : 80;
    final double buttonHeight = isSmallScreen ? 45 : 50;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700), // Yellow background
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size.height - 
                        MediaQuery.of(context).padding.top - 
                        kToolbarHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Enter Passcode',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: smallSpacing),
                        // Subtitle
                        const Text(
                          'Please enter 6 digit code',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: defaultSpacing),

                        // Passcode circles
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: circleMargin),
                                width: circleDiameter,
                                height: circleDiameter,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < _passcode.length ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: index < _passcode.length ? Colors.black : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: defaultSpacing),

                        // Or Face ID section
                        const Text(
                          'Or',
                          style: TextStyle(color: Colors.black87),
                        ),
                        const Text(
                          'Face ID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: smallSpacing),
                        SizedBox(
                          width: faceIdSize,
                          height: faceIdSize,
                          child: Image.asset(
                            'assets/images/face_id.png',
                            width: faceIdSize,
                            height: faceIdSize,
                            color: Colors.grey,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.face,
                                size: faceIdSize * 0.8,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: defaultSpacing),

                        // Confirm button
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: _passcode.length == 6 
                                ? () {
                                    // Handle confirmation
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Passcode entered: $_passcode'),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _passcode.length == 6 
                                  ? Colors.black 
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}
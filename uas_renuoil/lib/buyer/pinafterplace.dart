import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PasscodeScreen(),
    );
  }
}

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _passcode = '';

  void _onKeyTap(String value) {
    if (_passcode.length < 6) {
      setState(() {
        _passcode += value;
      });
    }
  }

  void _onBackspace() {
    if (_passcode.isNotEmpty) {
      setState(() {
        _passcode = _passcode.substring(0, _passcode.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    final double circleDiameter = isSmallScreen ? 30 : 40;
    final double circleMargin = isSmallScreen ? 6 : 8;
    final double titleFontSize = isSmallScreen ? 20 : 24;
    final double defaultSpacing = isSmallScreen ? 24 : 32;
    final double smallSpacing = isSmallScreen ? 6 : 8;
    final double faceIdSize = isSmallScreen ? 60 : 80;
    final double buttonHeight = isSmallScreen ? 45 : 50;

    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      body: SafeArea(
        child: Column(
          children: [
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
                        Text(
                          'Enter Passcode',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: smallSpacing),
                        const Text(
                          'Please enter 6 digit code',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: defaultSpacing),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                margin:
                                    EdgeInsets.symmetric(horizontal: circleMargin),
                                width: circleDiameter,
                                height: circleDiameter,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < _passcode.length
                                      ? Colors.black
                                      : Colors.white,
                                  border: Border.all(
                                    color: index < _passcode.length
                                        ? Colors.black
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: defaultSpacing),
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
                        buildKeyboard(),
                        SizedBox(height: defaultSpacing),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: _passcode.length == 6
                                ? () {
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

  Widget buildKeyboard() {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', '<']
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key == '') {
                return _buildKey('', enabled: false);
              } else if (key == '<') {
                return _buildKey(
                  '⌫',
                  onTap: _onBackspace,
                  isBackspace: true,
                );
              } else {
                return _buildKey(
                  key,
                  onTap: () => _onKeyTap(key),
                );
              }
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildKey(String label,
      {VoidCallback? onTap, bool enabled = true, bool isBackspace = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? Colors.black : Colors.grey.shade400,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isBackspace ? 22 : 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

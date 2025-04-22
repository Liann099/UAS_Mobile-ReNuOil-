import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

class HowDidYouKnowScreen extends StatefulWidget {
  const HowDidYouKnowScreen({super.key});

  @override
  State<HowDidYouKnowScreen> createState() => _HowDidYouKnowScreenState();
}

class _HowDidYouKnowScreenState extends State<HowDidYouKnowScreen> {
  String? _selectedOption;
  final List<String> _options = [
    'Social Media',
    'Family',
    'Friends',
    'Posters',
    'Others...',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesGroup306), // Use the same wave background image
            fit: BoxFit.cover,
          ),
          color: Color(0xFFFFB35A), // Orange background color
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button and logo
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      // Logo
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/mascot.png', // Replace with your actual logo asset
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Title
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'How did you',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                          fontFamily: 'Poppins',
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'know ReNuOil?',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                          fontFamily: 'Poppins',
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Radio button options
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: _buildRadioOption(option),
                    );
                  }).toList(),
                ),

                SizedBox(height: 16,),

                // Save button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedOption != null
                          ? () {
                        // Handle save action
                        print('Selected: $_selectedOption');
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/make-passcode');
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFA27798),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Color(0xFFA27798),
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
    );
  }

  Widget _buildRadioOption(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Custom radio button with gradient style
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _selectedOption == option
              // Selected gradient (orange center)
                  ? const RadialGradient(
                colors: [Color(0xFFFFAB40), Color(0xFFFFF9C4)],
                stops: [0.3, 1.0],
                center: Alignment.center,
                radius: 0.8,
              )
              // Unselected gradient (pale yellow)
                  : const RadialGradient(
                colors: [Color(0xFFF9F5D7), Color(0xFFF4E7B4)],
                stops: [0.3, 1.0],
                center: Alignment.center,
                radius: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text(
            option,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
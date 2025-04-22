import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/gestures.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitEnabled = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes to enable/disable submit button
    _feedbackController.addListener(_updateSubmitState);
  }

  @override
  void dispose() {
    _feedbackController.removeListener(_updateSubmitState);
    _feedbackController.dispose();
    super.dispose();
  }

  void _updateSubmitState() {
    setState(() {
      _isSubmitEnabled = _feedbackController.text.trim().isNotEmpty;
    });
  }

  void _submitFeedback() {
    if (_isSubmitEnabled) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFEDC63), // Lighter yellow at top
                    Colors.white, // Darker yellow at bottom
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '"Thank you for your feedback! We appreciate your input and are always looking to improve. Your thoughts help us grow! 💚"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    Assets.imagesMascot,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '~ ReNuOil Support Team ~',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Symbols.arrow_back_ios_new, size: 24),
                  ),
                ),
          
                // Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: Text(
                    'Share your feedback',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
          
                // Description text
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Thanks for sending us your ideas, issues, or appreciations. We can\'t respond individually, but we\'ll pass it on to the teams who are working to help make RenuOil better for everyone.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                ),
          
                // Help Center text with links
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'If you do have a specific question, or need help resolving a problem, you can visit our ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          )
                        ),
                        TextSpan(
                          text: 'Help Center',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            // Navigate to Help Center
                          },
                        ),
                        const TextSpan(
                          text: ' or ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          )
                        ),
                        TextSpan(
                          text: 'contact us',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            // Navigate to Contact page
                          },
                        ),
                        const TextSpan(
                          text: ' to connect with our support team.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
          
                const Divider(color: Colors.grey, thickness: 0.5),
          
                // Feedback section title
                const Padding(
                  padding: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  child: Text(
                    'What\'s your feedback about?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
          
                // Feedback text field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Please Type Here',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.all(16.0),
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
          
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 60,
                ),
          
                // Submit button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _isSubmitEnabled ? _submitFeedback : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.grey.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
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
}
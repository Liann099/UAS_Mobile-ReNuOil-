import 'package:flutter/material.dart';

class EmailBottomSheet extends StatefulWidget {
  final String initialEmail;
  final Function(String) onSave;

  const EmailBottomSheet({
    super.key,
    required this.initialEmail,
    required this.onSave,
  });

  @override
  State<EmailBottomSheet> createState() => _EmailBottomSheetState();
}

class _EmailBottomSheetState extends State<EmailBottomSheet> {
  late TextEditingController _emailController;
  final int _maxLength = 100;
  bool _isValidEmail = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _emailController.addListener(_onTextChanged);
    _validateEmail(_emailController.text);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _validateEmail(_emailController.text);
    });
  }

  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    _isValidEmail = emailRegex.hasMatch(email);
  }

  void _clearText() {
    _emailController.clear();
  }

  bool get _isSaveEnabled => _isValidEmail && _emailController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Change Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              // Balance icon with same width as back button
              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 16),

          // Description text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'To keep your account safe, make sure your email is active. We\'ll send a verification code to this email.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Email label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'New Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Email input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _emailController,
              maxLength: _maxLength,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFFD358)),
                ),
                suffixIcon: _emailController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.black),
                  onPressed: _clearText,
                )
                    : null,
                errorText: _emailController.text.isNotEmpty && !_isValidEmail
                    ? 'Please enter a valid email address'
                    : null,
              ),
              autofocus: true,
            ),
          ),

          // Character count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${_emailController.text.length}/$_maxLength',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Next button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaveEnabled
                    ? () {
                  widget.onSave(_emailController.text.trim());
                  Navigator.pop(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD358),
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
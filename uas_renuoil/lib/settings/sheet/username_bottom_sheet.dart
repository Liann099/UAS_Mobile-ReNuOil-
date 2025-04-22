import 'package:flutter/material.dart';

class UsernameBottomSheet extends StatefulWidget {
  final String initialUsername;
  final Function(String) onSave;

  const UsernameBottomSheet({
    super.key,
    required this.initialUsername,
    required this.onSave,
  });

  @override
  State<UsernameBottomSheet> createState() => _UsernameBottomSheetState();
}

class _UsernameBottomSheetState extends State<UsernameBottomSheet> {
  late TextEditingController _usernameController;
  final int _maxLength = 35;

  @override
  void initState() {
    super.initState();
    // Initialize with current username, but strip the "@" if present
    String initialText = widget.initialUsername;
    if (initialText.startsWith('@')) {
      initialText = initialText.substring(1);
    }
    if (initialText == 'Create a unique username') {
      initialText = '';
    }
    _usernameController = TextEditingController(text: initialText);
    _usernameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onTextChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clearText() {
    _usernameController.clear();
  }

  bool get _isSaveEnabled => _usernameController.text.trim().isNotEmpty;

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
                    'Add Username',
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

          // Username input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _usernameController,
              maxLength: _maxLength,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: 'Username',
                counterText: '',
                prefixText: '@',
                prefixStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
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
                suffixIcon: _usernameController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.black),
                  onPressed: _clearText,
                )
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
                  '${_usernameController.text.length}/$_maxLength',
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

          // Save button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaveEnabled
                    ? () {
                  // Save with @ prefix
                  widget.onSave('@${_usernameController.text.trim()}');
                  Navigator.pop(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD358),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
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

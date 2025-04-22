import 'package:flutter/material.dart';

class BioBottomSheet extends StatefulWidget {
  final String initialBio;
  final Function(String) onSave;

  const BioBottomSheet({
    super.key,
    required this.initialBio,
    required this.onSave,
  });

  @override
  State<BioBottomSheet> createState() => _BioBottomSheetState();
}

class _BioBottomSheetState extends State<BioBottomSheet> {
  late TextEditingController _bioController;
  final int _maxLength = 150;

  @override
  void initState() {
    super.initState();
    // Initialize with current bio
    String initialText = widget.initialBio;
    if (initialText == 'write a bio about you') {
      initialText = '';
    }
    _bioController = TextEditingController(text: initialText);
    _bioController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _bioController.removeListener(_onTextChanged);
    _bioController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clearText() {
    _bioController.clear();
  }

  bool get _isSaveEnabled => _bioController.text.trim().isNotEmpty;

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
                    'Add Bio',
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

          // Bio input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _bioController,
              maxLength: _maxLength,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: 'Bio',
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
                suffixIcon: _bioController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.black),
                  onPressed: _clearText,
                )
                    : null,
              ),
              autofocus: true,
              maxLines: 5,
              minLines: 3,
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
                  '${_bioController.text.length}/$_maxLength',
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
                  widget.onSave(_bioController.text.trim());
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
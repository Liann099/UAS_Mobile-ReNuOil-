import 'package:flutter/material.dart';

class GenderBottomSheet extends StatefulWidget {
  final String initialGender;
  final Function(String) onSave;

  const GenderBottomSheet({
    Key? key,
    required this.initialGender,
    required this.onSave,
  }) : super(key: key);

  @override
  State<GenderBottomSheet> createState() => _GenderBottomSheetState();
}

class _GenderBottomSheetState extends State<GenderBottomSheet> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                    'Select Gender',
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

          const SizedBox(height: 20),

          // Message about setting gender only once
          const Center(
            child: Text(
              'The gender can only be set once',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Gender selection icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Men option
              _buildGenderOption('Men'),

              // Woman option
              _buildGenderOption('Woman'),
            ],
          ),

          const SizedBox(height: 40),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_selectedGender);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD358),
                foregroundColor: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    final bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Color(0xFFFFD358) : Colors.black,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                gender == 'Men' ? Icons.man : Icons.woman,
                size: 50,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            gender,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xFFFFD358) : Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
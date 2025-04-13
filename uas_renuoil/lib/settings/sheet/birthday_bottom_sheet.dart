import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayBottomSheet extends StatefulWidget {
  final String initialBirthday;
  final Function(String) onSave;

  const BirthdayBottomSheet({
    Key? key,
    required this.initialBirthday,
    required this.onSave,
  }) : super(key: key);

  @override
  State<BirthdayBottomSheet> createState() => _BirthdayBottomSheetState();
}

class _BirthdayBottomSheetState extends State<BirthdayBottomSheet> {
  late DateTime _selectedDate;
  final DateFormat _dateFormat = DateFormat('d MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _initializeDate();
  }

  void _initializeDate() {
    try {
      // Try to parse the existing date
      _selectedDate = _dateFormat.parse(widget.initialBirthday);
    } catch (e) {
      // If parsing fails, default to 18 years ago
      _selectedDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFD358), // Header background color
              onPrimary: Colors.black, // Header text color
              onSurface: Colors.black, // Calendar text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String get _formattedDate => _dateFormat.format(_selectedDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                    'Change Birthday',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              // Empty space for balance
              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 24),

          // Description
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Make sure your date of birth is filled in correctly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Date label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Date field that opens picker when tapped
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formattedDate,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Save button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(_formattedDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD358),
                  foregroundColor: Colors.black,
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

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
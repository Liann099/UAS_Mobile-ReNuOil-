import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressInputScreen extends StatefulWidget {
  const AddressInputScreen({super.key});

  @override
  State<AddressInputScreen> createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  String? _selectedCountry;

  final List<String> _countries = [
    'Indonesia',
    'Singapore',
    'Malaysia',
    'Thailand',
    'Vietnam',
    'Philippines',
    'United States',
    'United Kingdom',
    'Australia',
    'Japan',
    'South Korea',
  ];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Country/Region',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 48), // For balance
                  ],
                ),
              ),

              // Country list with radio buttons
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: ListTile(
                        title: Text(
                          country,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: country,
                          groupValue: _selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCountry = country;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesGroup306),
          ),
          color: Color(0xFFFFB35A),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ListView(
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
                        width: 60,
                        height: 60,
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
                const Text(
                  'Enter your address',
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

                const SizedBox(height: 40),

                // Country/Region dropdown
                GestureDetector(
                  onTap: _showCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D503A).withOpacity(0.7), // Brown
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCountry ?? 'Country/Region',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // City input
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D503A).withOpacity(0.7), // Brown
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'City',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Address input
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D503A).withOpacity(0.7), // Brown
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _addressController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ZIP code input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500.withOpacity(0.7), // Grey for ZIP code
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _zipController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'ZIP code',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                const SizedBox(height: 40),

                // Save button
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement save functionality
                            if (_selectedCountry != null &&
                                _cityController.text.isNotEmpty &&
                                _addressController.text.isNotEmpty &&
                                _zipController.text.isNotEmpty) {
                              // Save address and navigate
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/buyer-or-seller');
                            } else {
                              // Show error
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
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

                      const SizedBox(height: 8),

                      // Extra info text
                      Text(
                        'You can change it later*',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80), // Extra space at bottom for scrolling
              ],
            ),
          ),
        ),
      ),
    );
  }
}
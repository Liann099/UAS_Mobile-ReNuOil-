import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

class AddPayoutMethodScreen extends StatefulWidget {
  const AddPayoutMethodScreen({super.key});

  @override
  State<AddPayoutMethodScreen> createState() => _AddPayoutMethodScreenState();
}

class _AddPayoutMethodScreenState extends State<AddPayoutMethodScreen> {
  String? _selectedPayoutMethod;
  String _selectedCountry = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                ),

                // Title
                const Text(
                  'Let\'s add a payout method',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                const Text(
                  'To start, let us know where you\'d like us to send your money.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 40),

                // Billing country/region label
                const Text(
                  'Billing country/region',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 12),

                // Dropdown for country selection
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        // Show country selection dialog/sheet
                        _showCountrySelectionSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Billing country/region',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedCountry,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Information text
                Text(
                  'This is where you opened your financial account.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 36),

                // Payment method selection
                const Text(
                  'How would you like to get paid?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 24),

                // GoPay Option
                _buildPaymentMethodOption(
                  title: 'GoPay',
                  logo: Image.asset(Assets.imagesSimpleIconsGojek, height: 50),
                  details: [
                    '1 business day',
                    'No fees',
                  ],
                  value: 'gopay',
                ),

                const Divider(),

                // OVO Option
                _buildPaymentMethodOption(
                  title: 'OVO',
                  logo: Image.asset(Assets.imagesArcticonsOvo, height: 50),
                  details: [
                    '1 business day',
                    'No fees',
                  ],
                  value: 'ovo',
                ),

                const Divider(),

                // Bank account Option
                _buildPaymentMethodOption(
                  title: 'Bank account in IDR',
                  logo: Image.asset(Assets.imagesBiBank, height: 50),
                  details: [
                    '3-5 business days',
                    'No fees',
                  ],
                  value: 'bank_idr',
                ),

                const Divider(),

                // PayPal Option
                _buildPaymentMethodOption(
                  title: 'PayPal in SGD',
                  logo: Image.asset(Assets.imagesLogosPaypal, height: 50),
                  details: [
                    '1 business day',
                    'PayPal fees may apply',
                  ],
                  value: 'paypal_sgd',
                ),

                const Divider(),

                const SizedBox(height: 20),

                // Continue Button (if needed)
                // SizedBox(
                //   width: double.infinity,
                //   height: 56,
                //   child: ElevatedButton(
                //     onPressed: _selectedPayoutMethod != null
                //         ? () => _proceedToNextStep(context)
                //         : null,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFFFFD358),
                //       foregroundColor: Colors.black,
                //       disabledBackgroundColor: const Color(0xFFFFD358).withOpacity(0.7),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     child: const Text(
                //       'Continue',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w600,
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required String title,
    required Widget logo,
    required List<String> details,
    required String value,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPayoutMethod = value;
        });

        // Navigate to the next step after selection
        Future.delayed(const Duration(milliseconds: 200), () {
          _proceedToNextStep(context);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            // Logo
            SizedBox(
              width: 50,
              height: 50,
              child: logo,
            ),

            const SizedBox(width: 16),

            // Title and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  ...details.map((detail) => Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          detail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            // Radio button
            Radio<String>(
              value: value,
              groupValue: _selectedPayoutMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPayoutMethod = newValue;
                });

                // Navigate to the next step after selection
                Future.delayed(const Duration(milliseconds: 200), () {
                  _proceedToNextStep(context);
                });
              },
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToNextStep(BuildContext context) {
    if (_selectedPayoutMethod != null) {
      // Navigate based on selected payment method
      switch (_selectedPayoutMethod) {
        case 'gopay':
        // Navigate to GoPay setup screen
        // Navigator.pushNamed(context, '/payout-gopay-setup');
          break;
        case 'ovo':
        // Navigate to OVO setup screen
        // Navigator.pushNamed(context, '/payout-ovo-setup');
          break;
        case 'bank_idr':
        // Navigate to Bank setup screen
        // Navigator.pushNamed(context, '/payout-bank-setup');
          break;
        case 'paypal_sgd':
        // Navigate to PayPal setup screen
        // Navigator.pushNamed(context, '/payout-paypal-setup');
          break;
      }

      // For now, simply print the selection (replace with actual navigation)
      print('Selected payout method: $_selectedPayoutMethod');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected: $_selectedPayoutMethod'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showCountrySelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CountrySelectionSheet(
        currentSelection: _selectedCountry,
        onCountrySelected: (country) {
          setState(() {
            _selectedCountry = country;
          });
        },
      ),
    );
  }

  // Payment method logos
  Widget _buildGoPayLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFF00880C), // GoPay green
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOVOLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.purple,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          'OVO',
          style: TextStyle(
            color: Colors.purple.shade800,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBankLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.account_balance,
        size: 30,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPayPalLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFF003087), // PayPal blue
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CountrySelectionSheet extends StatelessWidget {
  final String currentSelection;
  final Function(String) onCountrySelected;

  const CountrySelectionSheet({
    super.key,
    required this.currentSelection,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 16),
            child: Text(
              'Billing country/region',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          _buildCountryItem(
            context,
            country: 'Indonesia',
            flag: Text('🇮🇩', style: TextStyle(fontSize: 24)),
          ),
          const Divider(height: 1, thickness: 1),
          _buildCountryItem(
            context,
            country: 'Singapore',
            flag: Text('🇸🇬', style: TextStyle(fontSize: 24)),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildCountryItem(
      BuildContext context, {
        required String country,
        required Widget flag,
      }) {
    return InkWell(
      onTap: () {
        onCountrySelected(country);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // Flag
            SizedBox(
              width: 48,
              height: 32,
              child: flag,
            ),
            const SizedBox(width: 16),
            // Country name
            Text(
              country,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            // Radio button
            Radio<String>(
              value: country,
              groupValue: currentSelection,
              onChanged: (value) {
                if (value != null) {
                  onCountrySelected(value);
                  Navigator.pop(context);
                }
              },
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
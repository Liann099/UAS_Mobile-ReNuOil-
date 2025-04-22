import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

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
                    child: const Icon(Icons.arrow_back_ios, size: 24),
                  ),
                ),

                // Title
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                // Subtitle
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
                  child: Text(
                    'Connect a payment method to make transactions and receive funds.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Payment method cards
                PaymentMethodCard(
                  icon: Assets.imagesCreditCard,
                  title: 'Credit/Debit Card',
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(Assets.imagesGpn, height: 8),
                      const SizedBox(width: 8),
                      Image.asset(Assets.imagesAmericanExpress, height: 8),
                      const SizedBox(width: 8),
                      Image.asset(Assets.imagesLogosMastercard, height: 8),
                      const SizedBox(width: 8),
                      Image.asset(Assets.imagesVisa, height: 8),
                    ],
                  ),
                  onTap: () {
                    // Navigate to credit/debit card setup
                  },
                ),

                const SizedBox(height: 16),

                PaymentMethodCard(
                  icon: Assets.imagesDigitalPayment,
                  title: 'Digital Payment',
                  onTap: () {
                    // Navigate to digital payment setup
                  },
                ),

                const SizedBox(height: 16),

                PaymentMethodCard(
                  icon: Assets.imagesBtc,
                  title: 'Bitcoin',
                  iconColor: Colors.orange,
                  onTap: () {
                    // Navigate to Bitcoin setup
                  },
                ),

                const SizedBox(height: 32),

                // Add payment method button
                Center(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        _showPaymentMethodSelector(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Add payment method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Divider(color: Colors.grey, thickness: 0.5),
                ),

                // Safety information section
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          color: Colors.red, size: 30),
                      const SizedBox(height: 16),
                      const Text(
                        'Make all payments through RNO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'Always pay and communicate through RNO to ensure you\'re protected under our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: ', '),
                            TextSpan(
                              text: 'Payments Terms of Service',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ', cancellation and other safeguards',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Learn more',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return PaymentMethodSelector();
      },
    );
  }
}

class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pay with',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          _buildPaymentOption(
            'GoPay',
            Assets.imagesSimpleIconsGojek, // Make sure to add this asset
            'gopay',
          ),
          const Divider(),
          _buildPaymentOption(
            'OVO',
            Assets.imagesArcticonsOvo, // Make sure to add this asset
            'ovo',
          ),
          const Divider(),
          _buildPaymentOption(
            'Bank account in IDR',
            Assets.imagesBiBank, // Make sure to add this asset
            'bank_idr',
          ),
          const Divider(),
          _buildPaymentOption(
            'PayPal in SGD',
            Assets.imagesLogosPaypal, // Make sure to add this asset
            'paypal_sgd',
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedPaymentMethod != null
                  ? () {
                // Handle confirm action
                Navigator.pop(context, _selectedPaymentMethod);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDD757), // Yellow color
                disabledBackgroundColor: const Color(0xFFFDD757).withOpacity(0.6),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String iconPath, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            // Replace with SvgPicture if using SVG
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(iconPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color iconColor;

  const PaymentMethodCard({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
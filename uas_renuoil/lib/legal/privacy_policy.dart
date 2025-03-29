import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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

                // Legal terms header
                Text(
                  'Legal terms',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),

                // ReNuOil Privacy title
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'RenuOil Privacy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Privacy policy description
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Our Privacy Policy explains what personal information we collect, how we use personal information, how personal information is shared, and privacy rights.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                ),

                // Privacy policy title
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Privacy policy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Supplemental privacy policy description
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Please review the supplemental privacy policies linked within the privacy policy documents, such as for certain RenuOil services, that may be applicable to you.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                ),

                // Supplemental Privacy Policy Documents title
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Supplemental Privacy Policy Documents',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // List of supplemental policy documents
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: _buildSupplementalPolicies(),
                ),

                // Add some space at the bottom
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSupplementalPolicies() {
    final policies = [
      'Outside the Indonesian supplement',
      'Indonesian Privacy supplement',
      'Cookie Policy',
      'Enterprise Customers and RenuOil for Work',
      'Privacy Supplement for Singapore',
      'Brunei Privacy Supplement',
      'Non-User DAC7 Privacy Notice',
      'RenuOil Marketplace Supplemental Privacy',
      'Insurance Supplement',
    ];

    return policies.map((policy) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '• ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Text(
                policy,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
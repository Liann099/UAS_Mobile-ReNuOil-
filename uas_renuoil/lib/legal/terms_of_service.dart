import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Symbols.arrow_back_ios_new, size: 20),
              ),
              SizedBox(height: 16,),
              const Text(
                'Legal Terms',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              // Title
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8,),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ReNuOil Terms of Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Welcome to ReNuOil, a provider of renewable oil solutions. In using our services, you agree to be bound by these Terms of Service. Please read them carefully before using our website, products, or services.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'By accessing, browsing, or using our website, products, or services, you agree to these terms. If you do not agree to these terms, please do not use our website. Your continued use of our services constitutes your acceptance of these terms, including any future modifications.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '1. Service Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ReNuOil specializes in the production and distribution of renewable oil solutions. Our unique approach to sustainability is reflected across all our products and services, and as such, we reserve the right to modify, update, or discontinue any of our offerings without prior notice. This includes changes to product offerings, pricing, availability, and application requirements.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '2. User Responsibilities',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'To ensure the integrity of our services, you agree to:',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Provide accurate, complete, and up-to-date information when creating an account or placing an order\n• Maintain the confidentiality of usernames and passwords, and follow our appropriate usage, storage, disposal, and transportation rules and regulations\n• Not engage in any fraudulent, deceptive, or harmful activities that cause unnecessary risk or damage to the functionality or integrity of our systems\n• Refrain from attempting to interfere with the proper functioning of our website or services through unauthorized access, hacking, or other overloading of our systems',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failure to adhere to these responsibilities may result in restriction or termination of your access to our services.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '3. Orders and Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• All orders placed through our website or through authorized channels are subject to acceptance. If an order cannot be fulfilled or is unavailable, we will notify you as soon as possible\n• Orders are considered valid once payment is received in full. Accepted payment methods include credit/debit cards, bank transfers, and other electronic payment options as specified on our website\n• Prices for products and services are indicated on our website or communicated directly. We are not responsible for typographical errors regarding pricing of goods or services\n• In the event of transaction failures or payment disputes, we reserve the right to cancel the order and initiate refunds where necessary',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '4. Shipping and Delivery',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• We strive to fulfill orders within the timeframes indicated, but estimated delivery times may vary and cannot be guaranteed\n• We are not responsible for delays caused by third-party couriers, customs clearance, weather conditions, or other unforeseen circumstances beyond our control\n• Upon delivery, the condition of the product(s) are the responsibility of the customer unless stated otherwise\n• We recommend that customers carefully inspect the package for any visible damage if possible before release signature',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '5. Returns and Refunds',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Returns may be accepted within 14 days of purchase, provided the product is unused, unopened, and in its original packaging\n• To initiate a return, you must contact our customer service team which will issue the relevant Return Material Authorization (RMA)\n• Refunds will be processed in accordance with our RefundPolicy, which may include deductions for restocking fees or shipping costs\n• Refunds may take several business days to process, depending on your payment method and financial institution\n• Customized or special-order products may not be eligible for return or refund unless defective or through specific consent',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '7. Intellectual Property',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• All content, trademarks, logos, text, images, and audiovisual content displayed throughout our website and associated with our products are the exclusive property of ReNuOil or its licensors. You may not reproduce, copy, or modify any of our intellectual property without prior written consent\n• Unauthorized use of our intellectual property may result in legal action',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '8. Limitation of Liability',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• ReNuOil is not liable for any indirect, incidental, consequential, or punitive damages arising from the use of our products or services\n• We do not guarantee that our products will be error-free or operate without interruption\n• Our maximum liability in any event shall be limited to the purchase price of the product or service in question',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '9. Termination',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• We reserve the right to terminate or suspend your access to all or part of our site, with or without notice, for any violation of these Terms of Service\n• In the event of termination, any outstanding obligations, including payments due, shall remain enforceable\n• We may also discontinue services for any reason, including convenience or legal constraints',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        '10. Changes to Terms',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• ReNuOil reserves the right to update or modify these Terms of Service at any time\n• Changes are effective upon posting on our website, and it is your responsibility to review them periodically\n• Continued use of our services after modifications constitutes your acceptance of the revised terms',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'By using our services, you acknowledge that you have read, understood, and agreed to these Terms of Service. If you do not agree with any part of these terms, please discontinue use of our services immediately.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
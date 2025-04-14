import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RNO Top-up',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const RnoTopUpPage(),
    );
  }
}

class RnoTopUpPage extends StatefulWidget {
  const RnoTopUpPage({super.key});

  @override
  State<RnoTopUpPage> createState() => _RnoTopUpPageState();
}

class _RnoTopUpPageState extends State<RnoTopUpPage> {
  final TextEditingController _amountController = TextEditingController();
  int? _selectedPaymentMethod;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'RNO Top-up',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/informasitruk.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Max. top-up',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Rp2.000.000',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'RNO Balance',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              ': Rp0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Top up amount
            const Text(
              'How much do you want to Top Up?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Amount input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Quick amount buttons
            Row(
              children: [
                _buildAmountButton('100rb'),
                const SizedBox(width: 10),
                _buildAmountButton('200rb'),
                const SizedBox(width: 10),
                _buildAmountButton('500rb'),
                const SizedBox(width: 10),
                _buildAmountButton('1jt'),
              ],
            ),
            
            const SizedBox(height: 10),
            
            Row(
              children: [
                _buildAmountButton('1.5jt'),
                const SizedBox(width: 10),
                _buildAmountButton('Isi penuh'),
                const Spacer(),
                const Spacer(),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Payment method
            const Text(
              'Which payment metode do you want to use?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 15),
            
            // BCA Card
            _buildPaymentMethodCard(
              0,
              'BCA',
              '5147 8816 8499 7303',
              'Matt',
              'assets/images/BCA.png',
              Colors.blue.shade100,
            ),
            
            const SizedBox(height: 15),
            
            // OCBC Card
            _buildPaymentMethodCard(
              1,
              'OCBC',
              '8428 1945 1234 8888',
              'Matt',
              'assets/images/OCBC.png',
              Colors.red.shade100,
            ),
            
            const SizedBox(height: 40),
            
            // Confirm button
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD75E),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String text) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          String amount = '';
          switch (text) {
            case '100rb':
              amount = '100000';
              break;
            case '200rb':
              amount = '200000';
              break;
            case '500rb':
              amount = '500000';
              break;
            case '1jt':
              amount = '1000000';
              break;
            case '1.5jt':
              amount = '1500000';
              break;
            case 'Isi penuh':
              amount = '2000000';
              break;
          }
          setState(() {
            _amountController.text = amount;
          });
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    int index, 
    String bankName, 
    String accountNumber, 
    String accountName,
    String backgroundImage,
    Color overlayColor,
  ) {
    bool isSelected = _selectedPaymentMethod == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.asset(
                backgroundImage,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            
            // Overlay color
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.3),
                    overlayColor.withOpacity(0.7),
                    overlayColor,
                  ],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    accountNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Name : $accountName',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
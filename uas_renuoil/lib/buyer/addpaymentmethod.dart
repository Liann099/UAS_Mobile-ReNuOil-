import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShippingMethodsScreen(),
    );
  }
}

class ShippingMethodsScreen extends StatefulWidget {
  const ShippingMethodsScreen({super.key});

  @override
  _ShippingMethodsScreenState createState() => _ShippingMethodsScreenState();
}

class _ShippingMethodsScreenState extends State<ShippingMethodsScreen> {
  String? selectedShippingMethod;
  String? selectedDeliveryService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Shipping methods',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Line
              Divider(color: Colors.grey.shade300, thickness: 1),
              
              // Shipping Method Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedShippingMethod = 'Send to your address';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedShippingMethod == 'Send to your address' 
                              ? Colors.black 
                              : Colors.white,
                          foregroundColor: selectedShippingMethod == 'Send to your address' 
                              ? Colors.white 
                              : Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Send to your address'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedShippingMethod = 'Pick up manually';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedShippingMethod == 'Pick up manually' 
                              ? Colors.black 
                              : Colors.white,
                          foregroundColor: selectedShippingMethod == 'Pick up manually' 
                              ? Colors.white 
                              : Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Pick up manually'),
                      ),
                    ),
                ],
              ),
              ),

              // Horizontal Line
              Divider(color: Colors.grey.shade300, thickness: 1),

              const SizedBox(height: 24),

              // Delivery Service Title
              const Text(
                'Choose your Delivery service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Gojek Option
              InkWell(
                onTap: () {
                  setState(() {
                    selectedDeliveryService = 'Gojek';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logogojek.png',
                        width: 100,
                        height: 40,
                      ),
                      Radio(
                        value: 'Gojek',
                        groupValue: selectedDeliveryService,
                        onChanged: (value) {
                          setState(() {
                            selectedDeliveryService = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Grab Option
              InkWell(
                onTap: () {
                  setState(() {
                    selectedDeliveryService = 'Grab';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logograb.png',
                        width: 100,
                        height: 40,
                      ),
                      Radio(
                        value: 'Grab',
                        groupValue: selectedDeliveryService,
                        onChanged: (value) {
                          setState(() {
                            selectedDeliveryService = value;
                          });
                        },
                      ),
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
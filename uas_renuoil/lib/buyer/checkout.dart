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
      title: 'Checkout Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar
    final screenWidth = MediaQuery.of(context).size.width;
    // Menyesuaikan padding berdasarkan lebar layar
    final sidePadding = screenWidth < 350 ? 8.0 : 16.0;
    final smallScreen = screenWidth <= 300;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 24), // Ukuran ikon dikurangi
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: smallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Spacer icon to balance the back button
                  SizedBox(width: smallScreen ? 24 : 48),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider
                    Container(
                      height: 8,
                      color: const Color(0xFFF5F5F5),
                    ),
                    
                    // Address
                    Padding(
                      padding: EdgeInsets.all(sidePadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 20, // Icon lebih kecil
                          ),
                          SizedBox(width: smallScreen ? 8.0 : 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                smallScreen
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Matt Cenna',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '(+62) 812-3456-789',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Matt Cenna',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '(+62) 812-3456-789',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gang Kavling 3 Jalan BSD Raya Barat, Jl. Edutown No.1, Pagedangan, Kec. Pagedangan, Kabupaten Tangerang, Banten 15339',
                                  style: TextStyle(
                                    fontSize: smallScreen ? 12 : 14,
                                    color: Colors.grey[600],
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: smallScreen ? 4 : 8),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    
                    // Divider
                    Container(
                      height: 8,
                      color: const Color(0xFFF5F5F5),
                    ),
                    
                    // Product
                    Padding(
                      padding: EdgeInsets.all(sidePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shop name with icon
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Color(0xFFFFD700),
                                size: 20, // Icon lebih kecil
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Lala's Collection",
                                style: TextStyle(
                                  fontSize: smallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Product details
                          smallScreen
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row for image and product name
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.asset(
                                            'assets/images/cookingoil.png',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image, color: Colors.grey, size: 20),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        
                                        // Product info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Coconut Oil - Renewable',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'North Jakarta, Indonesia',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row for quantity selector
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Quantity selector
                                        Row(
                                          children: [
                                            // Minus button
                                            InkWell(
                                              onTap: () {
                                                if (quantity > 1) {
                                                  setState(() {
                                                    quantity--;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.grey),
                                                ),
                                                child: const Icon(Icons.remove, size: 14),
                                              ),
                                            ),
                                            
                                            // Quantity
                                            Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 8),
                                              width: 24,
                                              child: Text(
                                                quantity.toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            
                                            // Plus button
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  quantity++;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.grey),
                                                ),
                                                child: const Icon(Icons.add, size: 14),
                                              ),
                                            ),
                                            
                                            const SizedBox(width: 8),
                                            
                                            // Unit
                                            const Text(
                                              'Liters',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        // Price
                                        Text(
                                          'Rp49.999/liter',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/images/cookingoil.png',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 70,
                                            height: 70,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image, color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // Product info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Coconut Oil - Renewable',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'North Jakarta, Indonesia',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Quantity selector
                                    Row(
                                      children: [
                                        // Minus button
                                        InkWell(
                                          onTap: () {
                                            if (quantity > 1) {
                                              setState(() {
                                                quantity--;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: const Icon(Icons.remove, size: 16),
                                          ),
                                        ),
                                        
                                        // Quantity
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          width: 30,
                                          child: Text(
                                            quantity.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        
                                        // Plus button
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              quantity++;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: const Icon(Icons.add, size: 16),
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 8),
                                        
                                        // Unit
                                        const Text(
                                          'Liters',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          
                          if (!smallScreen) const SizedBox(height: 8),
                          
                          // Price - hanya ditampilkan jika layout horizontal (layar > 300)
                          if (!smallScreen)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Rp49.999/liter',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Divider
                    Container(
                      height: 8,
                      color: const Color(0xFFF5F5F5),
                    ),
                    
                    // Voucher code
                    Padding(
                      padding: EdgeInsets.all(sidePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Voucher Code',
                            style: TextStyle(
                              fontSize: smallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: smallScreen ? 40 : 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              decoration: InputDecoration(
                                hintText: 'Input voucher code',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: smallScreen ? 12 : 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: const Color(0xFFEEEEEE),
                    ),
                    
                    // Shipping Methods
                    Padding(
                      padding: EdgeInsets.all(sidePadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping methods',
                            style: TextStyle(
                              fontSize: smallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, size: smallScreen ? 20 : 24),
                        ],
                      ),
                    ),
                    
                    // Divider
                    Container(
                      height: 1,
                      color: const Color(0xFFEEEEEE),
                    ),
                    
                    // Total
                    Padding(
                      padding: EdgeInsets.all(sidePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_outlined, size: smallScreen ? 18 : 20),
                              const SizedBox(width: 8),
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: smallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Price breakdown
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Product Total',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                              Text(
                                'Rp49.999',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                            ],
                          ),
                          SizedBox(height: smallScreen ? 6 : 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Fee',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                              Text(
                                'Rp3.500',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                            ],
                          ),
                          SizedBox(height: smallScreen ? 6 : 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Service Fee',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                              Text(
                                'Rp1.200',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                            ],
                          ),
                          SizedBox(height: smallScreen ? 6 : 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Voucher Discount',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                              Text(
                                '-',
                                style: TextStyle(fontSize: smallScreen ? 12 : 14),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: smallScreen ? 12 : 16),
                          const Divider(height: 1),
                          SizedBox(height: smallScreen ? 6 : 8),
                          
                          // Grand total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontSize: smallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp54.699',
                                style: TextStyle(
                                  fontSize: smallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
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
            ),
            
            // Payment button
            Padding(
              padding: EdgeInsets.all(sidePadding),
              child: Container(
                width: double.infinity,
                height: smallScreen ? 44 : 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8D148),
                  borderRadius: BorderRadius.circular(smallScreen ? 22 : 25),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: smallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
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
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';

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

  // Method to calculate adaptive sizes based on screen width
  double getAdaptiveSize(BuildContext context, double baseSize,
      double factorSmall, double factorLarge) {
    final width = MediaQuery.of(context).size.width;
    if (width < 320) {
      return baseSize * factorSmall;
    } else if (width < 480) {
      return baseSize;
    } else {
      return baseSize * factorLarge;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size information
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    // Calculate responsive values
    final isExtraSmall = screenWidth < 320;
    final isSmall = screenWidth < 480;
    final isMedium = screenWidth < 768;
    final isLarge = screenWidth >= 768;

    // Adaptive padding and spacing
    final horizontalPadding = isExtraSmall
        ? 8.0
        : isSmall
            ? 16.0
            : 24.0;
    final verticalSpacing = isExtraSmall
        ? 8.0
        : isSmall
            ? 12.0
            : 16.0;

    // Adaptive font sizes
    final headingSize = isExtraSmall
        ? 18.0
        : isSmall
            ? 20.0
            : 24.0;
    final subtitleSize = isExtraSmall
        ? 14.0
        : isSmall
            ? 16.0
            : 18.0;
    final bodySize = isExtraSmall
        ? 12.0
        : isSmall
            ? 14.0
            : 16.0;
    final smallSize = isExtraSmall
        ? 10.0
        : isSmall
            ? 12.0
            : 14.0;

    // Adaptive icon sizes
    final iconSize = isExtraSmall
        ? 16.0
        : isSmall
            ? 20.0
            : 24.0;
    final smallIconSize = isExtraSmall
        ? 12.0
        : isSmall
            ? 14.0
            : 16.0;

    // Adaptive container sizes
    final imageSize = isExtraSmall
        ? 60.0
        : isSmall
            ? 70.0
            : 90.0;
    final buttonHeight = isExtraSmall
        ? 40.0
        : isSmall
            ? 48.0
            : 56.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with responsive sizing
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalSpacing),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: iconSize),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: headingSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Balance spacer
                  SizedBox(width: iconSize * 2),
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

                    // Address section - Responsive layout
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: smallIconSize,
                          ),
                          SizedBox(width: horizontalPadding / 2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // For smaller screens, stack name and phone vertically
                                // For larger screens, place them side by side
                                isMedium
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Matt Cenna',
                                            style: TextStyle(
                                              fontSize: subtitleSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: verticalSpacing / 4),
                                          Text(
                                            '(+62) 812-3456-789',
                                            style: TextStyle(
                                              fontSize: smallSize,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Matt Cenna',
                                            style: TextStyle(
                                              fontSize: subtitleSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '(+62) 812-3456-789',
                                            style: TextStyle(
                                              fontSize: bodySize,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: verticalSpacing / 2),
                                Text(
                                  'Gang Kavling 3 Jalan BSD Raya Barat, Jl. Edutown No.1, Pagedangan, Kec. Pagedangan, Kabupaten Tangerang, Banten 15339',
                                  style: TextStyle(
                                    fontSize: smallSize,
                                    color: Colors.grey[600],
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: horizontalPadding / 4),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_down,
                                size: smallIconSize),
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

                    // Product section - Adaptive layout based on screen size
                    // Padding(
                    //   padding: EdgeInsets.all(horizontalPadding),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Shop name with icon
                    //       Row(
                    //         children: [
                    //           Icon(
                    //             Icons.emoji_events,
                    //             color: const Color(0xFFFFD700),
                    //             size: smallIconSize,
                    //           ),
                    //           SizedBox(width: horizontalPadding / 2),
                    //           Text(
                    //             "Lala's Collection",
                    //             style: TextStyle(
                    //               fontSize: subtitleSize,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(height: verticalSpacing),
                    //
                    //       // Product details - Different layouts based on screen width
                    //       isMedium
                    //           // Vertical layout for narrow screens
                    //           ? Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 // Row for image and product name
                    //                 Row(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     // Product image
                    //                     ClipRRect(
                    //                       borderRadius: BorderRadius.circular(8),
                    //                       child: Image.asset(
                    //                         'assets/images/cookingoil.png',
                    //                         width: imageSize,
                    //                         height: imageSize,
                    //                         fit: BoxFit.cover,
                    //                         errorBuilder: (context, error, stackTrace) {
                    //                           return Container(
                    //                             width: imageSize,
                    //                             height: imageSize,
                    //                             color: Colors.grey[300],
                    //                             child: Icon(Icons.image, color: Colors.grey, size: smallIconSize),
                    //                           );
                    //                         },
                    //                       ),
                    //                     ),
                    //                     SizedBox(width: horizontalPadding / 1.5),
                    //
                    //                     // Product info
                    //                     Expanded(
                    //                       child: Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             'Coconut Oil - Renewable',
                    //                             style: TextStyle(
                    //                               fontSize: bodySize,
                    //                               fontWeight: FontWeight.w500,
                    //                             ),
                    //                           ),
                    //                           SizedBox(height: verticalSpacing / 3),
                    //                           Text(
                    //                             'North Jakarta, Indonesia',
                    //                             style: TextStyle(
                    //                               fontSize: smallSize,
                    //                               color: Colors.grey[600],
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 SizedBox(height: verticalSpacing),
                    //
                    //                 // Row for quantity selector and price
                    //                 Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     // Quantity selector
                    //                     Row(
                    //                       children: [
                    //                         // Minus button
                    //                         _buildQuantityButton(
                    //                           icon: Icons.remove,
                    //                           size: smallIconSize,
                    //                           onTap: () {
                    //                             if (quantity > 1) {
                    //                               setState(() {
                    //                                 quantity--;
                    //                               });
                    //                             }
                    //                           },
                    //                           padding: isExtraSmall ? 3.0 : 4.0,
                    //                         ),
                    //
                    //                         // Quantity
                    //                         Container(
                    //                           margin: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                    //                           width: isExtraSmall ? 24 : 30,
                    //                           child: Text(
                    //                             quantity.toString(),
                    //                             textAlign: TextAlign.center,
                    //                             style: TextStyle(
                    //                               fontSize: bodySize,
                    //                               fontWeight: FontWeight.bold,
                    //                             ),
                    //                           ),
                    //                         ),
                    //
                    //                         // Plus button
                    //                         _buildQuantityButton(
                    //                           icon: Icons.add,
                    //                           size: smallIconSize,
                    //                           onTap: () {
                    //                             setState(() {
                    //                               quantity++;
                    //                             });
                    //                           },
                    //                           padding: isExtraSmall ? 3.0 : 4.0,
                    //                         ),
                    //
                    //                         SizedBox(width: horizontalPadding / 2),
                    //
                    //                         // Unit
                    //                         Text(
                    //                           'Liters',
                    //                           style: TextStyle(
                    //                             fontSize: smallSize,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //
                    //                     // Price
                    //                     Text(
                    //                       'Rp49,999/liter',
                    //                       style: TextStyle(
                    //                         fontSize: smallSize,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.grey[800],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             )
                    //           // Horizontal layout for wider screens
                    //           : Row(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 // Product image
                    //                 ClipRRect(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                   child: Image.asset(
                    //                     'assets/images/cookingoil.png',
                    //                     width: imageSize,
                    //                     height: imageSize,
                    //                     fit: BoxFit.cover,
                    //                     errorBuilder: (context, error, stackTrace) {
                    //                       return Container(
                    //                         width: imageSize,
                    //                         height: imageSize,
                    //                         color: Colors.grey[300],
                    //                         child: Icon(Icons.image, color: Colors.grey, size: iconSize),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //                 SizedBox(width: horizontalPadding),
                    //
                    //                 // Product info
                    //                 Expanded(
                    //                   child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         'Coconut Oil - Renewable',
                    //                         style: TextStyle(
                    //                           fontSize: bodySize,
                    //                           fontWeight: FontWeight.w500,
                    //                         ),
                    //                       ),
                    //                       SizedBox(height: verticalSpacing / 3),
                    //                       Text(
                    //                         'North Jakarta, Indonesia',
                    //                         style: TextStyle(
                    //                           fontSize: smallSize,
                    //                           color: Colors.grey[600],
                    //                         ),
                    //                       ),
                    //
                    //                       if (isLarge) ...[
                    //                         SizedBox(height: verticalSpacing),
                    //                         Text(
                    //                           'Rp49,999/liter',
                    //                           style: TextStyle(
                    //                             fontSize: bodySize,
                    //                             fontWeight: FontWeight.bold,
                    //                             color: Colors.grey[800],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ],
                    //                   ),
                    //                 ),
                    //
                    //                 // Quantity selector
                    //                 Row(
                    //                   children: [
                    //                     // Minus button
                    //                     _buildQuantityButton(
                    //                       icon: Icons.remove,
                    //                       size: smallIconSize,
                    //                       onTap: () {
                    //                         if (quantity > 1) {
                    //                           setState(() {
                    //                             quantity--;
                    //                           });
                    //                         }
                    //                       },
                    //                       padding: 4.0,
                    //                     ),
                    //
                    //                     // Quantity
                    //                     Container(
                    //                       margin: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                    //                       width: 30,
                    //                       child: Text(
                    //                         quantity.toString(),
                    //                         textAlign: TextAlign.center,
                    //                         style: TextStyle(
                    //                           fontSize: bodySize,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                       ),
                    //                     ),
                    //
                    //                     // Plus button
                    //                     _buildQuantityButton(
                    //                       icon: Icons.add,
                    //                       size: smallIconSize,
                    //                       onTap: () {
                    //                         setState(() {
                    //                           quantity++;
                    //                         });
                    //                       },
                    //                       padding: 4.0,
                    //                     ),
                    //
                    //                     SizedBox(width: horizontalPadding / 2),
                    //
                    //                     // Unit
                    //                     Text(
                    //                       'Liters',
                    //                       style: TextStyle(
                    //                         fontSize: smallSize,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //
                    //       // Show price below only for medium screens (not small and not large)
                    //       if (!isMedium && !isLarge) ...[
                    //         SizedBox(height: verticalSpacing),
                    //         Align(
                    //           alignment: Alignment.centerRight,
                    //           child: Text(
                    //             'Rp49,999/liter',
                    //             style: TextStyle(
                    //               fontSize: bodySize,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.grey[800],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ],
                    //   ),
                    // ),
                    ProductCard(),

                    // Divider
                    Container(
                      height: 8,
                      color: const Color(0xFFF5F5F5),
                    ),

                    // Voucher code section
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Voucher Code',
                            style: TextStyle(
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: verticalSpacing / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            height: buttonHeight * 0.8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              style: TextStyle(fontSize: bodySize),
                              decoration: InputDecoration(
                                hintText: 'Input voucher code',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: bodySize,
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

                    // Shipping Methods section
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping methods',
                            style: TextStyle(
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, size: iconSize),
                        ],
                      ),
                    ),

                    // Divider
                    Container(
                      height: 1,
                      color: const Color(0xFFEEEEEE),
                    ),

                    // Total section with responsive spacing
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_outlined,
                                  size: iconSize * 0.8),
                              SizedBox(width: horizontalPadding / 2),
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: subtitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: verticalSpacing),

                          // Price breakdown
                          _buildPriceRow(
                            label: 'Product Total',
                            value: 'Rp49,999',
                            fontSize: smallSize,
                          ),
                          SizedBox(height: verticalSpacing / 2),

                          _buildPriceRow(
                            label: 'Delivery Fee',
                            value: 'Rp3,500',
                            fontSize: smallSize,
                          ),
                          SizedBox(height: verticalSpacing / 2),

                          _buildPriceRow(
                            label: 'Service Fee',
                            value: 'Rp1,200',
                            fontSize: smallSize,
                          ),
                          SizedBox(height: verticalSpacing / 2),

                          _buildPriceRow(
                            label: 'Voucher Discount',
                            value: '-',
                            fontSize: smallSize,
                          ),

                          SizedBox(height: verticalSpacing),
                          SizedBox(height: verticalSpacing / 2),

                          // Grand total
                          _buildPriceRow(
                            label: 'Grand Total',
                            value: 'Rp54,699',
                            fontSize: bodySize,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Payment button - Responsive sizing
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Container(
                width: double.infinity,
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8D148),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: bodySize,
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

  // Helper method for quantity buttons
  Widget _buildQuantityButton({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
    required double padding,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Icon(icon, size: size),
      ),
    );
  }

  // Helper method for price rows
  Widget _buildPriceRow({
    required String label,
    required String value,
    required double fontSize,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: Icon(
          icon,
          size: size,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop name with icon
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: const Color(0xFFFFD700),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                "Lala's Collection",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Main product content row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  Assets.imagesProductMilk,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.grey, size: 40),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),

              // Product info with title and location in the same column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coconut Oil - Renewable',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'North Jakarta, Indonesia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    // Add a row for price and quantity selector
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          'Rp49,999/liter',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),

                        // Quantity selector in a row
                        Row(
                          children: [
                            // Minus button
                            _buildQuantityButton(
                              icon: Icons.remove,
                              size: 12,
                              onTap: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                            ),

                            // Quantity
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                quantity.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Plus button
                            _buildQuantityButton(
                              icon: Icons.add,
                              size: 12,
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                            ),

                            SizedBox(width: 6),

                            // Unit
                            Text(
                              'Liters',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

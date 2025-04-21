import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BuyerHomePage(), // This should be your initial screen
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class CookingOilPage extends StatefulWidget {
  final Product product; // Add this line

  const CookingOilPage({Key? key, required this.product})
      : super(key: key); // Update constructor

  @override
  State<CookingOilPage> createState() => _CookingOilPageState();
}

class _CookingOilPageState extends State<CookingOilPage> {
  int _quantity = 1;

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with back and favorite buttons
            Stack(
              children: [
                // Image
                Container(
                  height: 350,
                  width: double.infinity,
                  color: const Color(0xFFD0C8BA),
                  child: Center(
                    child: widget.product.picture != null
                        ? Image.network(
                            widget.product.picture!,
                            height: 350,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            Assets.imagesProductMilk,
                            height: 350,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 50,
                  left: 16,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(64),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),

                // Favorite button
                // Positioned(
                //   top: 50,
                //   right: 16,
                //   child: IconButton(
                //     icon: const Icon(
                //       Icons.favorite_border,
                //       size: 36,
                //       color: Colors.white,
                //     ),
                //     onPressed: () {},
                //     padding: EdgeInsets.zero,
                //   ),
                // ),
              ],
            ),

            // Price and sold info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp${widget.product.pricePerLiter.toStringAsFixed(2)}/liter',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '35 sold',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Stock info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '41 Liters Stock',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Location
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.product.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(color: Colors.grey[300]),

            // Seller info and quantity
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seller info with profile picture
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(Assets.imagesMascot),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: const [
                          Text(
                            'Renuoil_offi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.emoji_events,
                              color: Colors.amber, size: 18),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Cart button and quantity selector
                  Row(
                    children: [
                      // Cart icon
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                          onPressed: () {},
                        ),
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                      ),

                      // Decrease button
                      GestureDetector(
                        onTap: _decreaseQuantity,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(Icons.remove, size: 18),
                        ),
                      ),

                      // Quantity value
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Increase button
                      GestureDetector(
                        onTap: _increaseQuantity,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      ),

                      // Text "Liters"
                      const SizedBox(width: 8),
                      const Text(
                        'Liters',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      const Spacer(),

                      // Buy button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                product: widget.product,
                                initialQuantity:
                                    _quantity, // Pass the current quantity
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBD562),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                        ),
                        child: const Text(
                          'Buy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Reviews section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFCE38A),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: const [
                        Icon(Icons.star, size: 20, color: Colors.black),
                        SizedBox(width: 4),
                        Text(
                          '4.89 • 31 reviews',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Review content in rounded container
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3C4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reviewer info
                        Row(
                          children: const [
                            Text(
                              'Hansel Richie Gunawan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text('•'),
                            SizedBox(width: 4),
                            Text(
                              'January 2025',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Review text
                        const Text(
                          '"I\'ve been using this coconut oil for months, and it\'s amazing! The quality is top-notch—light, pure, and with a subtle coconut scent. I love that it\'s versatile; I use it for cooking, skincare, and even as a natural hair treatment. Plus, the fact that it\'s renewable makes it an eco-friendly choice. Definitely a great buy!"',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Rating stars
                        Row(
                          children: const [
                            Icon(Icons.star, size: 16, color: Colors.black),
                            Icon(Icons.star, size: 16, color: Colors.black),
                            Icon(Icons.star, size: 16, color: Colors.black),
                            Icon(Icons.star, size: 16, color: Colors.black),
                            Icon(Icons.star, size: 16, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // About the oil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'About the oil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This high-quality coconut oil is versatile and renewable. Perfect for cooking, skincare, and industrial use, it retains nutrients and purity. It can be reused through refining or filtering, making it an eco-friendly choice. Lightweight with a mild coconut aroma, it\'s a sustainable and efficient solution.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Other products
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Other products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProductCard(
                          'ABC Cooking Oil - Used',
                          Assets.imagesProductMilk,
                          'Rp39,999',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProductCard(
                          'Chef\'s Oil - Used',
                          Assets.imagesProductMilk,
                          'Rp46,999',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String title, String imagePath, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Product info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

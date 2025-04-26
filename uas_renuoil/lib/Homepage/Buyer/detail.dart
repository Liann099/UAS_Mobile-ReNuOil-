import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../home.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/checkout.dart';
import 'package:flutter_application_1/Homepage/Buyer/cart.dart';

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

class Review {
  final int id;
  final String user;
  final int star;
  final String description;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.user,
    required this.star,
    required this.description,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      user: json['user'],
      star: json['star'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final List<Review> reviews;

  ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'],
      reviews: (json['reviews'] as List)
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList(),
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
  final storage = const FlutterSecureStorage();
  Future<List<Product>>? _futureOtherProducts;

  int _quantity = 1;
  late Future<ReviewStats> _reviewsFuture;
  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviews();
    _futureOtherProducts = fetchOtherProducts(); // Fetch other products
  }

// Fetch the first two other products
  Future<List<Product>> fetchOtherProducts() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/products/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Product> allProducts =
            data.map((json) => Product.fromJson(json)).toList();

        // Filter out the current product and take up to 2 other products
        return allProducts
            .where((product) => product.id != widget.product.id)
            .take(2)
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('[ERROR] Exception occurred: $e');
      rethrow;
    }
  }

  Future<ReviewStats> _fetchReviews() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/${widget.product.id}/reviews/'),
    );

    if (response.statusCode == 200) {
      return ReviewStats.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load reviews');
    }
  }
  // int _quantity = 1;

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

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CookingOilPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.picture ?? '',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  Assets.imagesProductMilk,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp${product.pricePerLiter.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    product.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                            height: 450,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            Assets.imagesProductMilk,
                            height: 450,
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
                        Icons.chevron_left,
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
                  Text(
                    '${widget.product.sold} sold',
                    style: const TextStyle(
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
                  Text(
                    '${widget.product.stock} Liters Stock',
                    style: const TextStyle(
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
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                          ),
                          onPressed: () {
                            // Create a CartItem with the current product and quantity
                            final cartItem = CartItem(
                              product: widget.product,
                              quantity: _quantity,
                            );

                            // Add to cart (you'll need to manage your cart state, possibly with a provider)
                            CartManager.addToCart(cartItem);

                            // Navigate to cart page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BasketScreen(),
                              ),
                            );
                          },
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
            // Replace your existing Reviews section with this:

            FutureBuilder<ReviewStats>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(top: 16.0, left: 12, right: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE38A),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Error loading reviews'),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.reviews.isEmpty) {
                  return Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(top: 16.0, left: 12, right: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCE38A),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No reviews yet'),
                    ),
                  );
                }

                final stats = snapshot.data!;
                final sortedReviews = stats.reviews
                    .toList() // Create a copy of the list to avoid modifying the original
                  ..sort((a, b) => b.createdAt
                      .compareTo(a.createdAt)); // Sort in descending order

                // Get the latest review (first item in sorted list)
                final latestReview = sortedReviews.first;

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE38A),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating summary
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 20, color: Colors.black),
                            const SizedBox(width: 4),
                            Text(
                              '${stats.averageRating.toStringAsFixed(2)} • ${stats.totalReviews} reviews',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Most recent review
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
                            // Reviewer + time
                            Row(
                              children: [
                                Text(
                                  latestReview.user,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('•'),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(latestReview
                                      .createdAt), // Customize this format as needed
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Description
                            Text(
                              '"${latestReview.description}"',
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 10),

                            // Star rating
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: index < latestReview.star
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // About the oil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About the oil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
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
                  FutureBuilder<List<Product>>(
                    future: _futureOtherProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No other products available'));
                      } else {
                        final otherProducts = snapshot.data!;

                        return otherProducts.isNotEmpty
                            ? Row(
                                children: [
                                  if (otherProducts.length >= 1)
                                    Expanded(
                                      child:
                                          _buildProductCard(otherProducts[0]),
                                    ),
                                  if (otherProducts.length >= 2)
                                    const SizedBox(width: 12),
                                  if (otherProducts.length >= 2)
                                    Expanded(
                                      child:
                                          _buildProductCard(otherProducts[1]),
                                    ),
                                ],
                              )
                            : const Center(
                                child: Text('No similar products available'));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

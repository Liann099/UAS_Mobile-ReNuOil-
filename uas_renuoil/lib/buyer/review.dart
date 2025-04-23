import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/constants.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ReviewPage> {
  double productRating = 0;
  final TextEditingController commentController = TextEditingController();
  bool isLoading = false;
  late int productId;
  String? productName;
  String? productOrigin;
  double? productPrice;
  String? productImageUrl;
  String amount = "1 Liter";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract the arguments from the current route settings
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Get the productId from the arguments
    productId = args?['productId'] ?? 1;

    if (productId == 0) {
      // Handle missing productId
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Product ID is required')),
      );
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    } else {
      // Set up default product details or load them from API if needed
      productName = args?['productName'] ?? "Coconut Oil - Renewable";
      productOrigin = args?['productOrigin'] ?? "North Jakarta, Indonesia";
      productPrice = args?['productPrice'] ?? 54699.0;
      productImageUrl = args?['productImageUrl'];
    }
  }

  Future<void> submitReview() async {
    if (productRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please rate the product')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'access_token') ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ1Mzg3MDE5LCJpYXQiOjE3NDUzNzk4MTksImp0aSI6IjUxMDFiNWQ3OTdjMDRhNDVhZWVmNWE5NzQ3YWM1YTI3IiwidXNlcl9pZCI6MTF9.nq8pzIRP5QoelzOtWxnVd-KZZry4oXpqr7eDnJxt53w";

      final response = await http.post(
        Uri.parse('$baseUrl/api/products/review/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // Add authorization header if required
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'product': productId,
          'star': productRating.toInt(),
          'description': commentController.text.trim(),
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201) {
        // Review submitted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );

        // Navigate back after successful submission
        Navigator.pop(context);
      } else {
        // Handle errors
        final errorData = jsonDecode(response.body);
        String errorMessage = 'Failed to submit review';

        if (errorData is Map && errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final sidePadding = screenWidth < 350 ? 8.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth < 350 ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trophy and Collection name
                      Row(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Color(0xFFFFD700),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ReNuOil Collection',
                              style: TextStyle(
                                fontSize: screenWidth < 350 ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Product info with image
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Adjust layout based on constraints
                          final isNarrow = constraints.maxWidth < 260;

                          if (isNarrow) {
                            // Vertical layout for narrow screens
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image centered
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: productImageUrl != null
                                          ? Image.network(
                                        productImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.image,
                                            color: Colors.grey[500],
                                          );
                                        },
                                      )
                                          : Icon(
                                        Icons.image,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Product details
                                Text(
                                  productName ?? 'Product Name',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  productOrigin ?? 'Origin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Amount: $amount',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  productPrice != null
                                      ? 'Rp${productPrice!.toInt().toString()}'
                                      : 'Price not available',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Horizontal layout for wider screens
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: screenWidth < 350 ? 70 : 84,
                                    height: screenWidth < 350 ? 70 : 84,
                                    color: Colors.grey[300],
                                    child: productImageUrl != null
                                        ? Image.network(
                                      productImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image,
                                          color: Colors.grey[500],
                                        );
                                      },
                                    )
                                        : Icon(
                                      Icons.image,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName ?? 'Product Name',
                                        style: TextStyle(
                                          fontSize: screenWidth < 350 ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        productOrigin ?? 'Origin',
                                        style: TextStyle(
                                          fontSize: screenWidth < 350 ? 12 : 14,
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Amount: $amount',
                                        style: TextStyle(
                                          fontSize: screenWidth < 350 ? 12 : 14,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        productPrice != null
                                            ? 'Rp${productPrice!.toInt().toString()}'
                                            : 'Price not available',
                                        style: TextStyle(
                                          fontSize: screenWidth < 350 ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Product Score
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth < 350 ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                              (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                productRating = index + 1.0;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth < 350 ? 2.0 : 4.0
                              ),
                              child: Icon(
                                index < productRating ? Icons.star : Icons.star_border_outlined,
                                color: const Color(0xFFFFD700),
                                size: screenWidth < 350 ? 32 : 38,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Comment Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth < 350 ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Review',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: commentController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Write your review here...',
                            contentPadding: EdgeInsets.all(12),
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontFamily: 'Poppins'),
                          ),
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBD562),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextButton(
                  onPressed: isLoading ? null : submitReview,
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  )
                      : const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
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
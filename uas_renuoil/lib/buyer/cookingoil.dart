import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Added this to remove debug banner
      home: CookingOilPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class CookingOilPage extends StatefulWidget {
  const CookingOilPage({Key? key}) : super(key: key);

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

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _toggleFavorite(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite toggled')),
    );
  }

  void _buyProduct(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added to cart')),
    );
  }

  Widget _buildProductImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageSize = constraints.maxWidth > 300 
            ? 300 
            : constraints.maxWidth * 0.8;
        
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/cookingoil.png',
                height: imageSize,
                width: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceAndLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              'Rp.49,999/liter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '41 Liters Stock',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            'North Jakarta, Indonesia',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerAndQuantityActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            child: Text(
              'R', 
              style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Renuoil_offcl',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, size: 30),
                onPressed: _decreaseQuantity,
              ),
              Text(
                '$_quantity', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                )
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, size: 30),
                onPressed: _increaseQuantity,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text(
                  ' 4.89 • 31 reviews',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Hansel Richie Gunawan • January 2025',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '"I\'ve been using this coconut oil for months, and it\'s amazing! The quality is top-notch—light, pure, and with a subtle coconut scent. I love that it\'s versatile; I use it for cooking, skincare, and even as a natural hair treatment. Plus, the fact that it\'s renewable makes it an eco-friendly choice. Definitely a great buy!"',
              style: TextStyle(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) => 
                Icon(Icons.star, color: Colors.amber, size: 20)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutOilSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the oil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This high-quality coconut oil is versatile and renewable. Perfect for cooking, skincare, and industrial use. It retains nutrients and purity. It can be reused through refining or filtering, making it an eco-friendly choice. Lightweight with a mild coconut aroma, it\'s a sustainable and efficient solution.',
            style: TextStyle(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherProductCard(String title, String assetPath, String price) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              assetPath,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.black,
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

  Widget _buildOtherProductsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildOtherProductCard(
                  'ABC Cooking Oil - Used',
                  'assets/images/bomali oil.png',
                  'Rp39,999'
                ),
                _buildOtherProductCard(
                  'Chef\'s Oil - Used',
                  'assets/images/bomali oil.png',
                  'Rp46,999'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => _buyProduct(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Buy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _navigateBack(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () => _toggleFavorite(context),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         AppBar().preferredSize.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(),
                _buildPriceAndLocation(),
                _buildSellerAndQuantityActions(),
                _buildReviewSection(),
                _buildAboutOilSection(),
                _buildOtherProductsSection(),
                _buildBuyButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
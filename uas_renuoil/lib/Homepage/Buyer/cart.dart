import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/checkoutc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const BasketScreen(),
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.pricePerLiter * quantity;
}

class CartManager {
  static final List<CartItem> _cartItems = [];

  static List<CartItem> get cartItems => _cartItems;

  static void addToCart(CartItem newItem) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == newItem.product.id,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += newItem.quantity;
    } else {
      _cartItems.add(newItem);
    }
  }

  static void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  static void updateQuantity(int productId, int newQuantity) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity = newQuantity;
    }
  }

  static double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  static void clearCart() {
    _cartItems.clear();
  }
}

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  late List<bool> _isCheckedList; // Declare as late
  double _selectedTotal = 0.0; // Tracks the total of selected items

  @override
  void initState() {
    super.initState();
    // Initialize all items as checked by default
    _isCheckedList = List<bool>.filled(CartManager.cartItems.length, true);
    _calculateSelectedTotal(); // Calculate initial total
  }

  void _calculateSelectedTotal() {
    double total = 0.0;
    for (int i = 0; i < CartManager.cartItems.length; i++) {
      if (_isCheckedList[i]) {
        total += CartManager.cartItems[i].totalPrice;
      }
    }
    setState(() {
      _selectedTotal = total;
    });
  }

  // Update the checkbox state and recalculate total
  void _updateCheckbox(int index, bool? newValue) {
    setState(() {
      _isCheckedList[index] = newValue ?? false;
      _calculateSelectedTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.cartItems;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final containerWidth = isSmallScreen
                  ? screenSize.width * 0.95
                  : screenSize.width > 800
                      ? 600.0
                      : screenSize.width * 0.75;

              return Container(
                width: containerWidth,
                constraints: BoxConstraints(
                  maxHeight: screenSize.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.3),
                  //     spreadRadius: 1,
                  //     blurRadius: 5,
                  //     offset: const Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Column(
                  children: [
                    // App Bar
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0xFFE0E0E0),
                        //     spreadRadius: 0,
                        //     blurRadius: 1,
                        //     offset: Offset(0, 1),
                        //   ),
                        // ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Container(
                              width: 48, // Set the desired width
                              height: 48, // Set the desired height
                              alignment: Alignment
                                  .center, // Center the icon within the container
                              child: const Icon(
                                Icons.chevron_left,
                                size: 30, // Adjust the icon size if needed
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const Text(
                            'Basket',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 24),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        color: const Color(0xFFF5F5F5),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                          child: cartItems.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Your cart is empty',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Store section (group by seller if needed)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.emoji_events,
                                          color: Color(0xFFFFD700),
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            "Renuoil_offi",
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 14 : 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Product list
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: cartItems.length,
                                        itemBuilder: (context, index) {
                                          final item = cartItems[index];
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Checkbox
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 24),
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: Checkbox(
                                                        value: _isCheckedList[
                                                            index],
                                                        onChanged:
                                                            (bool? newValue) {
                                                          _updateCheckbox(
                                                              index, newValue);
                                                        },
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(4),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),

                                                  // Product image
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: item.product
                                                                .picture !=
                                                            null
                                                        ? Image.network(
                                                            item.product
                                                                .picture!,
                                                            width: isSmallScreen
                                                                ? 60
                                                                : 70,
                                                            height:
                                                                isSmallScreen
                                                                    ? 60
                                                                    : 70,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            Assets
                                                                .imagesProductMilk,
                                                            width: isSmallScreen
                                                                ? 60
                                                                : 70,
                                                            height:
                                                                isSmallScreen
                                                                    ? 60
                                                                    : 70,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  const SizedBox(width: 6),

                                                  // Product details
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                isSmallScreen
                                                                    ? 6
                                                                    : 8,
                                                            vertical:
                                                                isSmallScreen
                                                                    ? 4
                                                                    : 6,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFFF0F0F0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                item.product
                                                                    .name,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      isSmallScreen
                                                                          ? 12
                                                                          : 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                "Rp${item.product.pricePerLiter.toStringAsFixed(2)}/liter",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      isSmallScreen
                                                                          ? 12
                                                                          : 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),

                                                        // Quantity control
                                                        FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (item.quantity >
                                                                        1) {
                                                                      CartManager
                                                                          .updateQuantity(
                                                                        item.product
                                                                            .id,
                                                                        item.quantity -
                                                                            1,
                                                                      );
                                                                    } else {
                                                                      CartManager.removeFromCart(item
                                                                          .product
                                                                          .id);
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 24,
                                                                  height: 24,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  child: const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 14),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        3),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFE0E0E0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                ),
                                                                child: Text(
                                                                  "${item.quantity}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        isSmallScreen
                                                                            ? 12
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    CartManager
                                                                        .updateQuantity(
                                                                      item.product
                                                                          .id,
                                                                      item.quantity +
                                                                          1,
                                                                    );
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 24,
                                                                  height: 24,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  child: const Icon(
                                                                      Icons.add,
                                                                      size: 14),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 6),
                                                              Text(
                                                                "Liters",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      isSmallScreen
                                                                          ? 12
                                                                          : 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    // Checkout button (only shown if cart has items)
                    if (cartItems.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Create a properly typed list
                              final List<CartItem> selectedItems = [];
                              for (int i = 0;
                                  i < CartManager.cartItems.length;
                                  i++) {
                                if (_isCheckedList[i]) {
                                  selectedItems.add(CartManager.cartItems[i]);
                                }
                              }

                              if (selectedItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please select at least one item')),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutcPage(
                                    products: selectedItems,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD358),
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12 : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

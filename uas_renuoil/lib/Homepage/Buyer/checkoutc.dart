import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/detail.dart';
import 'package:flutter_application_1/Homepage/Buyer/enterpin.dart';
import 'package:flutter_application_1/Homepage/Buyer/cart.dart';
import 'package:flutter_application_1/Homepage/Buyer/checkout.dart';
import 'package:flutter_application_1/Homepage/Buyer/track2.dart';

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      tileColor: isSelected ? Colors.grey[200] : null,
      onTap: onTap,
    );
  }
}

class CheckoutService {
  // Method to save items to the cart one by one
  static Future<void> saveItemsToCart(
      List<CartItem> products, String token) async {
    for (var item in products) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product': item.product.id,
          'liters': item.quantity,
        }),
      );

      if (response.statusCode != 201) {
        final responseData = json.decode(response.body);
        throw Exception(
            'Failed to save item to cart: ${responseData['detail'] ?? responseData}');
      }
    }
  }

  // Method to handle checkout
  static Future<Map<String, dynamic>> checkoutMultiple({
    required List<CartItem> products,
    required String paymentMethod,
    required String shippingMethod,
    required String passcode,
    String? voucherCode,
  }) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');

    if (token == null) throw Exception('No access token found');

    try {
      // First, save items to the cart one by one
      await saveItemsToCart(products, token);
      print('ini dah masuk yg try yg checkout service');

      // Prepare request for checkout
      final request = {
        'payment_method': paymentMethod,
        'shipping_method': shippingMethod,
        'delivery_fee': shippingMethod == 'grab' ? 11000 : 10000,
        'passcode': passcode,
        if (voucherCode != null && voucherCode.isNotEmpty)
          'voucher': voucherCode,
      };

      print('ini yg final request dari checkout service $request');

      // Checkout request
      final response = await http.post(
        Uri.parse('$baseUrl/api/checkout/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(request),
      );

      // Handle response
      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        // Don't clear cart here - wait for confirmation
        return responseData;
      }

      throw Exception(responseData['detail'] ?? 'Checkout failed');
    } catch (e) {
      print('Checkout error: $e');
      rethrow;
    }
  }
}

class CheckoutcPage extends StatefulWidget {
  final List<CartItem> products;

  const CheckoutcPage({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<CheckoutcPage> createState() => _CheckoutcPageState();
}

class _CheckoutcPageState extends State<CheckoutcPage> {
  final storage = const FlutterSecureStorage();
  String? voucherCode;
  String paymentMethod = 'WALLET';
  String shippingMethod = 'gojek';
  int voucherDiscountPercent = 0;
  final TextEditingController _voucherController = TextEditingController();
  bool isLoading = false;
  bool _isLoading = true;
  String? _enteredPasscode;

  List<BankAccount> _bankAccounts = [];
  bool _isLoadingBanks = true;

  Map<String, String> personalInfo = {
    'Legal name': '',
    'Preferred first name': '',
    'Phone Number': '',
    'Email': '',
    'Address': '',
    'Emergency contact': '',
    'balance': '',
  };

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _fetchBankAccounts();
  }

  Color _getBankColor(String bankName) {
    switch (bankName.toLowerCase()) {
      case 'bca':
        return const Color(0xFFAFD2FF);
      case 'ocbc':
        return const Color(0xFFFFACAC);
      case 'mandiri':
        return const Color(0xFF00A651);
      case 'bni':
        return const Color(0xFFF58220);
      default:
        return Colors.grey[300]!;
    }
  }

  Future<void> fetchUserData() async {
    try {
      String? token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final userResponse = await http.get(
        Uri.parse('$baseUrl/auth/users/me/'),
        headers: headers,
      );

      final profileResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/profile/'),
        headers: headers,
      );

      if (userResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        final profileData = json.decode(profileResponse.body);

        setState(() {
          personalInfo['Email'] = userData['email'] ?? '';
          personalInfo['balance'] = userData['balance'] ?? '';

          personalInfo['Legal name'] = profileData['legal_name'] ?? '';
          personalInfo['Preferred first name'] =
              profileData['preferred_first_name'] ?? '';
          personalInfo['Phone Number'] = profileData['phone_number'] ?? '';
          personalInfo['Address'] = profileData['address'] ?? '';
          personalInfo['Emergency contact'] =
              profileData['emergency_contact'] ?? '';
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile or user info');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBankAccounts() async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No access token found');

      final response = await http.get(
        Uri.parse('$baseUrl/api/bank-accounts/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _bankAccounts =
              data.map((json) => BankAccount.fromJson(json)).toList();
          _isLoadingBanks = false;
        });
      } else {
        throw Exception('Failed to load bank accounts');
      }
    } catch (e) {
      print('Error fetching bank accounts: $e');
      setState(() => _isLoadingBanks = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bank accounts: ${e.toString()}')),
      );
    }
  }

  void _showPaymentSelectionPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // WALLET option
                  _PaymentOption(
                    icon: Icons.account_balance_wallet,
                    title: 'WALLET',
                    color: Colors.yellow[700]!,
                    isSelected: paymentMethod == 'WALLET',
                    onTap: () => setState(() => paymentMethod = 'WALLET'),
                  ),

                  // Bank options
                  _isLoadingBanks
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        )
                      : _bankAccounts.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('No bank accounts found'),
                            )
                          : Column(
                              children: _bankAccounts
                                  .map((bank) => _PaymentOption(
                                        icon: Icons.account_balance,
                                        title: bank.bankName,
                                        subtitle:
                                            '•••• ${bank.accountNumber.padLeft(4, '*').substring(bank.accountNumber.length.clamp(0, 4))}',
                                        color: _getBankColor(bank.bankName),
                                        isSelected:
                                            paymentMethod == bank.bankName,
                                        onTap: () => setState(() =>
                                            paymentMethod =
                                                bank.bankName.toLowerCase()),
                                      ))
                                  .toList(),
                            ),

                  const SizedBox(height: 20),

                  // Proceed to Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8D148),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.pop(context); // Close payment selection
                              _showPinEntryScreen(); // Show PIN entry screen
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityController(CartItem item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (item.quantity > 1) {
                CartManager.updateQuantity(
                  item.product.id,
                  item.quantity - 1,
                );
              } else {
                CartManager.removeFromCart(item.product.id);
              }
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(Icons.remove, size: 16),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${item.quantity}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              CartManager.updateQuantity(
                item.product.id,
                item.quantity + 1,
              );
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(Icons.add, size: 16),
          ),
        ),
      ],
    );
  }

  void _showPinEntryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasscodeScreen(
          onPinVerified: (pin) {
            setState(() => _enteredPasscode = pin);
            print('ini yg dari onPinVerified baru mau masuk ke process');
            _processCheckout();
            print('ini yg dari onPinVerified kelarrr');
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order cancelled')),
            );
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _processCheckout() async {
    setState(() => isLoading = true);
    print('ini dah masuk yg _processCheckout');

    try {
      if (_enteredPasscode == null || _enteredPasscode!.isEmpty) {
        throw Exception('Please enter your passcode');
      }

      print('ini dah masuk yg tryyyy di yg proccess apa');

      final response = await CheckoutService.checkoutMultiple(
        products: widget.products,
        paymentMethod: paymentMethod,
        shippingMethod: shippingMethod,
        passcode: _enteredPasscode!,
        voucherCode:
            _voucherController.text.isNotEmpty ? _voucherController.text : null,
      );

      // Convert string values to double
      double productTotalPrice = double.parse(response['product_total_price']);
      double deliveryFee = double.parse(response['delivery_fee']);
      double serviceFee = double.parse(response['service_fee']);
      double grandTotal = double.parse(response['grand_total']);

      print('ini yg response dari checkour progress apa $response');

      // Clear cart only after successful checkout
      CartManager.clearCart();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            grandTotal: grandTotal,
            voucherDiscountPercent: response['voucher_discount_percent'] ?? 0,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout failed: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double productTotal = widget.products.fold(
        0, (sum, item) => sum + (item.product.pricePerLiter * item.quantity));
    final double deliveryFee = shippingMethod == 'grab' ? 11000.0 : 10000.0;
    final double serviceFee = 1200.0;
    final double grandTotal = productTotal + deliveryFee + serviceFee;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAddressSection(),
                    _buildProductsList(),
                    _buildVoucherSection(),
                    _buildShippingMethods(),
                    _buildTotalsSection(
                      productTotal: productTotal,
                      deliveryFee: deliveryFee,
                      serviceFee: serviceFee,
                      grandTotal: grandTotal,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8D148),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoading ? null : _showPaymentSelectionPopup,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Payment',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
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

  Widget _buildProductsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFFFFD700)),
              const SizedBox(width: 8),
              Text(
                "Renuoil_offi",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.products.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildProductItem(item, index);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.product.picture != null
                ? Image.network(
                    item.product.picture!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    Assets.imagesProductMilk,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.product.address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Rp${item.product.pricePerLiter.toStringAsFixed(2)}/liter',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQuantityController(item, index),
                          const SizedBox(width: 3),
                          const Text('Liters'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personalInfo['Legal name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      personalInfo['Phone Number'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      personalInfo['Address'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voucher Code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _voucherController,
            onChanged: (value) {
              setState(() {
                voucherCode = value; // Save the voucher code
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter voucher code',
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingMethods() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping methods',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade100),
              color: Colors.grey.shade100,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: shippingMethod,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['gojek', 'grab'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value[0].toUpperCase() + value.substring(1), // Capitalize
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    shippingMethod = newValue!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection({
    required double productTotal,
    required double deliveryFee,
    required double serviceFee,
    required double grandTotal,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildPriceRow(
            label: 'Product Total',
            value: 'Rp${productTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildPriceRow(
            label: 'Delivery Fee',
            value: 'Rp${deliveryFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildPriceRow(
            label: 'Service Fee',
            value: 'Rp${serviceFee.toStringAsFixed(2)}',
          ),
          // const SizedBox(height: 8),
          // _buildPriceRow(
          //   label: 'Voucher Discount',
          //   value: '${voucherDiscountPercent}% off',
          // ),
          const SizedBox(height: 16),
          _buildPriceRow(
            label: 'Grand Total',
            value: 'Rp${grandTotal.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  final double grandTotal;
  final int voucherDiscountPercent;
  final List<Map<String, dynamic>>? items;

  const OrderConfirmationPage({
    Key? key,
    required this.grandTotal,
    required this.voucherDiscountPercent,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color(0xFFFCD34D), // Yellow background color
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success badge image
                Image.asset(
                  'assets/images/verified.png',
                  width: 120,
                  height: 120,
                ),

                const SizedBox(height: 40),

                // Order Confirmed text
                const Text(
                  'Order Confirmed',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                // Grand total
                Text(
                  'Grand Total: Rp${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // Voucher discount
                Text(
                  'Voucher discount: ${voucherDiscountPercent}%',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // Thank you message
                const Text(
                  'Thank you for shopping with us!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                // Fox mascot image
                Image.asset(
                  'assets/images/mascot.png',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 60),

                // Back to Homepage button
                Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuyerHomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Homepage',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Track Your Order button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderTrackingScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Track Your Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class OrderConfirmationPage extends StatelessWidget {
//   final double grandTotal;
//   final int voucherDiscountPercent;
//   final List<Map<String, dynamic>>? items;

//   const OrderConfirmationPage({
//     Key? key,
//     required this.grandTotal,
//     required this.voucherDiscountPercent,
//     this.items,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 100),
//               const SizedBox(height: 20),
//               const Text(
//                 'Order Confirmed!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Show ordered items if available
//               if (items != null) ...[
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Ordered Items:',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       ...items!
//                           .map((item) => ListTile(
//                                 leading: item['photo_url'] != null
//                                     ? Image.network(item['photo_url'],
//                                         width: 50, height: 50)
//                                     : const Icon(Icons.shopping_basket),
//                                 title: Text(item['product']),
//                                 subtitle: Text('${item['liters']} liters'),
//                                 trailing: Text('Rp${item['total']}'),
//                               ))
//                           .toList(),
//                     ],
//                   ),
//                 ),
//               ],

//               // Show totals
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildPriceRow(
//                       label: 'Product Total',
//                       value: 'Rp${grandTotal.toStringAsFixed(2)}',
//                     ),
//                     const SizedBox(height: 8),
//                     _buildPriceRow(
//                       label: 'Voucher Discount',
//                       value: '$voucherDiscountPercent%',
//                     ),
//                     const SizedBox(height: 16),
//                     _buildPriceRow(
//                       label: 'Grand Total',
//                       value: 'Rp${grandTotal.toStringAsFixed(2)}',
//                       isBold: true,
//                     ),
//                   ],
//                 ),
//               ),

//               // Back to home button
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.popUntil(
//                     context,
//                     (route) => route.isFirst,
//                   ),
//                   child: const Text('Back to Home'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceRow({
//     required String label,
//     required String value,
//     bool isBold = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }
// }

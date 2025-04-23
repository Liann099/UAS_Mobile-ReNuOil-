import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:flutter_application_1/Homepage/Buyer/default.dart';
import 'package:flutter_application_1/Homepage/Buyer/detail.dart';
import 'package:flutter_application_1/Homepage/Buyer/enterpin.dart';

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

class BankAccount {
  final int id;
  final String bankName;
  final String accountHolder;
  final String accountNumber;
  final String? branchCode;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountHolder,
    required this.accountNumber,
    this.branchCode,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      bankName:
          json['bank_name'], // Make sure these keys match your API response
      accountHolder: json['account_holder'],
      accountNumber: json['account_number'],
      branchCode: json['branch_code'],
    );
  }
  @override
  String toString() {
    return 'BankAccount{id: $id, bankName: $bankName, accountNumber: $accountNumber}';
  }
}

class CheckoutPage extends StatefulWidget {
  final Product product;
  final int initialQuantity;

  const CheckoutPage({
    Key? key,
    required this.product,
    this.initialQuantity = 1,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final storage = const FlutterSecureStorage();
  late int quantity;
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
  };

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
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
                                       subtitle: '•••• ${bank.accountNumber.padLeft(4, '*').substring(bank.accountNumber.length.clamp(0, 4))}',

                                        color: _getBankColor(bank.bankName),
                                        isSelected:
                                            paymentMethod == bank.bankName,
                                        onTap: () => setState(() =>
                                            paymentMethod = bank.bankName),
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

  void _showPinEntryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasscodeScreen(
          onPinVerified: (pin) {
            // PIN verified, proceed with checkout
            setState(() => _enteredPasscode = pin);
            _processCheckout();
          },
          onCancel: () {
            // User cancelled PIN entry
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
    final token = await storage.read(key: 'access_token');

    try {
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'product_id': widget.product.id.toString(),
        'quantity': quantity,
        'payment_method': paymentMethod,
        'shipping_method': shippingMethod,
        'passcode': _enteredPasscode, // This will be set from the PIN screen
      };

      // Only add voucher_code if not empty
      if (_voucherController.text.isNotEmpty) {
        requestBody['voucher'] = _voucherController.text;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/1checkout/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Debug prints
      print('Request Body: ${json.encode(requestBody)}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final double grandTotal = responseData['grand_total'];
        final int voucherDiscountPercent =
            responseData['voucher_discount_percent'] ?? 0;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationPage(
              grandTotal: grandTotal,
              voucherDiscountPercent: voucherDiscountPercent,
            ),
          ),
        );
      } else {
        dynamic errorData;
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          errorData = {'detail': 'Invalid server response'};
        }

        String errorMessage = errorData['detail'] ??
            errorData['message'] ??
            'Checkout failed (Status ${response.statusCode})';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } on http.ClientException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double productTotal = widget.product.pricePerLiter * quantity;
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
                    _buildProductCard(),
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

  Widget _buildProductCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
              ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.product.picture != null
                    ? Image.network(
                        widget.product.picture!,
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
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp${widget.product.pricePerLiter.toStringAsFixed(2)}/liter',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => quantity++),
                            ),
                            const Text('Liters'),
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

  const OrderConfirmationPage({
    Key? key,
    required this.grandTotal,
    required this.voucherDiscountPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Order Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Grand Total: Rp${grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Voucher Discount: $voucherDiscountPercent%',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(
                context,
                (route) => route.isFirst,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

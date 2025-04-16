import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const UploadProductScreen(),
    );
  }
}

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  // Controllers & State
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  
  // Constants & Variables
  final int _maxCharacters = 500;
  final int _maxPhotos = 4;
  final List<String> _photos = [];

  // Styles
  final _borderRadius = BorderRadius.circular(8.0);
  final _borderColor = Colors.grey[300]!;
  final _focusedBorderColor = Colors.grey[400]!;
  final _hintColor = Colors.grey[400];
  final _labelStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  final _counterStyle = TextStyle(
    fontSize: 12.0,
    color: Colors.grey[600],
  );

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateCharCount);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.removeListener(_updateCharCount);
    _descriptionController.dispose();
    _stockController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {});
  }

  void _addPhotos() {
    if (_photos.length < _maxPhotos) {
      setState(() {
        _photos.add("dummy_photo");
      });
    }
  }

  // UI Component builders
  Widget _buildSectionTitle(String title) {
    return Text(title, style: _labelStyle);
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    EdgeInsetsGeometry? contentPadding,
    TextAlign textAlign = TextAlign.start,
    bool hasBorder = true,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: _hintColor),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        border: hasBorder ? OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: _borderColor),
        ) : InputBorder.none,
        enabledBorder: hasBorder ? OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: _borderColor),
        ) : InputBorder.none,
        focusedBorder: hasBorder ? OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: _focusedBorderColor),
        ) : InputBorder.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                
                const SizedBox(height: 16.0),
                
                // Title
                const Text(
                  'Upload Product',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 24.0),
                
                // Product Name Section
                _buildSectionTitle('Product Name'),
                const SizedBox(height: 8.0),
                _buildInputField(
                  controller: _productNameController,
                  hintText: 'example : Coconut Oil',
                ),
                
                const SizedBox(height: 24.0),
                
                // Product Photos Section
                _buildSectionTitle('Product Photos'),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: _addPhotos,
                  child: Container(
                    width: double.infinity,
                    height: 88.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: _borderColor),
                      borderRadius: _borderRadius,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.amber[400],
                          size: 32.0,
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Add Photos',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Maximal $_maxPhotos photos',
                  style: _counterStyle,
                ),
                
                const SizedBox(height: 24.0),
                
                // Description Section
                _buildSectionTitle('Description'),
                const SizedBox(height: 8.0),
                Stack(
                  children: [
                    TextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      maxLines: 5,
                      maxLength: _maxCharacters,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: _borderRadius,
                          borderSide: BorderSide(color: _borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: _borderRadius,
                          borderSide: BorderSide(color: _borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: _borderRadius,
                          borderSide: BorderSide(color: _focusedBorderColor),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Text(
                        '${_descriptionController.text.length}/$_maxCharacters',
                        style: _counterStyle,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24.0),
                
                // Stock Section
                Row(
                  children: [
                    Text('Stock : ', style: _labelStyle),
                    const SizedBox(width: 12.0),
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: _borderColor),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: _buildInputField(
                        controller: _stockController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        contentPadding: EdgeInsets.zero,
                        hasBorder: false,
                      ),
                    ),
                  ],
                ),
                
                // Space for bottom button
                const SizedBox(height: 150.0),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _handleUpload,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[300],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: _borderRadius,
            ),
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            elevation: 0,
          ),
          child: const Text(
            'Upload',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  
  void _handleUpload() {
    // Validasi input
    if (_productNameController.text.isEmpty) {
      _showErrorMessage('Nama produk tidak boleh kosong');
      return;
    }
    
    // Logika upload produk
    print('Uploading product: ${_productNameController.text}');
    print('Description: ${_descriptionController.text}');
    print('Stock: ${_stockController.text}');
    print('Photos: $_photos');
    
    // Implementasi upload ke server bisa ditambahkan di sini
  }
  
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
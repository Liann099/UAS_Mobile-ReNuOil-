import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_symbols_icons/symbols.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  // Toggle states
  bool loadMoreEnabled = true;
  bool mapZoomControlsEnabled = true;
  bool mapPanControlsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Symbols.arrow_back_ios_new, size: 24),
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Accessibility',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 16,),

              // Load more setting
              AccessibilitySettingItem(
                title: 'Load more',
                description: 'Prefer a "Load more" button over infinite scroll in places with long lists such as Messages and Listings tab',
                isEnabled: loadMoreEnabled,
                onChanged: (value) {
                  setState(() {
                    loadMoreEnabled = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Map zoom controls setting
              AccessibilitySettingItem(
                title: 'Map zoom controls',
                description: 'Zoom in and out with dedicated buttons',
                isEnabled: mapZoomControlsEnabled,
                onChanged: (value) {
                  setState(() {
                    mapZoomControlsEnabled = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Map pan controls setting
              AccessibilitySettingItem(
                title: 'Map pan controls',
                description: 'Pan around the map with directional buttons',
                isEnabled: mapPanControlsEnabled,
                onChanged: (value) {
                  setState(() {
                    mapPanControlsEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccessibilitySettingItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isEnabled;
  final Function(bool) onChanged;

  const AccessibilitySettingItem({
    super.key,
    required this.title,
    required this.description,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 12,),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CupertinoSwitch(
          value: isEnabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
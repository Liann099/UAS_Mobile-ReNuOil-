import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_symbols_icons/symbols.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isBuyNotificationsEnabled = true;
  bool isSellNotificationsEnabled = true;

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
                  'Notifications',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Buy notifications section
              NotificationItem(
                title: 'Your buy history',
                subtitle: 'Click here to on/off your buy notifications',
                isEnabled: isBuyNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    isBuyNotificationsEnabled = value;
                  });
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(color: Colors.grey, thickness: 0.5),
              ),

              // Sell notifications section
              NotificationItem(
                title: 'Your sell notification',
                subtitle: 'Click here to on/off your sell notifications',
                isEnabled: isSellNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    isSellNotificationsEnabled = value;
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

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const NotificationItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: isEnabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
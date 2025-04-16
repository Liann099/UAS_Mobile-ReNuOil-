import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrackOrderPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}

class TrackOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC95C),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Start your search',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(Icons.home, 'Home'),
                  _buildNavItem(Icons.account_balance_wallet, 'Balance'),
                  _buildNavItem(Icons.arrow_circle_up, 'Withdraw'),
                  _buildNavItem(Icons.history, 'History'),
                  _buildNavItem(Icons.local_shipping, 'Track', isSelected: true),
                ],
              ),
            ),

            // Track Your Order Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Track Your Order',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Order Tracking Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Order Header
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '#1945',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Cooking Oil - Renewable',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/logo.png'),
                                  ),
                                ],
                              ),
                            ),

                            // Tracking Progress
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text('20 Feb, 25\nJakarta'),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 4,
                                            color: Colors.grey[300],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text('23 Feb, 25\nHome'),
                                ],
                              ),
                            ),

                            // Truck Icon
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Icon(
                                Icons.local_shipping,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Detailed Tracking
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              _buildTrackingStep(
                                date: '20 Feb, 25',
                                time: '10:45 AM',
                                location: 'Drop Off',
                                detail: 'Silambat Jakarta',
                                isActive: true,
                              ),
                              _buildTrackingStep(
                                date: '20 Feb, 25',
                                time: '7:00 PM',
                                location: 'Sorting Center',
                                detail: 'DC Cakung',
                                isActive: true,
                              ),
                              _buildTrackingStep(
                                date: '21 Feb, 25',
                                location: 'Sorting Center',
                                detail: 'DC BSD',
                                isActive: false,
                              ),
                              _buildTrackingStep(
                                date: '23 - 24 Feb, 25',
                                location: 'Home',
                                detail: 'B Residence BSD City',
                                isActive: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.black : Colors.black45,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black45,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingStep({
    required String date,
    String? time,
    required String location,
    required String detail,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Line and Dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.yellow : Colors.grey[300],
                ),
              ),
              Container(
                width: 2,
                height: 80,
                color: Colors.grey[300],
              ),
            ],
          ),

          // Content
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (time != null)
                  Text(
                    time,
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  location,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.grey,
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
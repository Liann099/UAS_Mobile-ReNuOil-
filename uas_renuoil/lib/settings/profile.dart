import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:convert';
import '../constants.dart';

final storage = FlutterSecureStorage();
Future<Map<String, dynamic>> fetchUsername() async {
  print("Fetching username...");

  String? token = await storage.read(key: 'access_token');
  print("Access token: $token");

  if (token == null) {
    throw Exception('No access token found');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/auth/users/me/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load username: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> fetchProfile() async {
  print("Fetching profile...");

  String? token = await storage.read(key: 'access_token');
  print("Access token: $token");

  if (token == null) {
    throw Exception('No access token found');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/api/auth/profile/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load profile: ${response.statusCode}');
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD358),
        leading: IconButton(
          icon:
              const Icon(Symbols.arrow_back_ios_new_sharp, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Symbols.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Settings'),
            SettingsItem(
              icon: Symbols.people,
              title: 'Personal information',
              onTap: () => Navigator.pushNamed(context, '/personal-info'),
            ),
            SettingsItem(
              icon: Icons.shield_outlined,
              title: 'Login and Security',
              onTap: () => Navigator.pushNamed(context, '/login-security'),
            ),
            SettingsItem(
              icon: Icons.shield_outlined,
              title: 'Privacy and Sharing',
              onTap: () => Navigator.pushNamed(context, '/privacy-sharing'),
            ),
            SettingsItem(
              icon: Icons.translate_outlined,
              title: 'Translation',
              onTap: () => Navigator.pushNamed(context, '/translation'),
            ),
            SettingsItem(
              icon: Icons.credit_card_outlined,
              title: 'Payments and payouts',
              onTap: () => Navigator.pushNamed(context, '/payment-payouts'),
            ),
            SettingsItem(
              icon: Icons.accessibility_outlined,
              title: 'Accessibility',
              onTap: () => Navigator.pushNamed(context, '/accessibility'),
            ),
            SettingsItem(
              icon: Icons.history_outlined,
              title: 'History',
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            SettingsItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => Navigator.pushNamed(context, '/notification'),
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Support'),
            SettingsItem(
              icon: Icons.help_outline,
              title: 'Visit the Help Center',
              onTap: () => Navigator.pushNamed(context, '/help-center'),
            ),
            SettingsItem(
              icon: Icons.edit_outlined,
              title: 'Give us feedback',
              onTap: () => Navigator.pushNamed(context, '/feedback-form'),
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Legal'),
            SettingsItem(
              icon: Icons.article_outlined,
              title: 'Terms of Service',
              onTap: () => Navigator.pushNamed(context, '/terms-of-service'),
            ),
            SettingsItem(
              icon: Icons.article_outlined,
              title: 'Privacy Policy',
              onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  await storage.delete(key: 'access_token');
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'VERSION 25.05 (240122)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late Future<Map<String, dynamic>> futureProfile;
  late Future<Map<String, dynamic>> futureUsername;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
    futureUsername = fetchUsername();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([futureProfile, futureUsername]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Error loading profile',
              style: TextStyle(color: Colors.red[600]),
            ),
          );
        }

        final profile = snapshot.data![0]; // First future result (profile)
        final usernameData =
            snapshot.data![1]; // Second future result (username)
        final profilePicture = profile['profile_picture'];
        final username = usernameData['username'] ?? 'Guest User';

        return InkWell(
          onTap: () => Navigator.pushNamed(context, '/create-profile'),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                profilePicture != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(profilePicture),
                      )
                    : const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        child:
                            Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username, // Using username from the users/me endpoint
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Show profile',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class PromotionBanner extends StatelessWidget {
//   const PromotionBanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       height: 150,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.blue[100],
//               ),
//               child: const Center(
//                 child: Text(
//                   'Promotion 1',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.pink[100],
//               ),
//               child: const Center(
//                 child: Text(
//                   'Promotion 2',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

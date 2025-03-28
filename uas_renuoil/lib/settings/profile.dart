import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/assets.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
            const ProfileHeader(
              name: 'Matt',
              subtitle: 'Show profile',
            ),
            const SizedBox(height: 20),
            const PromotionBanner(),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Settings'),
            SettingsItem(
              icon: Symbols.people,
              title: 'Personal information',
              onTap: () {
                Navigator.pushNamed(context, '/personal-info');
              },
            ),
            SettingsItem(
              icon: Icons.shield_outlined,
              title: 'Login and Security',
              onTap: () {
                Navigator.pushNamed(context, '/login-security');
              },
            ),
            SettingsItem(
              icon: Icons.shield_outlined,
              title: 'Privacy and Sharing',
              onTap: () {
                Navigator.pushNamed(context, '/privacy-sharing');
              },
            ),
            SettingsItem(
              icon: Icons.translate_outlined,
              title: 'Translation',
              onTap: () {
                Navigator.pushNamed(context, '/translation');
              },
            ),
            SettingsItem(
              icon: Icons.credit_card_outlined,
              title: 'Payments and payouts',
              onTap: () {
                Navigator.pushNamed(context, '/payment-payouts');
              },
            ),
            SettingsItem(
              icon: Icons.accessibility_outlined,
              title: 'Accessibility',
              onTap: () {
                Navigator.pushNamed(context, '/accessibility');
              },
            ),
            SettingsItem(
              icon: Icons.history_outlined,
              title: 'History',
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            SettingsItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Support'),
            SettingsItem(
              icon: Icons.help_outline,
              title: 'Visit the Help Center',
              onTap: () {},
            ),
            SettingsItem(
              icon: Icons.edit_outlined,
              title: 'Give us feedback',
              onTap: () {
                Navigator.pushNamed(context, '/feedback-form');
              },
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Legal'),
            SettingsItem(
              icon: Icons.article_outlined,
              title: 'Terms of Service',
              onTap: () {
                Navigator.pushNamed(context, '/terms-of-service');
              },
            ),
            SettingsItem(
              icon: Icons.article_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.pushNamed(context, '/privacy-policy');
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Handle logout logic
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
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

class ProfileHeader extends StatelessWidget {
  final String name;
  final String subtitle;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
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
    );
  }
}

class PromotionBanner extends StatelessWidget {
  const PromotionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(Assets.imagesPromo30),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'SALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(Assets.imagesPromo30),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

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